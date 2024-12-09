#### Preamble ####
# Purpose: Cleans the raw  data from FiveThirtyEight
# Author: Colin Sihan Yang, Siddharth Gowda, Lexun Yu
# Date: 21 October 2024
# Contact: lx.yu@mail.utoronto.ca
# License: MIT
# Pre-requisites: None

#### Workspace setup ####
library(tidyverse)
library(arrow)

#### Clean data ####
raw_data <- read_csv("data/01-raw_data/president_polls.csv")
# head(raw_data %>% mutate(
#   state = if_else(is.na(state), "National", state), # Hacky fix for national polls - come back and check
#   end_date = mdy(end_date),
#   start_date = mdy(start_date)
# ) %>% select(state))


cleaned_data <- raw_data |>
  filter(
    numeric_grade >= 2.5
  )

# Keep data from one pollster for Appendix
morningconsult_data <- cleaned_data %>%
  filter(pollster == "Morning Consult")

cleaned_data <- cleaned_data |>
  mutate(
    state = if_else(is.na(state), "National", state), # Hacky fix for national polls - come back and check
    end_date = mdy(end_date),
    start_date = mdy(start_date),
    election_date = mdy(election_date)
  ) |>
  filter(start_date >= as.Date("2024-07-21")) # When Harris declared

# Election date is 5 Nov 2024
cleaned_data <- cleaned_data %>%
  filter(cycle == 2024, office_type == "U.S. President", stage == "general") %>%
  mutate(days_taken_from_election = as.numeric(mdy("11/5/2024") - start_date)) %>%
  select(
    poll_id, pollster_id, pollster, question_id,
    sample_size, pollscore, methodology, days_taken_from_election,
    end_date, start_date, state, candidate_name, pct
  )

# add weight to pct
cleaned_data$adjusted_weight <- 1 / abs(cleaned_data$pollscore)


# store national and state data seperately
cleaned_data_national <- cleaned_data |>
  filter(state == "National")
cleaned_data_state <- cleaned_data |>
  filter(state != "National")

cleaned_data <- cleaned_data |> na.omit()

#### Save data ####
write_parquet(cleaned_data, "data/02-analysis_data/cleaned_data.parquet")
write_parquet(cleaned_data_national, "data/02-analysis_data/cleaned_data_national.parquet")
write_parquet(cleaned_data_state, "data/02-analysis_data/cleaned_data_state.parquet")
