########################################################
## read features of CEDs file
##
## simon jackman
##
##
## 2022-11-03 18:08:46.336717
########################################################

library(tidyverse)
library(here)

## block read of place of enumeration files
thePath <- here("data/2022/CED_Census/2021_PEP_CED_for_AUS_short-header/2021 Census PEP Commonwealth Electroral Division for AUS")

theFiles <- list.files(path=thePath,pattern="*.csv")

foo <- list()
for(f in theFiles){
  foo[[f]] <- read_csv(file = paste(thePath,f,sep="/"))
}

## big left_join
foo_all <- Reduce(
  f = function(dtf1,dtf2){
    left_join(dtf1,dtf2,
              by = "CED_CODE_2021")
  },
  foo) %>%
  janitor::remove_empty("cols") %>%
  janitor::remove_constant()

save(foo_all,file=here("data/2022/CED_Census/ced_pep.RData"))
ced_pep <- foo_all

## block read general community profile files
thePath <- here("data/2022/CED_Census/2021_GCP_CED_for_AUS_short-header/2021 Census GCP Commonwealth Electroral Division for AUS")
theFiles <- list.files(path=thePath,pattern="*.csv")

foo <- list()
for(f in theFiles){
  foo[[f]] <- read_csv(file = paste(thePath,f,sep="/"))
}

## big left_join
foo_all <- Reduce(
  f = function(dtf1,dtf2){
    left_join(dtf1,dtf2,
              by = "CED_CODE_2021")
  },
  foo) %>%
  janitor::remove_empty("cols") %>%
  janitor::remove_constant()

save(foo_all,file=here("data/2022/CED_Census/ced_gcp.RData"))
ced_gcp <- foo_all

## merge on political variables
fp <- read_csv(
  file = url(
    "https://results.aec.gov.au/27966/Website/Downloads/HouseFirstPrefsByCandidateByVoteTypeDownload-27966.csv"
  ),
  skip = 1
) %>%
  select(
    StateAb,
    DivisionNm,
    Surname,
    GivenNm,
    PartyAb,
    BallotPosition,
    Elected,
    HistoricElected,
    TotalVotes
  ) %>%
  mutate(PartyAb = if_else(is.na(PartyAb),"INF",PartyAb)) %>%
  mutate(TotalVotes = if_else(is.na(TotalVotes),0,TotalVotes)) %>%
  group_by(DivisionNm,PartyAb) %>%
  summarise(TotalVotes = sum(TotalVotes),
            StateAb = StateAb[1],
            HistoricElected = HistoricElected[1],
            BallotPosition = BallotPosition[1]) %>%
  ungroup() %>%
  group_by(DivisionNm) %>%
  mutate(per = if_else(
    BallotPosition == 999,
    TotalVotes / sum(TotalVotes) * 100,
    TotalVotes / sum(TotalVotes[BallotPosition != 999]) * 100
  )) %>%
  ungroup() %>%
  pivot_wider(id_cols = c("StateAb","DivisionNm"),
              names_from = "PartyAb",
              values_from = c("per","BallotPosition","HistoricElected"))

tpp <- read_csv(
  file = url(
    "https://results.aec.gov.au/27966/Website/Downloads/HouseTppByDivisionDownload-27966.csv"
  ),
  skip = 1
) %>%
  select(DivisionNm,
         alp_tpp_per = `Australian Labor Party Percentage`)

ced_labels <- readxl::read_xlsx(
  here("data/2022/CED_Census/2021_GCP_CED_for_AUS_short-header/Metadata/2021Census_geog_desc_1st_and_2nd_release.xlsx"),
  sheet = "2021_ASGS_Non_ABS_Structures") %>%
  rename(CED_CODE_2021=Census_Code_2021,div_nm=Census_Name_2021) %>%
  filter(grepl("^CED",CED_CODE_2021))

aec_data <- purrr::reduce(list(
  fp,
  tpp,
  ced_labels %>%
    filter(div_nm != "Australia") %>%
    select(CED_CODE_2021, DivisionNm = div_nm, area = `Area sqkm`)
),
left_join,
by = "DivisionNm")

