########################################################
## 2019 polling place first preferences
##
## simon jackman
## simon.jackman@sydney.edu.au
##
## 2022-05-28 21:42:22
########################################################

library(tidyverse)
library(here)

theURL <- "https://results.aec.gov.au/24310/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-24310-XXXX.csv"
theStates <- c("NSW","VIC","QLD","WA","SA","TAS","ACT","NT")
v2019_fp_type <- list()
for(s in theStates){
  v2019_fp_type[[s]] <- read_csv(url(str_replace(theURL,pattern="XXXX",replacement = s)),skip=1)
}

v2019_fp_type <- bind_rows(v2019_fp_type) %>%
  rename(Division=DivisionNm) %>%
  mutate(ppvc = grepl(PollingPlace,pattern="PPVC"))

write_fst(v2019_fp_type,path=here("data/2019/fp_pp.fst"))

## first prefs by candidate by type
theURL <- "https://results.aec.gov.au/24310/Website/Downloads/HouseFirstPrefsByCandidateByVoteTypeDownload-24310.csv"
tmp <- read_csv(url(theURL),skip=1) %>%
  rename(Division=DivisionNm,candidate_id=CandidateID) %>%
  pivot_longer(cols=ends_with("Votes"),names_to = "Type",values_to = "v")

v2019_type_national <- bind_rows(
  read_fst(path=here("data/2019/fp_pp.fst")) %>%
                   group_by(ppvc) %>%
                   summarise(v=sum(OrdinaryVotes)) %>%
                   ungroup() %>%
                   mutate(Type=if_else(ppvc,"PPVC","PollingPlace")),
                 tmp %>%
                   group_by(Type) %>%
                   summarise(v=sum(v)) %>%
                   ungroup()
  ) %>%
  select(-ppvc)

check <- bind_rows(
  read_fst(path=here("data/2019/fp_pp.fst")) %>%
    mutate(Type=if_else(ppvc,"PPVC","PollingPlace")) %>%
    select(Division,Type,v=OrdinaryVotes) %>%
    group_by(Division,Type) %>%
    summarise(v=sum(v)) %>%
    ungroup(),
  tmp %>%
    select(Division,Type,v) %>%
    group_by(Division,Type) %>%
    summarise(v=sum(v)) %>%
    ungroup(),
  ) %>%
  pivot_wider(id_cols = "Division",names_from = "Type",values_from = "v") %>%
  group_by(Division) %>%
  summarise(bad = PPVC + PollingPlace != OrdinaryVotes) %>%
  ungroup() %>%
  filter(bad)

v2019_type_national <- v2019_type_national %>%
  filter(Type!="OrdinaryVotes" & Type!="TotalVotes") %>%
  mutate(per = v/sum(v)*100)

save("v2019_type_national",file=here("data/2019/v2019_type_national.RData"))

candidates_2019 <- read_csv(
  url("https://results.aec.gov.au/24310/Website/Downloads/HouseCandidatesDownload-24310.csv"),
  skip=1) %>%
  mutate(incumbent = if_else(HistoricElected=="Y","true","false")) %>%
  rename(candidate_id=CandidateID)

## divisional-level
v2019_type <- bind_rows(
  read_fst(path=here("data/2019/fp_pp.fst")) %>%
    rename(candidate_id=CandidateID) %>%
    group_by(Division,candidate_id,ppvc) %>%
    summarise(v=sum(OrdinaryVotes)) %>%
    ungroup() %>%
    mutate(Type=if_else(ppvc,"PPVC","PollingPlace")),
  tmp %>%
    group_by(Division,candidate_id,Type) %>%
    summarise(v=sum(v)) %>%
    ungroup()
) %>%
  select(-ppvc) %>%
  left_join(
    tmp %>%
      select(Division,candidate_id,Surname,
             PartyAb,PartyNm) %>%
      distinct(),
    by = c("Division","candidate_id")
  ) %>%
  filter(!is.na(PartyAb)) %>%
  mutate(party_group = case_when(
    PartyAb=="ALP" ~ "Labor",
    PartyAb=="GRN" ~ "GRN",
    PartyAb=="IND" | (Surname == "SHARKIE" & Division=="Mayo") ~ "IND",
    PartyAb %in% c("LP","LNP","NP","CLP") ~ "Coalition",
    TRUE ~ "OTH"
  )) %>%
  arrange(Division,candidate_id,Type) %>%
  mutate(Type = str_replace(pattern="Votes$",replacement = "",Type)) %>%
  filter(Type!="Total")

check <- v2019_type %>%
  pivot_wider(id_cols=c(Division,candidate_id),names_from = Type,values_from = v) %>%
  group_by(Division,candidate_id) %>%
  summarise(flag = Ordinary != PollingPlace + PPVC) %>%
  ungroup() %>%
  filter(flag)

v2019_type <- v2019_type %>%
  filter(Type!="Ordinary") %>%
  left_join(candidates_2019 %>%
              select(candidate_id,incumbent),
            by="candidate_id")

v2019_type_perf <- bind_cols(
  v2019_type,
  v2019_type %>%
    sjmisc::to_dummy(Type,suffix="label")
) %>%
  pivot_longer(cols=starts_with("Type_"),
               names_to = "j",
               values_to = "k") %>%
  mutate(k = ifelse(k==1,"this","others")) %>%
  group_by(Division,j,k,candidate_id) %>%
  summarise(v=sum(v)) %>%
  ungroup() %>%
  group_by(Division,j,k) %>%
  mutate(p=v/sum(v)*100) %>%
  ungroup() %>%
  pivot_wider(id_cols=c(Division,j,candidate_id),
              names_from = k,
              values_from = p) %>%
  mutate(delta = this-others) %>%
  mutate(j = str_remove(j,pattern="Type_")) %>%
  pivot_wider(id_cols = c(Division,candidate_id),
              names_from = j,values_from = delta) %>%
  left_join(v2019_type %>%
              select(candidate_id,party_group) %>%
              distinct(),
            by=("candidate_id")) %>%
  left_join(candidates_2019 %>%
              select(candidate_id,incumbent),
            by="candidate_id")

save("v2019_type","v2019_type_perf",file=here("data/2019/v2019_type.RData"))



