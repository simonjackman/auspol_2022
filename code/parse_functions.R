########################################################
## functions for parsing AEC XML/EML Detailed/Verbose
##
## simon jackman
## simon.jackman@sydney.edu.au
##
## 2022-05-21 13:53:16
########################################################
load(here(paste("data",year,"preload/pre_load.RData",sep="/")))

resultTimeStamp <- function(foo){
  ts <- xml_attr(xml_find_first(foo,"//d1:Cycle"),"Created")
  ts <- as.POSIXct(ts,format="%Y-%m-%dT%H:%M:%S",tz="Australia/Sydney")
  return(ts)
}

join_parties <- function(obj){
  if(!("affiliation_abb" %in% names(obj)) & "candidate_id" %in% names(obj)){
    if(is.character(obj$candidate_id)){
      obj$candidate_id <- as.numeric(obj$candidate_id)
    }
    obj <- obj %>%
      select(-any_of("Division")) %>%
      left_join(candidates,by="candidate_id")
  }

  left_join(obj,
            parties_affiliation_group_xwalk,
            by="affiliation_abb") %>%
    mutate(party_group = if_else(affiliation_abb=="IND",
                                 "IND",
                                 party_group)) %>%
    mutate(party_group = replace_na(party_group,"OTH"))
}

firstpref <- function(foo){
  require(xml2)
  cnodes <- xml_find_all(foo,"//d1:FirstPreferences[ not( ancestor::d1:PollingPlaces ) ]/d1:Candidate | //d1:FirstPreferences[ not( ancestor::d1:PollingPlaces ) ]/d1:Ghost")
  candidate_ids <- xml_attr(xml_find_all(cnodes,"eml:CandidateIdentifier"),"Id") %>% as.integer()
  vnodes <- xml_find_all(cnodes,"./d1:Votes")

  Division <- vnodes %>%
    xml_find_first(xpath="ancestor::d1:Contest") %>%
    xml_find_first(".//eml:ContestName") %>%
    xml_text()

  v <- xml_integer(vnodes)

  per <- as.double(xml_attr(vnodes,"Percentage"))

  swing <- as.double(xml_attr(vnodes,"Swing"))

  v_historic <- as.integer(xml_attr(vnodes,"Historic"))

  timestamp <- vnodes %>%
    xml_find_first("ancestor::d1:FirstPreferences") %>%
    xml_attr("Updated") %>%
    as.POSIXct(ts,format="%Y-%m-%dT%H:%M:%S",tz="Australia/Sydney")

  out <- tibble(Division=Division,
                candidate_id=candidate_ids,
                v=v,
                per=per,
                swing=swing,
                v_historic=v_historic,
                timestamp=timestamp) %>%
    left_join(candidates,by=c("Division","candidate_id")) %>%
    group_by(Division) %>%
    mutate(per_historic =v_historic/sum(v_historic)*100) %>%
    ungroup() %>%
    join_parties() %>%
    select(Division,candidate_id,name,party_group,v,per,v_historic,per_historic,swing,timestamp)

  return(out)
}

cond_create <- function(df,var,newvar){
  if(var %in% names(df)){
    df[[newvar]] <- as.numeric(df[[var]])
  }
  return(df)
}

