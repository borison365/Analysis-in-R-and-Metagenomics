

install.packages("tidyverse")
install.packages("here")
library(tidyverse)
library(here)

tv_hours_table <- gss_cat %>% 
  filter(age>30) %>% 
  group_by(marital) %>% 
  summarise(mean_tv_hours = mean(tvhours, na.rm = T))

write_csv(tv_hours_table, here("TV_hours_by_marital.csv"))
