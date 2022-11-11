########################################################
## extractor functions AEC XML
##
## simon jackman
## simon.jackman@sydney.edu.au
##
## 2022-05-20 22:33:08
########################################################

library(tidyverse)
library(here)
library(rvest)
library(xml2)

source(here("code/goLive.R"))
source(here("code/parse_functions.R"))
load(here(paste("data",year,"preload/pre_load.RData",sep="/")))
load(here(paste("data",year,"working/latest.RData",sep="/")))

getNationalTotals(data)

dvote_detail %>%
  select(-Enrolment) %>%
  group_by(type) %>%
  summarise(across(where(is.double),~sum(.x))) %>%
  ungroup()

dvote_detail %>%
  filter(type=="Total") %>%
  arrange(desc(awaiting))

showDivisionPollingPlaces <- function(theDivision){
  out <- data$fp_pp %>%
    left_join(candidates,
              by=c("Division","candidate_id")) %>%
    left_join(pollingPlaces,
              by=c("Division","pp_id")) %>%
    filter(Division==theDivision) %>%
    group_by(pp_id) %>%
    mutate(per = votes/sum(votes)*100) %>%
    mutate(per_historic = v_historic/sum(v_historic)*100) %>%
    mutate(swing = per - per_historic) %>%
    mutate(prepoll = grepl(pp_name,pattern="PPVC")) %>%
    ungroup() %>%
    filter(votes>0) %>%
    filter(prepoll) %>%
    filter(affiliation_abb == "LP" | is.na(affiliation_abb)) %>%
    select(Division,pp_id,pp_name,
           name,affiliation_abb,
           independent,votes,per,v_historic,per_historic,swing)

  return(out)
}

theSeats <- c("Mackellar","North Sydney","Wentworth","Kooyong","Goldstein","Curtin","Cowper")
for(s in theSeats){
  print(
    showDivisionPollingPlaces(s)
  )
}




