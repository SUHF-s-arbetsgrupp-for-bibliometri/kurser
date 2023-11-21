# Script for SUHF Metricsgrupp course 24 november 2023
# Johan Fröberg, KB
#
# Fetch data from Unpaywall for a list of doi:s for articles

library(tidyverse)
library(roadoi)

my_mail <- "your e-mail" # Change this to your e-mail

# list of doi:s to send to Unpaywall
doi_list <- read.csv("indata/dois_for_upw.csv")

# fetch data from Unpaywall
upw_fetch <- purrr::map(doi_list,
                           .f = purrr::safely(
                               function(x) roadoi::oadoi_fetch(
                                   x,
                                   email = my_mail,
                                   .progress = "text")
                           )
)

# create dataframe from result in Unpaywall response (list)
upw_data <- purrr::map_df(upw_fetch, "result")

# select columns and unnest oa_locations to get info on each location, e.g. license info
upw_result_raw <- select(upw_data, doi, oa_locations, is_oa, journal_is_in_doaj, upw_oa_status = oa_status) %>% 
    unnest(cols = c(oa_locations), keep_empty = TRUE)