informal <- function(foo){
  cnodes <- xml_find_all(foo,"//d1:FirstPreferences[ not( ancestor::d1:PollingPlaces ) ]") %>%
    xml_find_all("./d1:Formal | ./d1:Informal")

  Division <- cnodes %>%
    xml_find_first("ancestor::d1:Contest/eml:ContestIdentifier/eml:ContestName") %>%
    xml_text()

  timestamp <- cnodes %>%
    xml_find_first("ancestor::d1:FirstPreferences") %>%
    xml_attr("Updated") %>%
    as.POSIXct(ts,format="%Y-%m-%dT%H:%M:%S",tz="Australia/Sydney")

  out <- tibble(
    Division = Division,

    formality = cnodes %>% xml_name(),

    cnodes %>%
      xml_find_all("./d1:Votes") %>%
      xml_attrs() %>%
      bind_rows(),

    n = cnodes %>%
      xml_find_all("./d1:Votes") %>%
      xml_integer()
  ) %>%
    mutate(Type="All")

  ## by type
  cnodes <- xml_find_all(foo,"//d1:FirstPreferences[ not( ancestor::d1:PollingPlaces ) ]") %>%
    xml_find_all("./d1:Formal/d1:VotesByType/d1:Votes | ./d1:Informal/d1:VotesByType/d1:Votes")

  Division <- cnodes %>%
    xml_find_first("ancestor::d1:Contest/eml:ContestIdentifier/eml:ContestName") %>%
    xml_text()

  timestamp <- cnodes %>%
    xml_find_first("ancestor::d1:FirstPreferences") %>%
    xml_attr("Updated") %>%
    as.POSIXct(ts,format="%Y-%m-%dT%H:%M:%S",tz="Australia/Sydney")

  out_type <- tibble(
    Division = Division,

    formality = cnodes %>%
      xml_find_first("ancestor::d1:Formal | ancestor::d1:Informal") %>%
      xml_name(),

    cnodes %>%
      xml_attrs() %>%
      bind_rows(),

    n = cnodes %>%
      xml_integer()
  )

  out <- bind_rows(out,out_type) %>%
    rename(n_historic=Historic,
           per=Percentage,
           swing=Swing) %>%
    arrange(Division,Type,formality)

  return(out)
}

firstpref_by_type <- function(foo){
  cnodes <- xml_find_all(foo,"//d1:FirstPreferences[ not( ancestor::d1:PollingPlaces ) ]/d1:Candidate")
  candidate_ids <- xml_attr(xml_find_all(cnodes,"eml:CandidateIdentifier"),"Id") %>% as.integer()

  vnodes <- cnodes %>% xml_find_all("./d1:VotesByType/d1:Votes")

  timestamp <- vnodes %>%
    xml_find_first("ancestor::d1:FirstPreferences") %>%
    xml_attr("Updated") %>%
    as.POSIXct(ts,format="%Y-%m-%dT%H:%M:%S",tz="Australia/Sydney")

  out <- bind_cols(
    candidate_id = vnodes %>%
      xml_find_first("ancestor::d1:Candidate/eml:CandidateIdentifier") %>%
      xml_attr("Id") %>%
      as.integer(),
    vnodes %>%
      xml_attrs() %>%
      bind_rows() %>%
      cond_create("Historic","v_historic") %>%
      cond_create("Percentage","per") %>%
      cond_create("Swing","swing") %>%
      select(-any_of(c("Historic","Percentage","Swing"))),
    v=vnodes %>% xml_integer(),
    timestamp=timestamp
  ) %>%
    left_join(candidates,
              by="candidate_id") %>%
    group_by(Division,Type) %>%
    mutate(per_historic = v_historic/sum(v_historic)*100) %>%
    ungroup() %>%
    join_parties() %>%
    select(Division,Type,candidate_id,name,party_group,v,per,v_historic,per_historic,swing,timestamp)

  return(out)
}

tcp_by_type <- function(foo){
  vnodes <- xml_find_all(foo,"//d1:TwoCandidatePreferred/d1:Candidate/d1:VotesByType/d1:Votes")
  out <- bind_cols(candidate_id = vnodes %>%
                     xml_find_first("ancestor::d1:Candidate/eml:CandidateIdentifier") %>%
                     xml_attr("Id") %>%
                     as.integer(),

                   vnodes %>%
                     xml_attrs() %>%
                     bind_rows() %>%
                     cond_create("Historic","v_historic") %>%
                     cond_create("Percentage","per") %>%
                     cond_create("Swing","swing") %>%
                     select(-any_of(c("Historic","Percentage","Swing"))),

                   v=vnodes %>% xml_integer(),

                   timestamp = vnodes %>%
                     xml_find_first("ancestor::d1:TwoCandidatePreferred") %>%
                     xml_attr("Updated") %>%
                     as.POSIXct(ts,format="%Y-%m-%dT%H:%M:%S",tz="Australia/Sydney")
  ) %>%
    left_join(candidates,
              by="candidate_id")

  if("Type" %in% names(out)){
    out <- out %>%
      group_by(Division,Type)
  } else {
    out <- out %>% group_by(Division)
  }
  if("v_historic" %in% names(out)){
  out <- out %>%
      mutate(per_historic = v_historic/sum(v_historic)*100) %>%
      ungroup()
  }
  out <- out %>%
    join_parties() %>%
    select(any_of(c("Division","Type","candidate_id",
                    "name","party_group","v","per",
                    "v_historic","per_historic","swing",
                    "timestamp")
                  )
           )

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
                candidate_id=candidate_id %>% as.integer(),

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
                  xml_attr("Id") %>%
                  as.integer(),

                candidate_id = ppId_nodes %>%
                  xml_find_all("./d1:Candidate/eml:CandidateIdentifier") %>%
                  xml_attr("Id") %>% as.integer(),

                votes = vnodes %>% xml_integer(),

                v_historic = vnodes %>% xml_attr("Historic") %>% as.integer(),
                per = vnodes %>% xml_attr("Percentage") %>% as.double(),
                swing = vnodes %>% xml_attr("Swing") %>% as.double(),

                timeStamp = vnodes %>%
                  xml_find_first(xpath=paste0("ancestor::",
                                              ifelse(type=="firstprefs",
                                                     "d1:FirstPreferences",
                                                     "d1:TwoCandidatePreferred")
                                              )
                                 ) %>%
                  xml_attr("Updated") %>%
                  as.POSIXct(format="%Y-%m-%dT%H:%M:%S",
                             tz="Australia/Sydney")

  )

  return(out)
}

