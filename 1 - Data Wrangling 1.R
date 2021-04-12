#   Data structures and types in R
str
?str

numbers <- c(1, 1, 2, 3, 5)
class(numbers)
str(numbers)

characters <- c("One", "One", "Two", "Three", "Five")
class(characters)
str(characters)

alsoCharacters <- c("1", "1", "2", "3", "5")
str(alsoCharacters)

numLevels <- c("1", "2", "3", "5")
factors <- factor(alsoCharacters, levels = numLevels)
class(factors)
str(factors)

logical <- c(TRUE, TRUE, FALSE, FALSE, FALSE)
class(logical)
str(logical)

complex <- c(1+1i, 1+5i, 2, 3, 5)
class(complex)
str(complex)

charToRaw("This string will be converted to a raw value")

# Vector
vector1 <- c("One", "One", "Two", "Three", "Five")
vector2 <- c(1, 1, 2, 3, 5)
vector3 <- c("One", "One", 2, 3, 5)
str(vector3)  # Vectors can only handle one data type

# List
list1 <- list("One", "One", 2, 3, 5)
list1
str(list1)

Matrix # Matrices can only handle one data type
matrix1 = matrix(c(1, 1, 2, 3, 5, 10), nrow = 2, ncol = 3, byrow = TRUE)
matrix1
str(matrix1)

df <- 	data.frame(
  numbers = numbers,  # We made these vectors in the code above
  characters = characters, 
  alsoCharacters = alsoCharacters,
  logical = logical,
  factors = factors,
  complex = complex
)

df
str(df)
dplyr::glimpse(df) #dplyr function called without loading the dataspace

library(tidyverse)
glimpse(df) #dplyr function in the tidyverse package

# Dataframe vs tibble
# Import data from data folder
affinityDataFrame <- read.csv("data/Affinity - State - Daily.csv") # Base R import
affinityTibble <- read_csv("data/Affinity - State - Daily.csv") # Tidyverse import

glimpse(affinityDataFrame)  # defaults to import strings as factors
glimpse(affinityTibble) # defaults to import strings as strings

str(affinityDataFrame)
str(affinityTibble)

affinityDataFrame
affinityTibble

file.size("data/Affinity - State - Daily.csv")
object.size(affinityDataFrame)
object.size(affinityTibble)

as.numeric(object.size(affinityDataFrame)/object.size(affinityTibble))
as.numeric(file.size("data/Affinity - State - Daily.csv")/object.size(affinityTibble))

# I'm going to refer to tibbles/data frames as data frames going forward
affinity <- read_csv("data/Affinity - State - Daily.csv", 
  col_types = cols(freq = col_character(), 
    spend_acf = col_double(), spend_aer = col_double(), 
    spend_all = col_double(), spend_apg = col_double(), 
    spend_grf = col_double(), spend_hcs = col_double(), 
    spend_tws = col_double(), spend_all_inchigh = col_double(), 
    spend_all_inclow = col_double(), 
    spend_all_incmiddle = col_double(), 
    spend_retail_w_grocery = col_double(), 
    spend_retail_no_grocery = col_double()),
  na = "NA")



#   Selecting columns in df
affinity["year"] # Base R
str(affinity["year"])

affinity$year # Creates a vector
str(affinity$year)

affinity[c("year", "month")] # Base R

# Tidyverse Functions
select(affinity, year)
select(affinity, year)
select(affinity, year, month)

top_n(affinity, 5, spend_all)
top_n(affinity, -5, spend_all)

arrange(affinity, spend_all)
arrange(affinity, -spend_all)
arrange(affinity, desc(spend_all))

top_frac(affinity, .01, spend_all)
top_frac(affinity, -.01, spend_all)

sample_n(affinity, 10, replace = TRUE)
sample_frac(affinity, .10, replace = TRUE)

arrange(affinity, spend_all)

select(affinity, contains("spend")) # Select all columns contain "spend" in the name
select(affinity, starts_with("state")) # Select all columns that start with "state"
select(affinity, ends_with("grocery")) # Select all columns that end in "grocery"
select(affinity, matches(".all.")) # Matches regular expression
select(affinity, matches(".all")) # Matches regular expression
select(affinity, year:freq) # Selects all columns between and including year and freq
select(affinity, 1:4) # Selects all columns between and including 1st and 4th
select(affinity, -spend_all) # Selects all columns except spend_all
select(affinity, -c(spend_all, spend_tws)) # Selects all columns except spend_all and spend_tws

# Filtering data
filter(affinity, year == 2021)  # Equal
filter(affinity, year != 2021)  # Not equal
filter(affinity, day < 2)  # Less than
filter(affinity, day <= 2)  # Less than or equal
filter(affinity, day > 31)  # Greater than
filter(affinity, day >= 31)  # Greater than or equal

filter(affinity, year == 2021 & day >= 31) # Two conditions - and
filter(affinity, year == 2021 | day >= 31) # Two conditions - or

#   Mutate/transmute

Grocery <- mutate(affinity, grocery = spend_grf * 100)
top_n(Grocery, 5, grocery)

chartGrocery <- transmute(affinity, year, month, day, statefips, grocery = spend_grf * 100)
top_n(chartGrocery, 5, grocery)


#   Pipes
stateIDs <- read_csv("data/GeoIDs - State.csv")
MI <- filter(stateIDs, statename == "Michigan")

MI_affinity <- filter(affinity, statefips == MI$statefips)

MI_chartGrocery <- transmute(MI_affinity, year, month, day, statefips, grocery = spend_grf * 100)


MI_chartGrocery2 <- transmute(filter(affinity, statefips == filter(stateIDs, statename == "Michigan")$statefips), 
  year, month, day, statefips, grocery = spend_grf * 100)


# %>%   Create with Ctrl-Shft-M
affinity %>% 
  filter(., statefips == filter(stateIDs, statename == "Michigan")$statefips) %>% 
  transmute(., year, month, day, statefips, grocery = spend_grf * 100) %>% 
  filter(., !is.na(grocery))

affinity %>% # We don't need to reference the data parameter if we don't want to
  filter(statefips == filter(stateIDs, statename == "Michigan")$statefips) %>% 
  transmute(year, month, day, statefips, grocery = spend_grf * 100) %>% 
  filter(!is.na(grocery))

  
  



