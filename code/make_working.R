########################################################
## make data from most recent download
##
## simon jackman
## simon.jackman@sydney.edu.au
##
## 2022-05-22 11:38:55
########################################################

library(tidyverse)
library(here)

system.time(
  data <- getMostRecent(live)
)


