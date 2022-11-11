########################################################
## postals
##
## simon jackman
## simon.jackman@sydney.edu.au
##
## 2022-05-23 12:09:50
########################################################

library(tidyverse)
library(here)
library(rvest)
library(xml2)


source(here("code/goLive.R"))
source(here("code/parse_functions.R"))

load(here(paste("data",year,"working/latest.RData",sep="/")))

d_type <- data$tcp_type %>%
  mutate(simple_type = Type) %>%
  group_by(Division,candidate_id,simple_type) %>%
  summarise(v=sum(v),
            v_historic=sum(v_historic)) %>%
  ungroup() %>%
  group_by(Division,simple_type) %>%
  mutate(per=v/sum(v)*100,
         per_historic=v_historic/sum(v_historic)*100,
         swing = per - per_historic) %>%
  ungroup() %>%
  left_join(candidates,
            by=c("Division","candidate_id")) %>%
  join_parties() %>%
  select(Division,name,
         party_group,simple_type,
         v,per,v_historic,per_historic,swing)

d_analysis <- d_type %>%
  group_by(Division,simple_type) %>%
  summarise(party_ahead = party_group[which.max(v)],
            lead = max(v)-min(v)) %>%
  ungroup()

postal_tactical_situation <- function(theDivision){

  v <- d_type %>%
    filter(Division==theDivision)

  leads <- d_analysis %>%
    filter(Division==theDivision) %>%
    pivot_wider(id_cols = Division,
                names_from = simple_type,
                values_from = c(party_ahead,lead)) %>%
    left_join(dvotes %>%
                select(Division,issued,received,processed,accept_rate),
              by="Division")

  out <- NULL
  if(leads$party_ahead_E != leads$party_ahead_PE){
      catch_rate <- leads$lead_PE/leads$processed
      expectedPostals <- leads$issued*.799
      expectedGain <- catch_rate*expectedPostals
      expectedResult <- ifelse(expectedGain > leads$lead_E,
                               leads$party_ahead_PE,
                               leads$party_ahead_E)

      out <- tibble(party_ahead_E = leads$party_ahead_E,
                    lead_E = leads$lead_E,
                    party_ahead_PE = leads$party_ahead_PE,
                    lead_PE = leads$lead_PE,
                    catch_rate=catch_rate,
                    expectedPostals=expectedPostals,
                    expectedGain=expectedGain,
                    expectedLead=leads$lead_E - expectedGain,
                    expectedResult = expectedResult)
  }
  return(out)
}


postal_situation <- list()
for(d in unique(d_type$Division)){
  postal_situation[[d]] <- postal_tactical_situation(d)
}

postal_situation <- bind_rows(postal_situation,.id="Division") %>%
  mutate(flag = party_ahead_E != expectedResult) %>%
  arrange(desc(flag),expectedLead)


