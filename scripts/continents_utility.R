library(tidyverse)
library(stringr)


files <- list.files("continent_data/")
files_raw <- str_sub(files, end = -5)

data_list <- lapply(paste0("./continent_data/", files), read.csv)
data_list

for (i in 1:length(data_list)){
  data_list[[i]]$Continent <- files_raw[i]
}
data_list

continents_df <- bind_rows(data_list)
continents <- continents_df %>% select(Country.Area.Name, Continent) %>%
  rename(Country = Country.Area.Name)

?rename

world_data <- read.csv("worlddata_old.csv")

world <- world_data %>%
  left_join(continents) %>%
  select(-c(1:3), -Year) %>%
  relocate(Continent, .after = Country)

world


write.csv(world, "worlddata.csv", row.names = FALSE)
