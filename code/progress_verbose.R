########################################################
## track count
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

## 2022 election id is 27966
## 2019 was 24310
goLive <- as.POSIXct("2022-05-21 18:00:00")
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

resultTimeStamp <- function(foo){
  ts <- xml_attr(xml_find_first(foo,"//d1:Cycle"),"Created")
  ts <- as.POSIXct(ts,format="%Y-%m-%dT%H:%M:%S",tz="Australia/Sydney")
  return(ts)
}


tcpParse_PP <- function(theNode){
  candidate_id <- xml_attr(xml_find_all(theNode,"./d1:Candidate/eml:CandidateIdentifier"),"Id")
  vnodes <- xml_find_all(theNode,"./d1:Candidate/d1:Votes")
  ##Division <- theNode %>% xml_parent() %>% xml_parent() %>% xml_parent() %>% xml_find_first(".//eml:ContestName") %>% xml_text()
  timeStamp <- xml_attr(theNode,attr="Updated") %>% as.POSIXct(format="%Y-%m-%dT%H:%M:%S",
                                                               tz="Australia/Sydney")

  out <- tibble(##Division=Division,
                pp_id = theNode %>% xml_parent() %>% xml_find_first("./d1:PollingPlaceIdentifier"),
                candidate_id=candidate_id,
                v=vnodes %>% xml_integer(),
                per = vnodes %>% xml_attr("Percentage") %>% as.numeric(),
                swing = vnodes %>% xml_attr("Swing") %>% as.numeric(),
                v_historic = vnodes %>% xml_attr("Historic") %>% as.integer(),
                matched_historic = vnodes %>% xml_attr("MatchedHistoric") %>% as.integer(),
                matched_historic_firstprefsin = vnodes %>% xml_attr("MatchedHistoricFirstPrefsIn") %>% as.integer(),
                timeStamp=timeStamp)

  return(out)

}

tcpParse_Division <- function(theNode){
  candidate_id <- xml_attr(xml_find_all(theNode,"./d1:Candidate/eml:CandidateIdentifier"),"Id")
  vnodes <- xml_find_all(theNode,"./d1:Candidate/d1:Votes")
  Division <- theNode %>% xml_parent() %>% xml_find_first(".//eml:ContestName") %>% xml_text()
  timeStamp <- xml_attr(theNode,attr="Updated") %>% as.POSIXct(format="%Y-%m-%dT%H:%M:%S",
                                                               tz="Australia/Sydney")

  out <- tibble(Division=Division,
                candidate_id=candidate_id,
                v=vnodes %>% xml_integer(),
                per = vnodes %>% xml_attr("Percentage") %>% as.numeric(),
                swing = vnodes %>% xml_attr("Swing") %>% as.numeric(),
                v_historic = vnodes %>% xml_attr("Historic") %>% as.integer(),
                matched_historic = vnodes %>% xml_attr("MatchedHistoric") %>% as.integer(),
                matched_historic_firstprefsin = vnodes %>% xml_attr("MatchedHistoricFirstPrefsIn") %>% as.integer(),
                timeStamp=timeStamp)

  return(out)

}

tcpParse <- function(theNodes){
  out <- lapply(theNodes,tcpParse_Division)
  return(out)
}

myextract_tpp <- function(foo){
  require(xml2)
  theNodes <- xml_find_all(foo,"//d1:TwoCandidatePreferred[@PollingPlacesExpected]")
  tcp <- tcpParse(theNodes) %>%
    bind_rows()
  return(tcp)
}

firstpref <- function(foo){
  require(xml2)
  cnodes <- xml_find_all(foo,"//d1:FirstPreferences[ not( ancestor::d1:PollingPlaces ) ]/d1:Candidate")
  candidate_ids <- xml_attr(xml_find_all(cnodes,"eml:CandidateIdentifier"),"Id")
  vnodes <- xml_find_all(cnodes,"./d1:Votes")
  v <- xml_integer(vnodes)
  per <- as.double(xml_attr(vnodes,"Percentage"))
  swing <- as.double(xml_attr(vnodes,"Swing"))
  v_historic <- as.integer(xml_attr(vnodes,"Historic"))
  out <- data.frame(id=candidate_ids,
                    v=v,
                    per=per,
                    swing=swing,
                    v_historic=v_historic)
  out$per_historic <- out$v_historic/sum(out$v_historic)*100
  return(out)
}

