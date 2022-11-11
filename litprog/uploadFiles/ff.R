## load libraries
library(tidyverse)

## load data
ff <- read_csv("ff.csv")

## convert columns to correct format
## and simplify column names
ff <- mutate(ff, partners = as.character(partners)) %>%
    rename(partner_type = `partner type`)

## produce summary plot
ggplot(ff, aes(y = longevity, x = thorax, 
               linetype = partner_type, 
               shape = partner_type)) +
    geom_point() +
    stat_smooth(method = "lm", se = FALSE) +
    facet_wrap(~partners) +
    labs(linetype = "Partner Type", 
         shape = "Partner Type") +
    ylab("Longevity (days)") +
    xlab("Thorax length (mm)") +
    theme_bw()
