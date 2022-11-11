########################################################
## read features of SA1 file
##
## simon jackman
##
##
## 2022-11-03 18:08:46.336717
########################################################

library(tidyverse)
library(here)

d_01 <- read_csv(file=here("data/2022/SA1/2021_GCP_SA1_for_AUS_short-header/2021 Census GCP Statistical Area 1 for AUS/2021Census_G01_AUST_SA1.csv"))
d_02 <- read_csv(file=here("data/2022/SA1/2021_GCP_SA1_for_AUS_short-header/2021 Census GCP Statistical Area 1 for AUS/2021Census_G02_AUST_SA1.csv"))

## language
## PSEO_SEO
## PERSONS_Speaks_English_only_Speaks_English_only
d_13 <- read_csv(file=here("data/2022/SA1/2021_GCP_SA1_for_AUS_short-header/2021 Census GCP Statistical Area 1 for AUS/2021Census_G13C_AUST_SA1.csv"))


