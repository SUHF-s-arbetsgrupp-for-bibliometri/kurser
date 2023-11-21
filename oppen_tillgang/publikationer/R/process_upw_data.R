# Script for SUHF Metricsgrupp course 24 november 2023
# Johan Fröberg, KB
#
# Process data from Unpaywall and compile stats per type of oa for comparison

library(tidyverse)


# 1. Add columns for gold, hybrid and repo according to KB criteria ------------


upw_result <- mutate(upw_result_raw, 
                     gold = case_when(journal_is_in_doaj == TRUE ~ TRUE, 
                                    TRUE ~ FALSE),
                     hybrid = case_when(journal_is_in_doaj == FALSE &
                                          host_type == "publisher" &
                                          str_detect(license, "cc-by") ~ TRUE,
                                        TRUE ~ FALSE),
                     repo = case_when(host_type == "repository" & 
                                      (version == "publishedVersion"| version == "acceptedVersion") ~ TRUE,
                                    TRUE ~ FALSE
                                    )) 


# 2. Determine if only found in repo, add info on only repo --------------


# find all in repos
all_repos <- filter(upw_result, repo == TRUE) %>% 
  distinct()

# find all hybrid and gold
all_hybrid_gold <- filter(upw_result, journal_is_in_doaj == TRUE | hybrid == TRUE) %>% 
  distinct()

# find all only in repos by anti join, add only_repo column, select doi and only repo info
only_repos <- anti_join(all_repos, all_hybrid_gold, by = "doi") %>% 
  mutate(only_repo = TRUE) %>% 
  select(doi, only_repo) %>% 
  distinct()

# add info on only in repo to oa_result, and info on gold, hybrid, only repo or not oa
upw_result_final <- left_join(upw_result, only_repos, by = "doi") %>% 
  mutate(only_repo = if_else(is.na(only_repo), FALSE, TRUE))


# 3. Add column with oa_status


upw_result_final <- mutate(upw_result_final,
               kb_oa_status = case_when(
                 gold == TRUE ~ "gold",
                 hybrid == TRUE ~ "hybrid",
                 only_repo == TRUE ~ "green",
                 TRUE ~ "closed"
                 )
               ) 


# 4. Compile articles per oa_type in oa_info table -----------------------


gold <- filter(upw_result_final, kb_oa_status == "gold") %>% 
  distinct(doi, .keep_all = TRUE)

oa_info <- gold

hybrid <- anti_join(upw_result_final, oa_info, by = "doi") %>% 
  filter(kb_oa_status == "hybrid") %>% 
  distinct(doi, .keep_all = TRUE)

oa_info <- bind_rows(oa_info, hybrid)

only_repo <- anti_join(upw_result_final, oa_info, by = "doi") %>% 
  filter(kb_oa_status == "green") %>% 
  distinct(doi, .keep_all = TRUE)

oa_info <- bind_rows(oa_info, only_repo)

closed <- anti_join(upw_result_final, oa_info, by = "doi") %>% 
  filter(kb_oa_status == "closed") %>% 
  distinct(doi, .keep_all = TRUE)

oa_info <- bind_rows(oa_info, closed)


# 5. Summarise for kb and unpaywall categorization, and make comparison --


oa_summary_kb <- group_by(oa_info, kb_oa_status) %>% 
  summarise(antal_kb = n())

oa_summary_upw <- group_by(oa_info, upw_oa_status) %>% 
  summarise(antal_upw = n())

oa_comparison <- full_join(oa_summary_upw, oa_summary_kb, 
                           by = c("upw_oa_status" = "kb_oa_status" )) 

