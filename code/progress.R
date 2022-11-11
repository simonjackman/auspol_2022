########################################################
## build cumulative files
##
## simon jackman
## simon.jackman@sydney.edu.au
## ussc, univ of sydney
## 2018-07-29 13:39:26
## 2022-05-24 15:58:24
########################################################
library(tidyverse)
library(here)
library(rvest)
library(xml2)
library(fst)

source(here("code/goLive.R"))
source(here("code/parse_functions.R"))

updater <- function(element="fp_type",ts,write=TRUE,bigcheck=FALSE){
  theFile <- here(paste("data/2022/",element,"_progress.fst",sep=""))
  existing <-  read_fst(path=theFile)
  nms <- intersect(setdiff(names(existing),"timestamp_file"),names(data[[element]]))
  new <- anti_join(data[[element]],existing,by=nms)

  out <- NULL
  if(nrow(new)>0){
    cat(paste("adding",nrow(new),"records to existing\n"))
    out <- bind_rows(
      existing,
      new %>%
        mutate(
          timestamp_file=as.POSIXct(as.numeric(ts),
                                    tz="Australia/Sydney",
                                    origin=as.Date("1970-01-01")))
    )
  }

  if(bigcheck){
    out <- out %>% distinct(across(!starts_with("time")),.keep_all = TRUE)
  }

  if(!is.null(out) & write){
    write_fst(out,path=theFile)
  }
  return(invisible(NULL))
}

write_to_files <- function(data,write=TRUE,bigcheck=FALSE){
  ts <- data$timestamp

  theElements <- c("fp","fp_type","fp_pp",
                   "tcp","tcp_type","tcp_pp",
                   "totals","totals_pp")
  for(e in theElements){
    cat(paste("updating for",e,"\n"))
    updater(e,ts,write=write,bigcheck=bigcheck)
  }

  if(write){
    write_csv(data$fileName %>% as_tibble(),
            append=TRUE,
            file=here(paste("data",year,"fileNames_processed.csv",sep="/")))
  }

  return(invisible(NULL))
}

processedFiles <- read_csv(here(paste("data",year,"fileNames_processed.csv",sep="/"))) %>% pull(value)
aecFiles <- getAEC_filelist() %>% paste0(.,".zip")
theFiles <- setdiff(aecFiles,processedFiles)
n <- length(theFiles)

#dataFile <- here(paste("data",year,"all_parsed.RData",sep="/"))
#load(dataFile)
#m <- length(data)
system("rm /tmp/aec-mediafeed*.zip")

startTime <- Sys.time()
if(n>0){
  for(i in 1:n){
    theFile <- theFiles[i]
    theURL <- paste("ftp://",aec_url,"/",
                    theEvents_num,
                    "/Detailed/Verbose/",
                    theFile,
                    sep="")
    destFile <- paste0("/tmp/",theFile)
    if(!file.exists(destFile)){
      download.file(theURL,destFile)
    }

    cat(paste("parsing file",i,"of",n,"\n",theFile,"\n"))
    tmp <- try(parseFile(destFile),silent=TRUE)
    if(!inherits(tmp,"try-error")){
      cat("parsed ok\n")

      ## write elements of tmp to specific outputs/objects
      tmp$fileName <- theFile
      write_to_files(tmp,
                     write=TRUE,
                     bigcheck=(i==1))
    }

    now <- Sys.time()
    d <- as.numeric(difftime(now,startTime,units="secs"))
    time_per_run <- d/i
    expected_time_to_run <- (n-i)*time_per_run
    cat(paste("expected completion in",
              round(expected_time_to_run),
              "seconds\n\n\n"))
  }
}

library(data.table)
library(dbplyr)

tmp <- data.table(
  read_fst(here("data/2022/fp_progress.fst")) %>%
    filter(v>0) %>%
    filter(!is.na(timestamp)),
  key=c("candidate_id","timestamp")
  )

grid <- read_fst(here("data/2022/fp_progress.fst")) %>%
  filter(v>0) %>%
  filter(!is.na(timestamp)) %>%
  tidyr::expand(candidate_id,timestamp) %>%
  arrange(candidate_id,timestamp) %>%
  as.data.table()

tmp2 <- tmp[grid,on=.(candidate_id,timestamp),roll=TRUE]
tmp2 <- tmp2[!is.na(v), .(v=sum(v)), by=.(party_group,timestamp)]
tmp2 <- tmp2[, .(party_group=party_group,v=v,p=v/sum(v)*100), by=.(timestamp)]

ggplot(tmp2,
       aes(x=timestamp,y=p,
           group=party_group,color=party_group)) +
  geom_step() +
  scale_x_datetime(expand=c(0,0))

ggplot(tmp2,
       aes(x=timestamp,y=v,
           group=party_group,color=party_group)) +
  geom_step() +
  scale_x_datetime(expand=c(0,0))

q()

## two candidate
tmp <- read_fst(here("data/2022/tcp_progress.fst")) %>%
  group_by(timestamp_file,party_group) %>%
  summarise(v=sum(v)) %>%
  ungroup() %>%
  group_by(timestamp_file) %>%
  mutate(p=v/sum(v)*100) %>%
  ungroup() %>%
  mutate(ts=as.POSIXct(as.numeric(timestamp_file),
                       tz="Australia/Sydney",
                       origin=as.Date("1970-01-01")))

ggplot(tmp,
       aes(x=ts,y=p,
           group=party_group,color=party_group)) +
  geom_step() +
  scale_x_datetime(expand=c(0,0))

ggplot(tmp,
       aes(x=ts,y=v,
           group=party_group,color=party_group)) +
  geom_step() +
  scale_x_datetime(expand=c(0,0))

## type
ppvc <- read_fst(here("data/2022/fp_pp_progress.fst")) %>%
  left_join(pollingPlaces,by="pp_id") %>%
  filter(grepl(pattern="PPVC",pp_name)) %>%
  group_by(timestamp_file) %>%
  summarise(v=sum(votes)) %>%
  ungroup() %>%
  mutate(ts=as.POSIXct(as.numeric(timestamp_file),
                       tz="Australia/Sydney",
                       origin=as.Date("1970-01-01"))) %>%
  mutate(Type="PPVC")

tmp <- read_fst(here("data/2022/totals_progress.fst")) %>%
  semi_join(pollingPlaces,by="Division") %>%
  group_by(timestamp_file,Type) %>%
  summarise(v=sum(v)) %>%
  ungroup() %>%
  mutate(ts=as.POSIXct(as.numeric(timestamp_file),
                       tz="Australia/Sydney",
                       origin=as.Date("1970-01-01"))) %>%
  bind_rows(ppvc) %>%
  pivot_wider(id_cols=timestamp_file,names_from = Type,values_from = v) %>%
  mutate(Ord_Election_Day = Ordinary - PPVC) %>%
  select(-Ordinary) %>%
  pivot_longer(cols=where(is.integer),names_to = "Type",values_to = "v") %>%
  group_by(timestamp_file) %>%
  mutate(p=v/sum(v)*100) %>%
  ungroup()

ggplot(tmp,
       aes(x=timestamp_file,y=p,
           group=Type,color=Type)) +
  geom_step() +
  scale_y_continuous(breaks=seq(0,60,by=10),minor_breaks = NULL) +
  scale_x_datetime(expand=c(0,0),date_breaks = "day",minor_breaks = NULL,date_labels = "%e\n%b") +
  ggtitle("Vote by type (%), progressive")


