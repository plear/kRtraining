###############################################################################
# 2 - Data Wrangling 2
###############################################################################

library(tidyverse)

#==============================================================================
# 2.0 - Import and view data
#==============================================================================

unemploymentClaims <- read_csv("data/UI Claims - State - Weekly.csv")
GeoIDs <- read_csv("data/GeoIDs - State.csv")

glimpse(unemploymentClaims)

obsIssue <- problems(unemploymentClaims) %>% 
  select(row) %>% 
  distinct()

colIssue <- problems(unemploymentClaims) %>% 
  select(col) %>% 
  distinct()

unemploymentClaims[obsIssue$row, colIssue$col] %>% View()

#==============================================================================
# 2.1 - Joining two data frames
#==============================================================================
x <- tribble(
  ~V1, ~K,
  "a",   "Q",
  "b",   "W",
  "c",   "E",
  "f",   "T"
)

y <- tribble(
  ~V2, ~K,
  "A",   "Q",
  "B",   "W",
  "C",   "E",
  "D",   "R"
)

# Basic Joins
inner_join(x, y, by = "K")
full_join(x, y, by = "K")

# Primary table joins
left_join(x, y, by = "K")
right_join(x, y, by = "K")

# Filtering joins
semi_join(x, y, by = "K")
anti_join(x, y, by = "K")

# Nested join example
z <- tribble(
  ~V2, ~K,
  "A",   "Q",
  "B",   "Q",
  "C",   "E",
  "D",   "E"
)

nest_join(x, z, by = "K")

# Application with our data

# Left join example
unemploymentClaims %>% left_join(GeoIDs)

unemploymentClaims %>% left_join(GeoIDs, by = "statefips")

uiClaimsMi <- unemploymentClaims %>% 
  left_join(GeoIDs, by = "statefips") %>% 
  select(statefips, stateabbrev) %>% 
  filter(stateabbrev == "MI")

glimpse(uiClaimsMi)

# Right join example
GeoIDs %>% 
  filter(stateabbrev == "MI") %>% 
  right_join(unemploymentClaims, by = "statefips")

#==============================================================================
# 2.2 - Grouping and summarizing data
#==============================================================================

# Basic grouping/summarizing
uiClaimsMi %>% 
  group_by(year, month, stateabbrev)

monthlyClaimsMi <- uiClaimsMi %>% 
  group_by(year, month, stateabbrev) %>% 
  summarize(initclaims = sum(initclaims_count_combined, na.rm=TRUE))

monthlyClaimsMi

monthlyClaimsMiStats <- uiClaimsMi %>% 
  group_by(year, month, stateabbrev) %>% 
  summarize(
    Min_initclaims = min(initclaims_count_combined, na.rm=TRUE),
    Median_initclaims = median(initclaims_count_combined, na.rm=TRUE),
    Mean_initclaims = mean(initclaims_count_combined, na.rm=TRUE),
    Max_initclaims = max(initclaims_count_combined, na.rm=TRUE),
    Sd_initclaims = sd(initclaims_count_combined, na.rm=TRUE)
    )

unemploymentClaims %>% 
  left_join(GeoIDs, by = "statefips") %>% 
  group_by(stateabbrev) %>% 
  count()


#==============================================================================
# 2.3 - Tidy data
#==============================================================================
# https://vita.had.co.nz/papers/tidy-data.pdf

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

#==============================================================================
# 2.4 - Handling data and time values
#==============================================================================
#   Lubridate - helps handle data and time variables
library(lubridate) #install.packages("lubridate")

uiClaimsMi %>% 
  select(year, month, day_endofweek, stateabbrev, initclaims_count_combined) %>% 
  unite("date", c(day_endofweek, month, year), sep="/") %>% 
  mutate(dateType = dmy(date)) # Functions correspond to order of string


uiClaimsMi %>% 
  select(year, month, day_endofweek, stateabbrev, initclaims_count_combined) %>% 
  unite("date", c(month, year, day_endofweek), sep="/") %>% 
  mutate(dateType = myd(date)) # Functions correspond to order of string
  
#==============================================================================
# 2.5 - Creating case values
#==============================================================================
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

#==============================================================================
# 2.6 - Advanced joins
#==============================================================================








