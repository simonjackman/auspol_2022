#########################################################
## read SA4 covariates and combine into a single file
##
## simon jackman
## simonjackman@sydney.edu.au
##
## 2023-02-28 21:04:38.599704
#########################################################

library(tidyverse)
library(here)

thePath <- here("data/2022/SA4/2021_PEP_SA4_for_AUS_short-header/2021 Census PEP Statistical Area 4 for AUS/")

theFiles <- list.files(path=thePath,pattern="*.csv")

foo <- list()
for(f in theFiles){
  foo[[f]] <- read_csv(file = paste(thePath,f,sep="/"))
}

## big left_join
foo_all <- Reduce(
  f = function(dtf1,dtf2){
    left_join(dtf1,dtf2,by="SA4_CODE_2021")
    },
  foo) %>%
  janitor::remove_empty("cols") %>%
  janitor::remove_constant()

save(foo_all,file=here("data/2022/SA4/sa4.RData"))

s <- svd(foo_all %>%
           select(-1) %>%
           mutate(across(everything(), ~ scale(.x))) %>%
           as.matrix())
