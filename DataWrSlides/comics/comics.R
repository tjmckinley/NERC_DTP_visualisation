## extract subsets of comic book data

## load libraries
library(tidyverse)

## load data (data from https://github.com/fivethirtyeight/data/blob/master/comic-characters/marvel-wikia-data.csv)
marvel <- read_csv("marvel-wikia-data.csv")

## extract subsets
mM <- marvel %>%
    filter(SEX == "Male Characters") %>%
    slice(1)
mF <- marvel %>%
    filter(SEX == "Female Characters") %>%
    slice(1)
mNA <- marvel %>%
    filter(is.na(Year)) %>%
    slice(1)
marvel <- rbind(mM, mF, mNA)
rm(mM, mF, mNA)

## separate into tables
publisher <- marvel %>%
    select(name) %>%
    mutate(publisher = "Marvel")
year_published <- marvel %>%
    select(name, Year) %>%
    na.omit()
marvel <- marvel %>%
    select(name, EYE, HAIR, SEX, APPEARANCES)

## load data (data from https://github.com/fivethirtyeight/data/blob/master/comic-characters/dc-wikia-data.csv)
dc <- read_csv("dc-wikia-data.csv") %>%
    rename(Year = YEAR)

## extract subsets
mM <- dc %>%
    filter(SEX == "Male Characters") %>%
    slice(1)
mF <- dc %>%
    filter(SEX == "Female Characters") %>%
    slice(1)
mNA <- dc %>%
    filter(is.na(Year)) %>%
    slice(1)
dc <- rbind(mM, mF, mNA)
rm(mM, mF, mNA)

## separate into tables
publisher <- dc %>%
    select(name) %>%
    mutate(publisher = "DC") %>%
    rbind(publisher)
year_published <- dc %>%
    select(name, Year) %>%
    na.omit() %>%
    rbind(year_published)
comics <- dc %>%
    select(name, EYE, HAIR, SEX, APPEARANCES) %>%
    rbind(marvel) %>%
    select(-SEX)
rm(marvel, dc)

## write tables out
saveRDS(as.data.frame(comics), "comics.rds")
saveRDS(as.data.frame(publisher), "publisher.rds")
saveRDS(as.data.frame(year_published), "year_published.rds")


