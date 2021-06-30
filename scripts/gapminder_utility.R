library(tidyverse)
d <- read.csv("data/gapminder_income_full.csv")

d <- select(d, Country, X2020)

d <- d %>% 
  mutate(Income = ifelse(
    str_detect(X2020, "k"),
    as.numeric(str_sub(X2020, 1, -2))*1000,
    as.numeric(X2020)
  )) %>%
  select(Country, Income)

write_csv(d, "docs/data/gdp_per_capita.csv")