save("aec_data",file=here("data/2022/aec/ced_results.RData"))
ced_master <- purrr::reduce(list(ced_gcp %>%
                                   select("CED_CODE_2021",
                                          setdiff(colnames(ced_gcp),
                                                  colnames(ced_pep)
                                                  )
                                          ),
                                 ced_pep %>%
                                   select("CED_CODE_2021",
                                          setdiff(colnames(ced_pep),
                                                  colnames(ced_gcp)
                                          )
                                   ),
                                 aec_data),
                            left_join,
                            by = "CED_CODE_2021") %>%
  mutate(c200 = DivisionNm %in% c("Wentworth","North Sydney","Mackellar",
                                  "Kooyong","Goldstein","Curtin",
                                  "Warringah")) %>%
  janitor::remove_empty("cols") %>%
  janitor::remove_constant()


ced_master <- ced_master[!duplicated(unclass(ced_master))]

save("ced_master",file=here("data/2022/CED_Census/ced_master.RData"))
#####################################################################
load(here("data/2022/CED_Census/ced_master.RData"))
x <- ced_master %>%
  filter(!is.na(per_ALP)) %>%
  select(-any_of(colnames(aec_data)),
         "BallotPosition_ALP",
         "HistoricElected_ALP")

y <- ced_master %>%
  filter(!is.na(per_ALP)) %>%
  pull(per_ALP)

options(java.parameters = "-Xmx8g")
library(bartMachine)


m <- randomForest(x=x,y=y,
                  do.trace=TRUE,
                  mtry = round(.8*ncol(x)),
                  importance=TRUE)

plotData <- ced_master %>%
  filter(!is.na(per_ALP)) %>%
  select(DivisionNm,c200,per_ALP) %>%
  mutate(yhat = predict(m))

ggplot(plotData,
       aes(x=yhat,y=per_ALP,color=c200)) +
  geom_point() +
  geom_abline(slope=1,intercept=0)



d_02 <- read_csv(file=here("data/2022/CED_Census/2021_GCP_CED_for_AUS_short-header/2021 Census GCP Commonwealth Electroral Division for AUS/2021Census_G02_AUST_CED.csv"))

## language
## PSEO_SEO
## PERSONS_Speaks_English_only_Speaks_English_only
d_01 <- read_csv(file=here("data/2022/CED_Census/2021_GCP_CED_for_AUS_short-header/2021 Census GCP Commonwealth Electroral Division for AUS/2021Census_G01_AUST_CED.csv"))
d_02 <- read_csv(file=here("data/2022/CED_Census/2021_GCP_CED_for_AUS_short-header/2021 Census GCP Commonwealth Electroral Division for AUS/2021Census_G02_AUST_CED.csv"))

ced_data <- d_01 %>%
  rename(persons=Tot_P_P,
         citizens=Australian_citizen_P) %>%
  mutate(cit_per = citizens/persons*100) %>%
  mutate(nesh = Lang_used_home_Oth_Lang_P/persons*100,
         hs = High_yr_schl_comp_Yr_12_eq_P/persons*100)

ced_labels <- readxl::read_xlsx(
  here("data/2022/CED_Census/2021_GCP_CED_for_AUS_short-header/Metadata/2021Census_geog_desc_1st_and_2nd_release.xlsx"),
  sheet = "2021_ASGS_Non_ABS_Structures") %>%
  rename(CED_CODE_2021=Census_Code_2021,div_nm=Census_Name_2021)

ced_data <- ced_data %>%
  left_join(ced_labels %>%
              filter(div_nm!="Australia") %>%
              select(CED_CODE_2021,div_nm,area=`Area sqkm`),
            by = "CED_CODE_2021"
            )

########################################################
## read CSVs produced by TableBuilder
theFiles <- list.files(path=here("data/2022/CED_Census/"),pattern = "*.csv")
d <- list()
for ( f in theFiles ) {
  d[[f]] <- read_csv(file = paste(here("data/2022/CED_Census"),
                                  f,
                                  sep = "/")) %>%
    janitor::remove_empty() %>%
    mutate(across(where(is.double), ~ .x/Total*100)) %>%
    rename(div_nm = CED)
}

d[[2]] <- d[[2]] %>% select(div_nm,same_address_2021=`Same as in 2021`)
d[[3]] <- d[[3]] %>% mutate(non_europe = 100 - `North-West European` - `Southern and Eastern European`) %>% select(div_nm,non_europe)
d[[4]] <- d[[4]] %>% select(div_nm,english_only = `Speaks English only`)
d[[5]] <- d[[5]] %>% select(div_nm,high_school = `Year 12 or equivalent`)
d[[1]] <- NULL

d <- purrr::reduce(d,left_join,by="div_nm")

save("d",file=here("data/2022/CED_Census/merged.RData"))
