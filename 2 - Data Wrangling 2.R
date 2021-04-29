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
inner_join(x, y, by = "K") # return all rows from x where there are matching values in y, and all columns from x and y. If there are multiple matches between x and y, all combination of the matches are returned.
full_join(x, y, by = "K") # return all rows and all columns from both x and y. Where there are not matching values, returns NA for the one missing.

# Primary table joins
left_join(x, y, by = "K") # return all rows from x, and all columns from x and y. Rows in x with no match in y will have NA values in the new columns. If there are multiple matches between x and y, all combinations of the matches are returned.
right_join(x, y, by = "K") # return all rows from y, and all columns from x and y. Rows in y with no match in x will have NA values in the new columns. If there are multiple matches between x and y, all combinations of the matches are returned.

# Filtering joins
semi_join(x, y, by = "K") # semi_join() return all rows from x with a match in y
anti_join(x, y, by = "K") # anti_join() return all rows from x without a match in y

# Nested join example
z <- tribble(
  ~V2, ~K,
  "A",   "Q",
  "B",   "Q",
  "C",   "E",
  "D",   "E"
)


nest_join(x, z, by = "K")

# Multi-key Joins
q <- tribble(
  ~V1,   ~K1,  ~K2,
  "a",   "Q",  1,
  "b",   "W",  1,
  "c",   "E",  2,
  "f",   "T",  2
)

w <- tribble(
  ~V2,   ~K1,  ~key2,
  "A",   "Q", 1,
  "B",   "W", 2,
  "C",   "E", 1,
  "D",   "R", 2
)

# Joining without specifying second key
inner_join(q, w, by = "K1")
full_join(q, w, by = "K1")

# Joingin on two keys
inner_join(q, w, by = c("K1", "K2" = "key2"))
full_join(q, w, by = c("K1", "K2" = "key2"))

# Primary table joins
left_join(q, w, by = c("K1", "K2" = "key2"))
right_join(q, w, by = c("K1", "K2" = "key2"))

# Filtering joins
semi_join(q, w, by = c("K1", "K2" = "key2"))
anti_join(q, w, by = c("K1", "K2" = "key2"))

# Application with our data

# Left join example
unemploymentClaims %>% left_join(GeoIDs)

unemploymentClaims %>% left_join(GeoIDs, by = "statefips")

uiClaimsMi <- unemploymentClaims %>% 
  left_join(GeoIDs, by = "statefips") %>% 
  select(statefips, stateabbrev, year, month, initclaims_count_combined) %>% 
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

# Summarize is used in conjunction with group_by to aggregate and calculate summaries for groups within the data
monthlyClaimsMi <- uiClaimsMi %>% 
  group_by(year, month, stateabbrev) %>% 
  summarize(initclaims = sum(initclaims_count_combined, na.rm=TRUE))

monthlyClaimsMiStats <- uiClaimsMi %>% 
  group_by(year, month, stateabbrev) %>% 
  summarize(
    Min_initclaims = min(initclaims_count_combined, na.rm=TRUE),
    Median_initclaims = median(initclaims_count_combined, na.rm=TRUE),
    Mean_initclaims = mean(initclaims_count_combined, na.rm=TRUE),
    Max_initclaims = max(initclaims_count_combined, na.rm=TRUE),
    Sd_initclaims = sd(initclaims_count_combined, na.rm=TRUE)
  )


# You can use mutate instead of summarise if you want to calculate an aggregate level value but still want to retain all of the original rows
monthlyClaimsMi_granular <- uiClaimsMi %>% 
  group_by(year, month, stateabbrev) %>% 
  mutate(initclaims = sum(initclaims_count_combined, na.rm=TRUE))

# Like summarize, count is often useful for providing an aggregate view of records belonging to a group(s)
unemploymentClaims %>% 
  left_join(GeoIDs, by = "statefips") %>% 
  group_by(stateabbrev) %>% 
  count()


#==============================================================================
# 2.3 - Tidy data
#==============================================================================
# https://vita.had.co.nz/papers/tidy-data.pdf

#  Tidy functions
pivot_wider(monthlyClaimsMi, names_from = year, values_from = initclaims)

pivot_wider(monthlyClaimsMi, names_from = month, values_from = initclaims)

# spread has been replaced by pivot_wider
# spread(monthlyClaimsMi, year, initclaims)
# spread(monthlyClaimsMi, month, initclaims)

nonTidydf <- spread(monthlyClaimsMi, year, initclaims)

# gather has been replaced by pivot_longer()
gather(nonTidydf, "year", "newVariableName", 3:4)
gather(nonTidydf, "year", "newVariableName", c("2020", "2021"))

uiClaimsMi %>% 
  select(year, month, day_endofweek, stateabbrev, initclaims_count_combined) %>% 
  unite("date", c(day_endofweek, month, year), sep="/") 

uiClaimsMi %>% 
  select(year, month, day_endofweek, stateabbrev, initclaims_count_combined) %>% 
  unite("date", c(day_endofweek, month, year), sep="/") %>% 
  separate(date, c("day", "month", "year"))   #Separate does the opposite of unite

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
# 2.6 - Stringr
#==============================================================================


upcList <- x <- c("0038000673009", 
  "038000321108", 
  "038000310102", 
  "038000596445", 
  "038000001109", 
  "38000111792", 
  "038000391187", 
  "038000327476", 
  "0038000301100", 
  "38000094562"
)

str_length(upcList) 

str_detect(upcList, "4")   # Returns vector all strings with "4" marked as TRUE
str_detect(upcList, "44")   # Returns vector all strings with "44" marked as TRUE

str_count(upcList, "4")    # Returns vector all strings with the count of "4"'s in each string
str_subset(upcList, "4")   # Returns vector strings with at least 1 "4"'
str_locate(upcList, "4")   # Returns position of the matches

str_extract(upcList, "4")
str_match(upcList, "4")
str_match(upcList, "44")

str_pad("38000094569", 12, side = "left", pad="0")  # Adds 0 to left side to make length 12
str_trim(" 38000094569 ") # Removes outside white spaces
str_trunc("0038000094569", 12, side = "left", "") # Truncates to length 12 truncating left side


# Converting all UPCs to same length string

upc_df <- as_tibble(upcList) %>% rename(UPC = value)

str_length(upc_df$UPC) 

upc_df %>% 
  mutate(UPC_Fixed = case_when(
    str_length(UPC) > 12 ~ str_trunc(UPC, 12, side = "left", ""),
    str_length(UPC) == 12 ~ UPC,
    str_length(UPC) < 12 ~ str_pad(UPC, 12, side = "left", pad="0")
  )) 