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

raw_data_2021 <- read_csv("data/raw_data/table_tableau12_2021.csv")

#### Clean Data ####


data2021 <- raw_data_2021

colnames(data2021)[colnames(data2021) == "Candidate/Candidat"] <- "candidate"
colnames(data2021)[colnames(data2021) == "Electoral District Name/Nom de circonscription"] <- "riding_name"
colnames(data2021)[colnames(data2021) == "Electoral District Number/Numéro de circonscription"] <- "riding_num"
colnames(data2021)[colnames(data2021) == "Percentage of Votes Obtained /Pourcentage des votes obtenus"] <- "percent_votes_received"
colnames(data2021)[colnames(data2021) == "Majority Percentage/Pourcentage de majorité"] <- "percentage_point_margin"

data2021 <- data2021 |> 
  select(riding_name, riding_num, candidate, percent_votes_received, percentage_point_margin)

extract_party <- function(text) {
  party <- gsub(".*(Liberal|NDP-New Democratic Party|Conservative|Green Party|Bloc Québécois/Bloc Québécois).*", "\\1", text)
  if (party %in% c("Liberal", "NDP-New Democratic Party", "Conservative", "Green Party", "Bloc Québécois/Bloc Québécois")) {
    return(party)
  } else {
    return("Other")
  }
}


data2021$party <- sapply(data2021$candidate, extract_party)

data2021 <- data2021 |> 
  select(riding_num, riding_name, party, percent_votes_received, percentage_point_margin)

#### Save Data ####
write_csv(data2021, "data/analysis_data/cleaned_data_2021")
