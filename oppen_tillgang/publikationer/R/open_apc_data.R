# Script for SUHF metricsgrupp course 24 november 2023
# Johan Fröberg, KB
#
# Calculate average APC based on OpenAPC data for SE publications 2018-2023
# 

library(tidyverse)


# 1. load open APC data -----------------------------------------------------------


open_apc_se <- read.csv("indata/open_apc_se.csv")

open_apc_se_1822 <- filter(open_apc_se, period >= 2018 & period < 2023) 


# 2. calculate yearly and period average, publishers with n > 60 hybrid or gold ----


# calculate yearly average producing pivot
yearly_average_apc <- group_by(open_apc_se_1822, publisher, period, is_hybrid) %>% 
  summarise(antal_doi = n(),
            medel_apc = round(mean(euro), digits=0)
  ) %>% 
  pivot_wider(id_cols = c(publisher, is_hybrid), names_from = c(period), values_from = c(antal_doi, medel_apc)) %>% 
  mutate(total_antal_doi = across(starts_with("antal")) %>% rowSums(na.rm = TRUE)) %>% 
  filter(total_antal_doi > 60) %>% 
  select(-total_antal_doi)

# calculate period average
period_average_apc <- group_by(open_apc_se_1822, publisher, is_hybrid) %>% 
  summarise(total_antal_doi = n(),
            period_average_apc = round(mean(euro), digits = 0)
  ) %>% 
  filter(total_antal_doi > 60)

# 3. combine to table with column oa_type specifying hybrid or gold ---------------
average_apc <- left_join(period_average_apc, yearly_average_apc, by = c("publisher", "is_hybrid")) %>% 
  mutate(oa_type = if_else(is_hybrid == TRUE, "hybrid", "gold"), .after = publisher) %>% 
  select(-is_hybrid) %>% 
  arrange(oa_type, str_to_lower(publisher))

