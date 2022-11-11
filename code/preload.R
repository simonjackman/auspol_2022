########################################################
## parse preload files, contain static things like
## division names, candidate names, party names/abbreviations
##
## simon jackman
## simon.jackman@sydney.edu.au
##
## 2022-05-21 15:32:24
########################################################

library(tidyverse)
library(here)
library(rvest)
library(xml2)

## contest information
theNodes <- read_xml(here("data/2022/preload/eml-110-event-27966.xml")) %>%
  xml_find_all("..//d1:Contest")

contest <- tibble(contest_id = theNodes %>%
                    xml_find_first("./d1:ContestIdentifier") %>%
                    xml_attr("Id") %>%
                    as.integer(),

                  Division = theNodes %>%
                    xml_find_first("./d1:ContestIdentifier/d1:ContestName") %>%
                    xml_text()
                  )

## candidates


theNodes <- read_xml(here("data/2022/preload/aec-mediafeed-results-detailed-preload-27966.xml")) %>%
  xml_find_all("//d1:FirstPreferences[ not( ancestor::d1:PollingPlaces ) ]/d1:Candidate | //d1:FirstPreferences[ not( ancestor::d1:PollingPlaces ) ]/d1:Ghost")

candidates <- tibble(
  Division = theNodes %>%
    xml_find_first("ancestor::d1:Contest/eml:ContestIdentifier/eml:ContestName") %>%
    xml_text(),

  candidate_id = theNodes %>%
    xml_find_first("./eml:CandidateIdentifier") %>%
    xml_attr("Id") %>% as.integer,

  name = theNodes %>%
    xml_find_first("./eml:CandidateIdentifier/eml:CandidateName") %>%
    xml_text(),

  affiliation_id = theNodes %>%
    xml_find_first("./eml:AffiliationIdentifier") %>%
    xml_attr("Id") %>% as.integer(),

  affiliation_abb = theNodes %>%
    xml_find_first("./eml:AffiliationIdentifier") %>%
    xml_attr("ShortCode") %>% as.character(),

  affiliation_name = theNodes %>%
    xml_find_first("./eml:AffiliationIdentifier/eml:RegisteredName") %>%
    xml_text(),

  ballot_position = theNodes %>%
    xml_find_first("./d1:BallotPosition") %>% xml_integer(),

  elected = theNodes %>%
    xml_find_first("./d1:Elected") %>% xml_text(),

  elected_historic = theNodes %>%
    xml_find_first("./d1:Elected") %>% xml_attr("Historic") %>% as.character(),

  incumbent = theNodes %>%
    xml_find_first("./d1:Incumbent") %>% xml_text(),

  incumbent_notional = theNodes %>%
    xml_find_first("./d1:Incumbent") %>% xml_attr("Notional") %>% as.character(),

  independent = theNodes %>% xml_attr("Independent") %>% as.character()
) %>%
  mutate(independent = replace_na(independent,"false"),
         affiliation_abb = if_else(independent=="yes" | independent=="true",
                                   "IND",
                                   affiliation_abb))




########################################################
## polling places

theNodes <- read_xml(here("data/2022/preload/aec-mediafeed-pollingdistricts-27966.xml")) %>%
  xml_find_all("..//d1:PollingPlace")

pollingPlaces <- tibble(Division = theNodes %>%
                          xml_find_first("ancestor::d1:PollingDistrict/d1:PollingDistrictIdentifier/d1:Name") %>%
                          xml_text(),

                        pp_name = theNodes %>%
                          xml_find_all("./d1:PollingPlaceIdentifier") %>%
                          xml_attr("Name"),

                        pp_id = theNodes %>%
                          xml_find_all("./d1:PollingPlaceIdentifier") %>%
                          xml_attr("Id") %>% as.integer()

                        )


parties <- read_csv(file=url("https://tallyroom.aec.gov.au/Downloads/GeneralPartyDetailsDownload-27966.csv"),
                    skip=1) %>%
  rename(affiliation_abb=PartyAb,
         affiliation_name=PartyNm) %>%
  mutate(party_group = case_when(
    affiliation_abb == "ALP" ~ "Labor",
    affiliation_abb %in% c("LP","LNP","NP","CLP") ~ "Coalition",
    grepl(pattern="Green",affiliation_name) ~ "GRN",
    affiliation_abb == "UAPP" ~ "UAP",
    affiliation_abb == "ON" ~ "PHON",
    TRUE ~ "OTH")
  )

parties_affiliation_group_xwalk <- parties %>%
  select(affiliation_abb,party_group) %>%
  distinct()


## postal applications
postal_applications <- read_csv(url("https://www.aec.gov.au/election/files/downloads/Postal-Votes-220521.csv")) %>%
  rename(applications=`Valid Applications Received`,
         returned=`Postal Votes Returned`)

## enrolment
enrolled <- read_csv(file=url("https://tallyroom.aec.gov.au/Downloads/GeneralEnrolmentByDivisionDownload-27966.csv"),skip=1) %>%
  rename(Division=DivisionNm) %>%
  filter(DivisionID!=0) %>%
  select(Division,Enrolment)


## demographic classification
demo_classification <- xlsx::read.xlsx("~/Downloads/demographic-classification-as-at-2-august-2021.xlsx",
                                       sheetIndex = 1,
                                       startRow = 4)
names(demo_classification) <- c("Division","class","State","X")

save("pollingPlaces","candidates",
     "contest","parties",
     "postal_applications",
     "parties_affiliation_group_xwalk",
     "enrolled",
     "demo_classification",
     file=here("data/2022/preload/pre_load.RData"))








