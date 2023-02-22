########################################################
## senate turnout, state and divisional
##
## simon jackman
##
##
## 2022-12-03 10:42:41.798005
########################################################

library(tidyverse)
library(here)

senate_turnout_state <- read_csv(url("https://results.aec.gov.au/27966/Website/Downloads/SenateTurnoutByStateDownload-27966.csv"),skip = 1)

senate_turnout_division <- read_csv(url("https://results.aec.gov.au/27966/Website/Downloads/SenateTurnoutByDivisionDownload-27966.csv"),skip = 1)
house_turnout_division <- read_csv(url("https://results.aec.gov.au/27966/Website/Downloads/HouseTurnoutByDivisionDownload-27966.csv"),skip=1)


## polling place senate turnout
ids <- senate_turnout_division %>%
  distinct(DivisionID) %>%
  pull(DivisionID)

baseURL <-
  "https://results.aec.gov.au/27966/Website/Downloads/SenateDivisionFirstPrefsByPollingPlaceDownload-27966-999.csv"
out <- list()
counter <- 0
for (i in ids) {
  counter <- counter + 1
  theURL <- str_replace(baseURL,
                        pattern = "999",
                        replacement = as.character(i))
  cat(paste(theURL, "\n"))

  out[[counter]] <- read_csv(url(theURL), skip = 1) %>%
    group_by(PollingPlaceID) %>%
    summarise(
      pp_nm = PollingPlaceNm[1],
      div_nm = DivisionNm[1],
      state = StateAb[1],
      v = sum(OrdinaryVotes)
    ) %>%
    ungroup()

}

senate_turnout_pp <- bind_rows(out)

senate_dec <- read_csv(
  url(
    "https://results.aec.gov.au/27966/Website/Downloads/SenateFirstPrefsByDivisionByVoteTypeDownload-27966.csv"
    ),
  skip=1) %>%
  select(-OrdinaryVotes,-TotalVotes) %>%
  pivot_longer(cols=ends_with("Votes"),
               names_to = "pp_nm",
               values_to = "v") %>%
  mutate(pp_nm = str_remove(pp_nm,pattern="Votes$")) %>%
  mutate(pp_nm = if_else(pp_nm=="PrePoll","Pre-Poll",pp_nm)) %>%
  rename(div_nm=DivisionNm,state=StateAb) %>%
  group_by(div_nm,pp_nm) %>%
  summarise(state=state[1],
            pp_id=0,
            v=sum(v)) %>%
  ungroup()


