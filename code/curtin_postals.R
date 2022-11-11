########################################################
## progress of dec votes in Curtin
##
## simon jackman
## simon.jackman@sydney.edu.au
##
## 2022-05-26 09:24:45
########################################################

library(tidyverse)
library(here)
library(fst)

tcp <- read_fst(here("data/2022/tcp_progress.fst"))
tcp_type <- read_fst(here("data/2022/tcp_type_progress.fst"))

make_plotData_postal_progress <- function(theDivision){
  plotData <- bind_rows(
    tcp_type %>%
      filter(Division==theDivision) %>%
      filter(party_group=="IND"),
    tcp %>%
      filter(Division==theDivision) %>%
      filter(party_group=="IND") %>%
      mutate(Type="Total")
  )
  return(plotData)
}

plot_postal_progress <- function(theDivision){
  plotData <- make_plotData_postal_progress(theDivision)
  g <- ggplot(plotData %>%
                filter(Type %in% c("Ordinary","Postal","Total")),
              aes(x=timestamp,
                  y=per,
                  group=Type,
                  color=Type)) +
    geom_hline(yintercept = 50) +
    geom_line() +
    scale_x_datetime("",expand=c(0,0)) +
    scale_y_continuous("Percentage for IND",breaks=seq(40,60,by=5),limits = c(40,60),expand=c(0,0),minor_breaks = NULL) +
    ggtitle(paste0(theDivision,", progressive TCP percentages for IND by vote type"))
  return(g)
}

mydiff <- function(x){x - dplyr::lag(x)}

byBatch <- function(theDivision,type="Postal"){
  plotData <- make_plotData_postal_progress(theDivision)
  out <- plotData %>% filter(Type==type) %>% mutate(delta=v-lag(v)) %>% filter(delta!=0)
  out <- tcp_type %>% filter(Division==theDivision) %>% filter(Type==type) %>% semi_join(out,by="timestamp")
  out <- out %>% pivot_wider(id_cols=c("Division","Type","timestamp"),names_from = "party_group",values_from = c("v","per"))
  out <- out %>% mutate(across(starts_with("v_"),~mydiff(.x),.names = "d_{.col}"))
  out <- out %>%
    mutate(d_v_Coalition=if_else(is.na(d_v_Coalition),v_Coalition,d_v_Coalition),
           d_v_IND=if_else(is.na(d_v_IND),v_IND,d_v_IND)) %>%
    rename(Coalition=d_v_Coalition,
           IND=d_v_IND) %>%
    select(-starts_with(c("v_","per_"))) %>%
    mutate(Total=Coalition+IND,
           Coalition_per = if_else(Total>10,Coalition/Total*100,NA_real_),
           IND_per=if_else(Total>10,IND/Total*100,NA_real_)
           )

  knitr::kable(out,digits=c(0,0,0,0,0,0,1,1))

}

byBatch("Curtin")
byBatch("Wentworth")
byBatch("Kooyong")
byBatch("Goldstein")


