########################################################
## 2019 postal issued/received
##
## simon jackman
## simon.jackman@sydney.edu.au
##
## 2022-05-23 16:30:59
########################################################

library(tidyverse)
library(here)

## 2019 postal issued vs received
issued_2019 <- read_csv(skip=1,
                        url("https://results.aec.gov.au/24310/Website/Downloads/GeneralDecVotesIssuedByDivisionDownload-24310.csv")) %>%
  rename(Division=DivisionNm) %>%
  filter(DivisionID!=0) %>%
  select(Division,Provisional,Absent,Postal=PostalOwnDivision) %>%
  pivot_longer(cols=c("Provisional","Absent","Postal"),
               names_to = "type",
               values_to = "issued")

received_2019 <- read_csv(skip=1,
                          url("https://results.aec.gov.au/24310/Website/Downloads/GeneralDecVotesReceivedByDivisionDownload-24310.csv")) %>%
  rename(Division=DivisionNm) %>%
  filter(DivisionID!=0)

counted_2019 <- read_csv(skip=1,
                         url("https://results.aec.gov.au/24310/Website/Downloads/HouseTcpByCandidateByVoteTypeDownload-24310.csv")) %>%
  rename(Division=DivisionNm) %>%
  filter(DivisionID!=0) %>%
  select(Division,ends_with("Votes"),-Swing) %>%
  pivot_longer(cols=ends_with("Votes"),names_to = "type",values_to = "counted") %>%
  group_by(Division,type) %>%
  summarise(counted=sum(counted)) %>%
  ungroup() %>%
  filter(type!="TotalVotes" & type!="OrdinaryVotes" & type!="PrePollVotes") %>%
  mutate(type = str_remove(type,pattern="Votes$"))


## for declaration pre-poll, compute as a proportion of enrolled?
pre_poll_dec_2019 <- read_csv(skip=1,
                     url("https://results.aec.gov.au/24310/Website/Downloads/GeneralEnrolmentByDivisionDownload-24310.csv")) %>%
  rename(Division=DivisionNm) %>%
  filter(DivisionID!=0) %>%
  select(Division,Enrolment) %>%
  left_join(read_csv(skip=1,
                     url("https://results.aec.gov.au/24310/Website/Downloads/HouseTcpByCandidateByVoteTypeDownload-24310.csv")) %>%
              rename(Division=DivisionNm) %>%
              filter(DivisionID!=0) %>%
              select(Division,ends_with("Votes"),-Swing) %>%
              pivot_longer(cols=ends_with("Votes"),names_to = "type",values_to = "counted") %>%
              group_by(Division,type) %>%
              summarise(counted=sum(counted)) %>%
              ungroup() %>%
              filter(type=="PrePollVotes"),
            by="Division") %>%
  mutate(pre_poll_dec_rate = counted/Enrolment)

dec_2019_count_rate <- left_join(issued_2019,
                                 counted_2019,
                                 by=c("Division","type")) %>%
  mutate(count_rate = counted/issued)


dec_2019_count_rate_summary <- dec_2019_count_rate %>%
  group_by(type) %>%
  summarise(rate_mean = mean(count_rate),
            rate_min = min(count_rate),
            rate_10 = quantile(count_rate,.10),
            rate_90 = quantile(count_rate,.90),
            rate_max = max(count_rate)
            ) %>%
  ungroup()


## deltas across vote types
tcp_by_type_2019 <- read_csv(skip=1,
                             url("https://results.aec.gov.au/24310/Website/Downloads/HouseTcpByCandidateByVoteTypeDownload-24310.csv"))

tcp_by_type_2019 <- tcp_by_type_2019 %>%
  rename(Division=DivisionNm) %>%
  select(-DivisionID,-CandidateID) %>%
  pivot_longer(cols=ends_with("Votes"),
               names_to = "type",
               values_to = "v") %>%
  group_by(Division,type) %>%
  mutate(p=v/sum(v)*100) %>%
  ungroup()

mydiff <- function(x){x[1]-x[2]}
my_weight_proportion <- function(x){x[3]*x[4]}
look_by_type <- function(theDivision){
  tmp1 <- tcp_by_type_2019 %>%
    filter(Division==theDivision) %>%
    pivot_wider(id_cols=c("Division","Surname","PartyAb"),
                names_from = "type",
                values_from = "p")
  tmp1_margin <- tmp1 %>%
    summarise(across(where(is.double),~mydiff(.x))) %>%
    mutate(Surname="∆")

  tmp2 <- tcp_by_type_2019 %>%
    filter(Division==theDivision) %>%
    group_by(type) %>%
    summarise(Division=Division[1],
              v=sum(v)) %>%
    ungroup() %>%
    filter(type!="TotalVotes") %>%
    mutate(p=v/sum(v)) %>%
    pivot_wider(id_cols="Division",
                names_from = "type",
                values_from = "p") %>%
    mutate(Surname="Proportion")

 tmp <- bind_rows(tmp1,tmp1_margin,tmp2)
 tmp <- bind_rows(tmp,
                  tmp %>%
                    summarise(across(where(is.double),~my_weight_proportion(.x))))

 return(tmp)
}


demo_classification_2019 <- xlsx::read.xlsx(file="~/Downloads/previous-demographic-classifications-electoral-divisions-pre-2-august-2021/01-demographic-classification-as-at-1-january-2019.xlsx",
                                            sheetIndex =1,
                                            startRow = 4)
names(demo_classification_2019) <- c("Division","class","State")

## model of swing by type conditional on other stuff
masterData <- read_csv(skip=1,
                       url("https://results.aec.gov.au/24310/Website/Downloads/HouseTcpByCandidateByVoteTypeDownload-24310.csv")) %>%
  rename(Division=DivisionNm) %>%
  left_join(demo_classification_2019 %>%
              select(Division,class),
            by="Division")


typeofContest <- masterData %>%
  group_by(Division) %>%
  summarise(contest_type = case_when(
    any(c("LP","LNP","NP","CLP") %in% PartyAb) & "ALP" %in% PartyAb ~ "LIB-LAB",
    any(c("LP","LNP","NP","CLP") %in% PartyAb) & any(c("IND","XEN","ON","GRN","KAP") %in% PartyAb) ~ "LIB-OTH",
    all(c("ALP","GRN") %in% PartyAb) ~ "ALP-GRN",
    "ALP" %in% PartyAb & any(c("IND","ON","XEN") %in% PartyAb) ~ "ALP-OTH",
    TRUE ~ "Unclassified")
  ) %>%
  ungroup()

masterData <- left_join(masterData,
                        typeofContest,
                        by="Division")

tmp <- masterData %>%
  select(-Swing) %>%
  pivot_longer(cols=ends_with("Votes"),names_to = "type",values_to = "v") %>%
  mutate(type = str_remove(type,"Votes$")) %>%
  group_by(Division,type) %>%
  mutate(p=v/sum(v)*100) %>%
  ungroup() %>%
  select(Division,PartyAb,class,contest_type,type,v,p)

masterData <- left_join(tmp,
                        tmp %>%
                          filter(type=="Ordinary") %>%
                          select(Division,PartyAb,p_ord=p),
                        by=c("Division","PartyAb")
                        ) %>%
  filter(type!="Total") %>%
  mutate(major_party = fct_recode(PartyAb,
                                  ALP="ALP",
                                  Coalition="LP",
                                  Coalition="NP",
                                  Coalition="CLP",
                                  Coalition="LNP"))

models <- list()
models <- masterData %>%
  group_nest(type,major_party)


