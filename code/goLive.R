########################################################
## are live on election night?
##
## simon jackman
## simon.jackman@sydney.edu.au
##
## 2022-05-21 12:31:16
########################################################

library(tidyverse)
library(here)

## 2022 election id is 27966
## 2019 was 24310
goLive <- as.POSIXct("2022-05-21 17:30:00")
live <- Sys.time() > goLive

if(live){
  theEvents_num <- 27966
  year <- 2022
  aec_url <- "mediafeed.aec.gov.au"
} else {
  theEvents_num <- 24310
  year <- 2019
  aec_url <- "mediafeedarchive.aec.gov.au"
}