informal_pollingplace <- function(foo){

  vnodes <- xml_find_all(
    foo,
    "//d1:PollingPlace/d1:FirstPreferences/d1:Formal/d1:Votes | //d1:PollingPlace/d1:FirstPreferences/d1:Informal/d1:Votes")

  out <- tibble(Division = vnodes %>%
                  xml_find_first(xpath="ancestor::d1:Contest") %>%
                  xml_find_first(".//eml:ContestName") %>%
                  xml_text(),

                formality = vnodes %>%
                  xml_find_first("ancestor::d1:Formal | ancestor::d1:Informal") %>%
                  xml_name(),

                pp_id = vnodes %>%
                  xml_find_first("ancestor::d1:PollingPlace/d1:PollingPlaceIdentifier") %>%
                  xml_attr("Id") %>%
                  as.integer(),

                timestamp = vnodes %>%
                  xml_find_first("ancestor::d1:FirstPreferences") %>%
                  xml_attr("Updated") %>%
                  as.POSIXct(ts,format="%Y-%m-%dT%H:%M:%S",tz="Australia/Sydney"),

                n = vnodes %>% xml_integer(),

                n_historic = vnodes %>% xml_attr("Historic") %>% as.integer(),
                per = vnodes %>% xml_attr("Percentage") %>% as.double(),
                swing = vnodes %>% xml_attr("Swing") %>% as.double()
  )

  return(out)
}

## totals by type (includes informality)
totals <- function(foo){
  theNodes <- xml_find_all(foo,".//d1:FirstPreferences/d1:Total/d1:VotesByType/d1:Votes")

  Division <- theNodes %>%
    xml_find_first("ancestor::d1:Contest") %>%
    xml_find_first(".//eml:ContestName") %>%
    xml_text()

  timestamp <- theNodes %>%
    xml_find_first("ancestor::d1:FirstPreferences") %>%
    xml_attr("Updated") %>%
    as.POSIXct(ts,format="%Y-%m-%dT%H:%M:%S",tz="Australia/Sydney")

  out <- tibble(
    Division=Division,
    v=theNodes %>% xml_integer(),
    theNodes %>% xml_attrs() %>% bind_rows() %>% as_tibble() %>%
      mutate(v_historic=as.numeric(Historic),
             per=as.numeric(Percentage),
             swing=as.numeric(Swing)) %>%
      select(Type,v_historic,per,swing),
    timestamp=timestamp
  )
  return(out)
}

