#### Preamble ####
# Purpose: Cleans the raw  data from FiveThirtyEight
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 6 April 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
library(tidyverse)
library(readr)

#### Clean data ####
raw_data <- read_csv("data/01-raw_data/president_polls.csv")


cleaned_data <- raw_data |>
  filter(
    numeric_grade >= 2.7
  )

cleaned_data_national <- cleaned_data |>
  filter(is.na(state))

cleaned_data_state <- cleaned_data |>
  filter(!is.na(state))

cleaned_data <- cleaned_data |>
  mutate(
    state = if_else(is.na(state), "National", state), # Hacky fix for national polls - come back and check
    end_date = mdy(end_date),
    start_date = mdy(start_date),
    election_date = mdy(election_date)
  ) |>
  filter(start_date >= as.Date("2024-07-21")) # When Harris declared


cleaned_data <- cleaned_data %>%
  filter(cycle == 2024, office_type == "U.S. President", stage == "general") %>%
  mutate(days_taken_from_election = as.numeric(mdy("11/5/2024") - start_date)) %>%
  select(poll_id, pollster_id, pollster, question_id,
         sample_size, pollscore, methodology, days_taken_from_election,
         end_date, start_date, state, answer, pct)



# Delete NA columns
# cleaned_data <- raw_data |>
#   select(-sponsor_ids, 
#     -sponsors, 
#     -sponsor_candidate_id, 
#     -sponsor_candidate, 
#     -sponsor_candidate_party, 
#     -endorsed_candidate_id, 
#     -endorsed_candidate_name, 
#     -endorsed_candidate_party, 
#     -subpopulation, -tracking, 
#     -notes, -url_article, -url_topline, -url_crosstab,
#     -source, -internal, -partisan, -seat_name, 
#     -ranked_choice_round) |> na.omit()


# Keep data from one pollster for Appendix
# morningconsult_data <- cleaned_data %>%
#   filter(pollster == "Morning Consult")

#### Save data ####
write_csv(cleaned_data, "data/02-analysis_data/cleaned_data.csv")
write_csv(cleaned_data_national, "data/02-analysis_data/cleaned_data_national.csv")
write_csv(cleaned_data_state, "data/02-analysis_data/cleaned_data_state.csv")
# write_csv(morningconsult_data, "data/02-analysis_data/mc_data.csv")
