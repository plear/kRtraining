library(tidyverse)

unemploymentClaims <- read_csv("data/UI Claims - State - Weekly.csv")
GeoIDs <- read_csv("data/GeoIDs - State.csv")

obsIssue <- problems(unemploymentClaims) %>% 
  select(row) %>% 
  distinct()

colIssue <- problems(unemploymentClaims) %>% 
  select(col) %>% 
  distinct()

unemploymentClaims[obsIssue$row,] %>% View()

# Simple joins of two tables - we'll revist more complex joins later
unemploymentClaims %>% left_join(GeoIDs)

unemploymentClaims %>% left_join(GeoIDs, by = "statefips")

uiClaimsMi <- unemploymentClaims %>% left_join(GeoIDs %>% select(statefips, stateabbrev), by = "statefips") %>% 
  filter(stateabbrev == "MI")

# Basic grouping/summarizing
uiClaimsMi %>% 
  group_by(year, month, stateabbrev)

monthlyClaimsMi <- uiClaimsMi %>% 
  group_by(year, month, stateabbrev) %>% 
  summarize(initclaims = sum(initclaims_count_combined, na.rm=TRUE))

#  Tidy functions
spread(monthlyClaimsMi, year, initclaims)

spread(monthlyClaimsMi, month, initclaims)

nonTidydf <- spread(monthlyClaimsMi, year, initclaims)

gather(nonTidydf, "year", "newVariableName", 3:4)
gather(nonTidydf, "year", "newVariableName", c("2020", "2021"))

uiClaimsMi %>% 
  select(year, month, day_endofweek, stateabbrev, initclaims_count_combined) %>% 
  unite("date", c(day_endofweek, month, year), sep="/")  # Not the best way to create a date value...more later

uiClaimsMi %>% 
  select(year, month, day_endofweek, stateabbrev, initclaims_count_combined) %>% 
  unite("date", c(day_endofweek, month, year), sep="/") %>% 
  separate(date, c("day", "month", "year"))   #Seperate does the opposite of unite





#   Joins
#   Lubridate/stringr
#   Case_when

#   Stat functions

