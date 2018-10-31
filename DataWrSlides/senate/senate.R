## 2018 Senate Race; data from https://projects.fivethirtyeight.com/2018-midterm-election-forecast/senate/?ex_cid=rrpromo

## load libraries
library(tidyverse)

## read in data
senate <- read_csv("senate_seat_forecast.csv")

## extract subset of data
senate <- senate %>%
    filter(forecastdate == max(forecastdate)) %>%
    filter(model == "classic") %>%
    filter(party != "false") %>%
    filter(class == 1) %>%
    select(state, party, win_probability) %>%
    mutate(party = ifelse(party == "G", "O", party)) %>%
    mutate(party = ifelse(party == "L", "O", party)) %>%
    mutate(party = ifelse(party == "I", "O", party)) %>%
    group_by(state, party) %>%
    summarise(win_probability = sum(win_probability)) %>%
    ungroup() %>%
    mutate(id = 1:n()) %>%
    spread(party, win_probability) %>%
    select(-id)

## save output
saveRDS(senate, "senate.rds")

## check that probabilities add up
senate %>%
    gather(party, prob, -state) %>%
    filter(!is.na(prob)) %>%
    group_by(state) %>%
    summarise(sum = sum(prob)) %>%
    arrange(-sum)