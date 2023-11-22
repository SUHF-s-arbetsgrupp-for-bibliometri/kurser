# Script for SUHF Metricsgrupp course 24 november 2023
# Johan Fröberg, KB
#
# Compile info on open access for your university for 2022 based on data from 
# KB:s Öppen tillgång i siffror

library(tidyverse)

org = "xx.se" # Change to your university's domain e.g. su.se


# 1. Read downloaded csv file and filter for your university -------------


oa_2022_data <- read.csv("indata/oa_2023_results_orgs_2022.csv") # make sure file path is correct

# filter for publications for your university, remove is_oa = NA (no response from Unpaywall)
# add info on oa_status according to KB:s categorization
org_publ <- filter(oa_2022_data, aff == org & !is.na(is_oa)) %>% 
  mutate(kb_oa_status = case_when(journal_is_in_doaj == TRUE ~ "gold",
                                  hybrid == TRUE ~ "hybrid",
                                  only_repo == TRUE ~ "green",
                                  TRUE ~ "closed"
                                  )
  ) 


# 2. Compile articles per oa_type in oa_info table -----------------------


gold <- filter(org_publ, kb_oa_status == "gold") %>% 
  distinct(doi, .keep_all = TRUE)

oa_info <- gold

hybrid <- anti_join(org_publ, oa_info, by = "doi") %>% 
  filter(kb_oa_status == "hybrid") %>% 
  distinct(doi, .keep_all = TRUE)

oa_info <- bind_rows(oa_info, hybrid)

only_repo <- anti_join(org_publ, oa_info, by = "doi") %>% 
  filter(kb_oa_status == "green") %>% 
  distinct(doi, .keep_all = TRUE)

oa_info <- bind_rows(oa_info, only_repo)

closed <- anti_join(org_publ, oa_info, by = "doi") %>% 
  filter(kb_oa_status == "closed") %>% 
  distinct(doi, .keep_all = TRUE)

oa_info <- bind_rows(oa_info, closed) 


# 3. Create summary table of no. of articles and share per oa type -----------


summary_org_oa <- group_by(oa_info, kb_oa_status) %>% 
  summarise(antal = n()) %>% 
  mutate(andel = round(antal / sum(antal), 2)) %>% 
  arrange(kb_oa_status)
  