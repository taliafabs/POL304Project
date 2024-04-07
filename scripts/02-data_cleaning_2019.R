#### Preamble ####
# Purpose: Clean the data
# Author: Talia Fabregas
# Date: April 2 2024
# Contact: talia.fabregas@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download the raw data for researchers table 12
# 42nd, 43rd, and 44th general election from Elections Canada
# and save it to data/raw_data

#### Workplace Setup ####
library(tidyverse)
library(janitor)

raw_data_2019 <- read_csv("data/raw_data/table_tableau12_2019.csv")

#### Clean Data ####

data2019 <- raw_data_2019

colnames(data2019)[colnames(data2019) == "Candidate/Candidat"] <- "candidate"
colnames(data2019)[colnames(data2019) == "Electoral District Name/Nom de circonscription"] <- "riding_name"
colnames(data2019)[colnames(data2019) == "Electoral District Number/Numéro de circonscription"] <- "riding_num"
colnames(data2019)[colnames(data2019) == "Percentage of Votes Obtained /Pourcentage des votes obtenus"] <- "percent_votes_received"
colnames(data2019)[colnames(data2019) == "Majority Percentage/Pourcentage de majorité"] <- "percentage_point_margin"

data2019 <- data2019 |> 
  select(riding_name, riding_num, candidate, percent_votes_received, percentage_point_margin)

extract_party <- function(text) {
  party <- gsub(".*(Liberal|NDP-New Democratic Party|Conservative|Green Party|Bloc Québécois/Bloc Québécois).*", "\\1", text)
  if (party %in% c("Liberal", "NDP-New Democratic Party", "Conservative", "Green Party", "Bloc Québécois/Bloc Québécois")) {
    return(party)
  } else {
    return("Other")
  }
}

data2019$party <- sapply(data2019$candidate, extract_party)

data2019 <- data2019 |> 
  select(riding_num, riding_name, party, percent_votes_received, percentage_point_margin)

#### Save Data ####
write_csv(data2019, "data/analysis_data/cleaned_data_2019")

# riding_summary <- data2019 %>%
#   group_by(riding_num) %>%
#   summarise(top_party = first(party),
#             second_party = ifelse(n() > 1, nth(party, 2), NA))
# 
# # find the ridings where the top two parties are liberal and conservative
# liberal_ridings <- riding_summary |>
#   filter(top_party == "Liberal" & second_party == "Conservative")
# 
# conservative_ridings <- riding_summary |>
#   filter(top_party == "Conservative" & second_party == "Liberal")
# 
# # filter to focus on Liberal, CPC, NDP
# filtered_data <- data2019 %>%
#   filter(party %in% c("Liberal", "Conservative", "NDP-New Democratic Party")) %>%
#   filter(riding_num %in% conservative_ridings$riding_num | riding_num %in% liberal_ridings$riding_num)
# 
# # treatment group: ridings where margin between Liberals and Conservatives is less than 10
# treatment <- filtered_data |>
#   filter(percentage_point_margin < 10)
# 
# treatment_ridings <- filtered_data |>
#   filter(riding_num %in% treatment$riding_num)
# 
# control_ridings <- filtered_data |>
#   filter(!riding_num %in% treatment$riding_num)
# 
# control_ndp <- control_ridings |>
#   filter(party == "NDP-New Democratic Party")
# 
# treatment_ndp <- treatment_ridings |>
#   filter(party == "NDP-New Democratic Party")
# 
# 
# 
# 
