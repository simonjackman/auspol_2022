########################################################
## seats changing hands
##
## simon jackman
## simon.jackman@sydney.edu.au
##
## 2022-05-28 19:48:35
########################################################

library(tidyverse)
library(here)

changing_hands <- data$tcp %>%
  mutate(candidate_id=as.integer(candidate_id)) %>%
  left_join(candidates %>%
              select(Division,candidate_id,name,affiliation_abb),
            by=c("Division","candidate_id")
  ) %>%
  group_by(Division) %>%
  summarise(leading_party = affiliation_abb[which.max(per)]) %>%
  ungroup() %>%
  left_join(candidates %>%
              filter(incumbent=="true" | incumbent_notional=="true") %>%
              select(Division,inc_party=affiliation_abb),
            by=c("Division")
  ) %>%
  mutate(changing_hands = inc_party!=leading_party)


