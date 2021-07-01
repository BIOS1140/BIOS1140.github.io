library(tidyverse)
gap <- read.csv("data/gapminder_income_full.csv")

d <- select(gap, Country, X2020)

d <- d %>% 
  mutate(Income = ifelse(
    str_detect(X2020, "k"),
    as.numeric(str_sub(X2020, 1, -2))*1000,
    as.numeric(X2020)
  )) %>%
  select(Country, Income)

write_csv(d, "docs/data/gdp_per_capita.csv")


## Join with worlddata

worlddata <- read_csv("docs/data/worlddata.csv")

income_joined <- left_join(worlddata, d) %>%
  mutate(division = ifelse(Continent == "North America" | Continent == "Europe",
                                                         "The West",
                                                         "The Rest"))

write_csv(income_joined, "docs/data/worlddata_income.csv")

### list of development

gap

numbs <- apply(gap[2:ncol(gap)], 2, function(x) ifelse(str_detect(x, "k"), 
                                 as.numeric(str_sub(x, 1, -2))*1000,
                                 as.numeric(x))) %>%  apply(1, function(x) list(c(x)))



# gap2 <- cbind(gap[1], numbs)
# 
# gap2 %>% 
#   pivot_longer(-Country, names_to = "Year", values_to = "Income", names_pattern = "^X(.*)") %>%
#   group_by(Country) %>%
#   nest() %>%
#   mutate(data_list = lapply(data, function(x) data$Income)) %>%
#   View()

names(numbs) <- gap$Country
numbs <- lapply(numbs, function(x) (x[[1]]))

numbs_sub <- lapply(numbs, function(x) x[which(names(x) == "X1900"):which(names(x) == "X2020")])


# remove names (1900-2020)
for (i in 1:length(numbs_sub)){
  names(numbs_sub[[i]]) <- NULL
}



saveRDS(numbs_sub, "docs/data/gdp_year.rds")

### Assignment 

head(numbs)

diff_vec <- function(x){
  x[length(x)] / x[1]
}

rm(list = ls())

numbs_sub <- readRDS("docs/data/gdp_year.rds")


gdp_change <- sapply(numbs_sub, diff_vec)

gdp_df <- data.frame(gdp_change) %>%
  rownames_to_column("Country")

diffs_join <- left_join(income_joined, gdp_df)
write_csv(diffs_join, "docs/data/worlddata_gdp_change.csv")


ggplot(diffs_join, aes(Continent, gdp_change)) + geom_boxplot()
