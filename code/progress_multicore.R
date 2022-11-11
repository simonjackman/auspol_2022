########################################################
## track count (after the election)
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

library(doMC)
registerDoMC(cores=10)

## build time series of various totals
dataFile <- here("data/2022/all_parsed.RData")


theFiles <- getAEC_filelist()

theFiles <- list.files(here("data/2022/Detailed/Verbose"),
                       pattern="*.zip",
                       full.names = FALSE)
ft <- file.mtime(theFiles)
theFiles <- theFiles[order(ft)]
indx <- 1:length(theFiles)
m <- 0

n <- length(indx)
startTime <- Sys.time()
data <- foreach(i=1:n,
                .errorhandling = "pass",
                .export = "candidate",
                .packages=c("xml2","rvest","here","magrittr","dplyr","utils")
                ) %dopar%
  {
    p <- m+i
    theFile <- theFiles[indx[i]]
    theFile_full_name <- here(paste("data/2022/Detailed/Verbose",theFile,sep="/"))

    td <- tempdir(check=TRUE)
    unzip(zipfile = theFile_full_name,exdir = td)
    xmlFile <- list.files(path=paste(td,"/xml",sep=""),
                          pattern="*xml",
                          full.names = TRUE)
    foo <- try(read_xml(xmlFile[1],silent=TRUE))
    unlink(td,recursive = TRUE)

    ## real work
    fp <- firstpref(foo)
    fp_type <- firstpref_by_type(foo)
    fp_pp <- votes_pollingplace(foo,type="firstprefs")

    tcp_tmp <- tcp(foo)
    tcp_pp <- votes_pollingplace(foo,type="tcp")
    tcp_type <- tcp_by_type(foo)

    informality <- informal(foo)
    informal_pp <- informal_pollingplace(foo)

    tots <- totals(foo)
    tots_pp <- totals_pp(foo)

    ## gather up for output
    out <- list(fp=fp
                , fp_type=fp_type
                , fp_pp=fp_pp
                , tcp=tcp_tmp
                , tcp_type=tcp_type
                , tcp_pp=tcp_pp
                , informality=informality
                , informal_pp=informal_pp
                , totals=tots
                , totals_pp=tots_pp
                , fileName=theFile
                )
    out$timestamp <- resultTimeStamp(foo)
    out
  }

save("data",file=dataFile)
