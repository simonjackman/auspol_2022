########################################################
## historical use only, bulk processing of 2019
##
## simon jackman
## simon.jackman@sydney.edu.au
## ussc, univ of sydney
## 2018-07-29 13:39:26
## 2022-05-21 01:08:07
########################################################
library(tidyverse)
library(here)
library(rvest)
library(xml2)
library(RCurl)

library(doMC)
registerDoMC(cores=8)

source(here("code/goLive.R"))
source(here("code/parse_functions.R"))

#############################################################
## parse many files

## look at what we've already processed
outfile <- here(paste("data",year,"parsed.RData",sep="/"))
if(file.exists(outfile)){
  load(outfile)
} else {
  out <- list()
}

theFiles <- list.files(path=here(paste("data",year,"Detailed/Verbose",sep="/")),
                       pattern="*.zip",
                       full.names = TRUE)
## tag and index
tag <- gsub(theFiles,
            pattern = "^.*\\-[0-9]{5}\\-([0-9].*)\\.zip",
            replacement="\\1")
toparse <- !(tag %in% names(out)) & (year == 2019 & tag < "20190519010000")
theFiles_toparse <- theFiles[toparse]
tag_toparse <- tag[toparse]

n <- length(theFiles_toparse)

if(n>0){
  time0 <- Sys.time()
  for(i in 1:n){
    cat(paste("processing",tag_toparse[i],"file",i,"of",n,"\n"))
    system.time(
      out[[tag_toparse[i]]] <- parseFile(theFiles_toparse[i])
    )
    time1 <- Sys.time()
    d <- difftime(time1,time0,units="secs")
    d <- as.numeric(d)
    cat(paste("running at",d/i,"seconds per file\n"))
    timeRemaining <- (n-i)*(d/i)
    cat(paste("expected time remaining:",timeRemaining,"seconds\n"))
  }
  save("out",file=outfile)
}