tcp <- function(foo){
  require(xml2)

  cnodes <- xml_find_all(foo,"//d1:TwoCandidatePreferred[@PollingPlacesExpected]")

  candidate_id <- xml_attr(xml_find_all(cnodes,"d1:Candidate/eml:CandidateIdentifier"),"Id")
  vnodes <- xml_find_all(cnodes,"./d1:Candidate/d1:Votes")

  out <- tibble(Division = vnodes %>%
                  xml_find_first(xpath="ancestor::d1:Contest") %>%
                  xml_find_first(".//eml:ContestName") %>%
                  xml_text(),
               candidate_id=candidate_id,

               v=vnodes %>% xml_integer(),
                per = vnodes %>% xml_attr("Percentage") %>% as.numeric(),
                swing = vnodes %>% xml_attr("Swing") %>% as.numeric(),
                v_historic = vnodes %>% xml_attr("Historic") %>% as.integer(),
                matched_historic = vnodes %>% xml_attr("MatchedHistoric") %>% as.integer(),
                matched_historic_firstprefsin = vnodes %>% xml_attr("MatchedHistoricFirstPrefsIn") %>% as.integer(),

               timeStamp = vnodes %>%
                 xml_find_first(xpath="ancestor::d1:TwoCandidatePreferred") %>%
                 xml_attr("Updated") %>%
                 as.POSIXct(format="%Y-%m-%dT%H:%M:%S",
                            tz="Australia/Sydney")
  )

  return(out)
}

## this will work for both tcp and firstprefs
get_pp_tpp <- function(theNodes){
  require(xml2)

  restricted <- as.logical(xml_attr(theNodes,"Restricted"))
  if(!is.na(restricted) & restricted){
    return(NULL)
  }

  candidate_id <- xml_attr(xml_find_all(theNodes,"./d1:Candidate/eml:CandidateIdentifier"),"Id")
  vnode <- xml_find_all(theNodes,"./d1:Candidate/d1:Votes")
  v <- xml_integer(vnode)
  per <- as.double(xml_attr(vnode,"Percentage"))
  swing <- as.double(xml_attr(vnode,"Swing"))
  v_historic <- as.integer(xml_attr(vnode,"Historic"))
  per_historic <- v_historic/sum(v_historic)*100
  n <- sum(v)
  timeStamp <- as.POSIXct(xml_attr(theNodes,"Updated"),
                          format="%Y-%m-%dT%H:%M:%S",
                          tz="Australia/Sydney")
  out <- data.frame(candidate_id=id,
                    v=v,
                    per=per,
                    swing=per-per_historic,
                    per_historic=per_historic,
                    v_historic=v_historic,
                    n=n,
                    timeStamp=timeStamp)
  return(out)
}



votes_pollingplace <- function(foo,type="firstprefs"){
  if(type=="firstprefs"){
    selector <-  "./d1:FirstPreferences"
  }
  else {
    selector <- "./d1:TwoCandidatePreferred"
  }

  ppId_nodes <- xml_find_all(
    xml_parent(
      xml_find_all(
        foo,"//d1:PollingPlace/d1:PollingPlaceIdentifier")
      ),
    selector)

  vnodes <- ppId_nodes %>% xml_find_all("./d1:Candidate/d1:Votes")
  out <- tibble(Division = vnodes %>%
                  xml_find_first(xpath="ancestor::d1:Contest") %>%
                  xml_find_first(".//eml:ContestName") %>%
                  xml_text(),

                pp_id = vnodes %>%
                  xml_find_first("ancestor::d1:PollingPlace/d1:PollingPlaceIdentifier") %>%
                  xml_attr("Id"),

                candidate_id = ppId_nodes %>%
                  xml_find_all("./d1:Candidate/eml:CandidateIdentifier") %>%
                  xml_attr("Id"),

                votes = vnodes %>% xml_integer(),

                v_historic = vnodes %>% xml_attr("Historic") %>% as.integer(),
                per = vnodes %>% xml_attr("Percentage") %>% as.double(),
                swing = vnodes %>% xml_attr("Swing") %>% as.double(),

                timeStamp = vnodes %>%
                  xml_find_first(xpath="ancestor::d1:Contest") %>%
                  xml_attr("Updated") %>%
                  as.POSIXct(format="%Y-%m-%dT%H:%M:%S",
                             tz="Australia/Sydney")

  )

  return(out)
}

parseFile <- function(f){
  require(xml2)
  td <- tempdir()
  unzip(zipfile = f,exdir = td)
  xmlFile <- list.files(path=paste(td,"/xml",sep=""),
                        pattern="*xml",
                        full.names = TRUE)

  foo <- read_xml(xmlFile[1]) ## parse XML
  unlink(td,recursive = TRUE)               ## dump tempdir

  ## real work

  fp <- firstpref(foo)

  system.time(
    fp_pp <- votes_pollingplace(foo,type="firstprefs")
  )

  system.time(
    tcp <- tcp(foo)
  )

  system.time(
    tcp_pp <- votes_pollingplace(foo,type="tcp")
  )


  ## gather up for output
  out <- list(fp=fp,
              fp_pp=fp_pp,
              tcp=tcp,
              tcp_pp=tcp_pp)
  out$timestamp <- resultTimeStamp(foo)
  rm(foo)
  return(out)
}


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




