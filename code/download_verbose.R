########################################################
## getverbose
##
## simon jackman
## simon.jackman@sydney.edu.au
## ussc, univ of sydney
## 2018-07-30 09:08:04
## 2022-05-21 00:49:29
########################################################
library(tidyverse)
library(here)
library(rvest)
library(xml2)
library(RCurl)

source(here("code/goLive.R"))

# aec_files <- getAEC_filelist()
#
# ## get those that we don't have
# haveFiles_file <- here(paste("data",year,"haveFiles.csv",sep="/"))
# if(!file.exists(haveFiles_file)){
#   haveFiles <- list.files(path=here(paste("data",year,"Detailed/Verbose",sep="/")),
#                         pattern="*.zip") %>%
#   str_remove(pattern="\\.zip")
#   write.csv(haveFiles,file = haveFiles_file,row.names = FALSE)
# }
# haveFiles <- read_csv(file=haveFiles_file) %>% pull(x)
#
# getFiles <- setdiff(aec_files,haveFiles)
# print(getFiles)
# flag <- length(getFiles)>0
#
# ## download
# for(theFile in getFiles){
#   theURL <- paste("ftp://",aec_url,"/",
#                   theEvents_num,
#                   "/Detailed/Verbose/",
#                   theFile,
#                   ".zip",
#                   sep="")
#   destFile <- paste0("/tmp/",theFile,".zip")
#   if(!file.exists(destFile)){
#     download.file(theURL,destFile)
#   }
# }
#
# if(flag){
  source(here("code/parse_functions.R"))
  source(here("code/make_working.R"))
  source(here("code/declaration_vote_progress.R"))
  source(here("code/changing_hands.R"))

  save("data","dvotes","dvote_detail","changing_hands",
       file=here(paste("data",year,"working/latest.RData",sep="/"))
  )

  source(here("code/progress.R"))

  ## run this in a separate cron job
  ##source(here("code/progress.R"))
##}
