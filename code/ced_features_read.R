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
