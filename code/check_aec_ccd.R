########################################################
## check that AEC CCDs appears in various ABS files
##
## simon jackman
##
## 2022-11-26 19:34:01.971648
########################################################

library(tidyverse)
library(here)

## AEC file
sa1 <-
  read.csv(file = here("data/2022/SA1/2022-federal-election-votes-sa1.csv")) %>%
  filter(votes > 0)

## load a correspondence file
cfile <- read.csv(file = here("data/2022/SA1/correspondence/CG_SA1_2016_SA1_2021.csv")) %>%
  mutate(sa1_2016_7 = paste0(str_sub(SA1_MAINCODE_2016,1,1),
                            str_sub(SA1_MAINCODE_2016,6,11)),
         sa1_2021_7 = paste0(str_sub(SA1_CODE_2021,1,1),
                             str_sub(SA1_CODE_2021,6,11)))

table(unique(sa1$ccd_id) %in% cfile$sa1_2016_7)
table(unique(sa1$ccd_id) %in% cfile$sa1_2021_7)

anti_join(
  sa1 %>%
    group_by(state_ab, ccd_id) %>%
    summarise(n = sum(votes)) %>%
    ungroup() %>%
    mutate(ccd_id = as.character(ccd_id)),
  cfile,
  by = c("ccd_id" = "sa1_2016_7")
)

sa1_sa1 <- sa1 %>%
  mutate(ccd_id = as.character(ccd_id)) %>%
  left_join(cfile %>%
              select(starts_with("sa1"),
                     ratio=RATIO_FROM_TO),
            by = c("ccd_id" = "sa1_2016_7")) %>%
  rename(sa1 = sa1_2021_7)