totals_pp <- function(foo){
  theNodes <- xml_find_all(foo,".//d1:PollingPlace/d1:FirstPreferences/d1:Total/d1:Votes")

  Division <- theNodes %>%
    xml_find_first("ancestor::d1:Contest") %>%
    xml_find_first(".//eml:ContestName") %>%
    xml_text()

  pp_id = theNodes %>%
    xml_find_first("ancestor::d1:PollingPlace/d1:PollingPlaceIdentifier") %>%
    xml_attr("Id") %>%
    as.integer()

  timestamp <- theNodes %>%
    xml_find_first("ancestor::d1:FirstPreferences") %>%
    xml_attr("Updated") %>%
    as.POSIXct(ts,format="%Y-%m-%dT%H:%M:%S",tz="Australia/Sydney")

  out <- tibble(
    Division=Division,
    pp_id=pp_id,
    v=theNodes %>% xml_integer(),
    theNodes %>% xml_attrs() %>% bind_rows() %>% as_tibble() %>%
      mutate(v_historic=as.numeric(Historic),
             per=as.numeric(Percentage),
             swing=as.numeric(Swing)) %>%
      select(v_historic,per,swing),
    timestamp=timestamp
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
  foo <- try(read_xml(xmlFile[1],silent=TRUE)) ## parse XML
  if(inherits(foo,"try-error")){
    return(NULL)
  }
  unlink(td,recursive = TRUE)               ## dump tempdir

  ## real work
  fp <- firstpref(foo)
  fp_type <- firstpref_by_type(foo)

  system.time(
    fp_pp <- votes_pollingplace(foo,type="firstprefs")
  )

  system.time(
    tcp_tmp <- tcp(foo)
  )

  system.time(
    tcp_pp <- votes_pollingplace(foo,type="tcp")
  )

  tcp_type <- tcp_by_type(foo)

  informality <- informal(foo)
  informal_pp <- informal_pollingplace(foo)

  tots <- totals(foo)
  tots_pp <- totals_pp(foo)

  ## gather up for output
  out <- list(fp=fp,
              fp_type=fp_type,
              fp_pp=fp_pp,
              tcp=tcp_tmp,
              tcp_type=tcp_type,
              tcp_pp=tcp_pp,
              informality=informality,
              informal_pp=informal_pp,
              totals=tots,
              totals_pp=tots_pp)
  out$timestamp <- resultTimeStamp(foo)
  rm(foo)
  return(out)
}

getAEC_filelist <- function(){
  require(RCurl)
  theURL <- paste("ftp://",aec_url,"/",
                  theEvents_num,
                  "/Detailed/Verbose/*.zip",sep="")
  filenames <- getURL(theURL,ftp.use.epsv = FALSE,dirlistonly = TRUE)

  ## strip out trailing characters
  filenames <- str_split(filenames,"\n")
  filenames <- filenames[[1]]
  filenames <- filenames[filenames!=""]

  filenames_short <- str_remove(filenames,pattern="\\.zip")

  created <- str_extract(filenames_short,pattern="[0-9]{6,}") %>% as.numeric()
  keep <- created > 20220521175959

  return(filenames_short[keep])
}


getMostRecent <- function(live){
  if(!live){
    ## get a file from mid-evening on Election Night 2019
    theFile <- here("data/2019/Detailed/Verbose/aec-mediafeed-Detailed-Verbose-24310-20190518212129.zip")
  } else {
    ## we're live
    flist <- getAEC_filelist()
    theFile <- flist[length(flist)]

    theURL <- paste("ftp://",aec_url,"/",
                    theEvents_num,
                    "/Detailed/Verbose/",
                    theFile,
                    ".zip",
                    sep="")
    destFile <- paste0("/tmp/",theFile,".zip")
    if(!file.exists(destFile)){
      download.file(theURL,destFile)
    }
  }

  theData <- parseFile(destFile)

  return(theData)
}

## national totals
getNationalTotals <- function(data){
  fp <- data$fp %>%
    group_by(party_group) %>%
    summarise(v=sum(v)) %>%
    ungroup() %>%
    mutate(p=v/sum(v)*100) %>%
    mutate(timestamp = data$timestamp)

  return(fp)
}

getFoo <- function(i=NULL){
  flist <- list.files(path=here("data/2022/Detailed/Verbose"),pattern = "*.zip",full.names = TRUE)
  ft <- file.mtime(flist)
  flist <- flist[order(ft)]

  if(!is.null(i)){
    theFile <- flist[i]
  } else {
    latest <- file.mtime(flist) %>% which.max()
    theFile <- flist[latest]
  }

  td <- tempdir()
  unzip(zipfile = theFile,exdir = td)
  xmlFile <- list.files(path=paste(td,"/xml",sep=""),
                        pattern="*xml",
                        full.names = TRUE)

  foo <- try(read_xml(xmlFile[1],silent=TRUE)) ## parse XML
  if(inherits(foo,"try-error")){
    return(NULL)
  }
  unlink(td,recursive = TRUE)

  return(foo)
}
