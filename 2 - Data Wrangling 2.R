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
  unite("date", c(day_endofweek, month, year), sep="/") 

uiClaimsMi %>% 
  select(year, month, day_endofweek, stateabbrev, initclaims_count_combined) %>% 
  unite("date", c(day_endofweek, month, year), sep="/") %>% 
  separate(date, c("day", "month", "year"))   #Seperate does the opposite of unite

#   Lubridate
library(lubridate) #install.packages("lubridate")

uiClaimsMi %>% 
  select(year, month, day_endofweek, stateabbrev, initclaims_count_combined) %>% 
  unite("date", c(day_endofweek, month, year), sep="/") %>% 
  mutate(dateType = dmy(date)) # Functions correspond to order of string


uiClaimsMi %>% 
  select(year, month, day_endofweek, stateabbrev, initclaims_count_combined) %>% 
  unite("date", c(month, year, day_endofweek), sep="/") %>% 
  mutate(dateType = myd(date)) # Functions correspond to order of string
  

#   Case_when
uiClaimsMi %>% 
  select(year, month, day_endofweek, stateabbrev, initclaims_count_combined) %>%
  mutate(Month = case_when(
    month == 1 ~ "Jan",
    month == 2 ~ "Feb",
    month == 3 ~ "Mar",
    month == 4 ~ "Apr",
    month == 5 ~ "May",
    month == 6 ~ "Jun",
    month == 7 ~ "Jul",
    month == 8 ~ "Aug",
    month == 9 ~ "Sep",
    month == 10 ~ "Oct",
    month == 11 ~ "Nov",
    month == 12 ~ "Dec"
  )) %>% 
  unite("date", c(Month, year, day_endofweek), sep="-") %>% 
  mutate(dateType = myd(date)) # Functions correspond to order of string

#   Joins



#   Stat functions





