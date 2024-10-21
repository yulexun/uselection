#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(rstanarm)

#### Read data ####
analysis_data <- read_csv("data/02-analysis_data/cleaned_data_state.csv")

trump_high_quality = analysis_data |>
  filter(
    candidate_name == "Donald Trump")
  # mutate(
  #   num_trump = round((pct / 100) * sample_size, 0) # Need number not percent for some models
  # )

# ### Model data ####
# first_model <-
#   stan_glm(
#     formula = flying_time ~ length + width,
#     data = analysis_data,
#     family = gaussian(),
#     prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
#     prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
#     prior_aux = exponential(rate = 1, autoscale = TRUE),
#     seed = 853
#   )


# # #### Save model ####
# # saveRDS(
# #   first_model,
# #   file = "models/first_model.rds"
# # )


