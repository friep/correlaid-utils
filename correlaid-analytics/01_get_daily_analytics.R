################################################################################
# 01_get_daily_analytics.R                                                     #
################################################################################
library(smcounts)
library(tibble)

# read renviron file
readRenviron("correlaid-analytics/.Renviron")
today <- Sys.Date()

# nonstandard path of slackr file - skip and execute manually
today_df <- smcounts::collect_data(slack = FALSE) 
cnt <- smcounts::ca_slack("correlaid-analytics/.slackr")
today_df <- today_df %>% 
  add_row(n = cnt, platform = "slack", date = today)

# write daily json
path <- glue::glue("correlaid-analytics/data/days/{today}.json")
today_df %>% jsonlite::write_json(path)
today_list <- jsonlite::read_json(path) # read back in to get list (too lazy to manually transform)

# load all daily data and append new data
all_days <- jsonlite::read_json("correlaid-analytics/data/all_daily.json")
new_list <- c(all_days, today_list)
new_list %>% jsonlite::write_json("correlaid-analytics/data/all_daily.json")