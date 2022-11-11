########################################################
## scrape declaration votes pages
##
## simon jackman
## simon.jackman@sydney.edu.au
##
## 2022-05-25 15:07:00
########################################################

library(tidyverse)
library(here)
library(rvest)

## declaration votes progress
my_convert <- function(x){
  as.numeric(stringr::str_remove(x,pattern=","))
}

load(here("data/2022/preload/pre_load.RData"))

td <- tempdir()
theURL <- "https://tallyroom.aec.gov.au/Downloads/GeneralDecVotesIssuedByDivisionDownload-27966.csv"
tf <- tempfile(tmpdir = "/tmp")
zzz <- try(download.file(theURL,tf),silent=TRUE)
dvotes_issued <- NULL
if(zzz==0){
  cat("downloaded dvotes_isseded file ok\n")
  dvotes_issued <- read_csv(tf,skip=1)
  unlink(tf)
} else {
    print(zzz)
  }

theURL <- "https://tallyroom.aec.gov.au/Downloads/GeneralDecVotesReceivedByDivisionDownload-27966.csv"
tf <- tempfile(tmpdir = "/tmp")
zzz <- try(download.file(theURL,tf),silent=TRUE)
download.file(theURL,tf)
dvotes_received <- NULL
if(zzz==0){
  cat("downloaded dvotes_receieved file ok\n")
  dvotes_received <- read_csv(tf,skip=1)
  unlink(tf)
} else {
  print(zzz)
}

if(!is.null(dvotes_issued) & !is.null(dvotes_received)){
  dvotes <- bind_rows(dvotes_issued %>% mutate(type="issued"),
                    dvotes_received %>% mutate(type="received")) %>%
  arrange(DivisionNm,type)
} else {
  dvotes <- NULL
}
# dvotes_progress <- read_html(url("https://tallyroom.aec.gov.au/HouseDecScrutinyProgressByDivision-27966.htm")) %>%
#   html_table() %>%
#   magrittr::extract2(1) %>%
#   rename(issued=`Envelopes issued`,
#          received=`Envelopes received`,
#          counted=`Ballot papers counted`,
#          not_returned=`Ballot papers not returned by voter`,
#          disallowed=`Ballot papers disallowed`,
#          rejected=`Envelopes rejected at preliminary scrutiny`,
#          processed=`Envelopes processed`,
#          awaiting=`Envelopes awaiting processing`) %>%
#   mutate(across(3:10,~my_convert(.x))) %>%
#   mutate(accept_rate = counted/processed,
#          processed_rate = processed/issued)


baseURL <- "https://tallyroom.aec.gov.au/HouseDivisionPage-27966-"
dvote_detail <- list()
ids <- contest %>% filter(contest_id!=0) %>% distinct()
n <- nrow(ids)

for(i in 1:n){
  theDivision <- ids$Division[i]
  cat(paste(theDivision,"\n"))
  tmp <- read_html(url(paste0(baseURL,ids$contest_id[i],".htm"))) %>%
    html_table(trim = TRUE)

  theOne <- lapply(tmp,function(x){x[1,1]})
  theOne <- which(unlist(theOne)=="Envelopes issued")


  if(length(theOne)==1){
    if(!is.na(theOne)){
      dvote_detail[[i]] <- tmp %>%
        magrittr::extract2(theOne) %>%
        rename(what=1) %>%
        mutate(Division=theDivision) %>%
        mutate(across(2:6,~my_convert(.x))) %>%
        mutate(what = case_when(
          grepl(pattern="issued",what) ~ "issued",
          grepl(pattern="received",what) ~ "received",
          grepl(pattern="counted",what) ~ "counted",
          grepl(pattern="not returned",what) ~ "not_returned",
          grepl(pattern="disallowed",what) ~ "disallowed",
          grepl(pattern="rejected",what) ~ "rejected",
          grepl(pattern="processed",what) ~ "processed",
          grepl(pattern="awaiting",what) ~ "awaiting")
        )
    }
  }
}

dvote_detail <- bind_rows(dvote_detail) %>%
  pivot_longer(cols=where(is.double),
               names_to = "type",
               values_to = "v") %>%
  pivot_wider(id_cols = c("Division","type"),
              names_from = "what",
              values_from = "v") %>%
  left_join(enrolled,by="Division") %>%
  mutate(rate_received = received/issued,
         expected_counted = case_when(
           type=="Absent" ~ 0.877*issued,
           type=="Postal" ~ 0.799*issued,
           type=="Provisional" ~ 0.297*issued,
           type=="Declaration pre-poll" ~ 0.03621*Enrolment,
           TRUE ~ issued
         )
  )




