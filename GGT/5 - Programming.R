### Programming ################################################################
library(tidyverse)

### Logic ######################################################################
x <- TRUE
y <- FALSE

x == x
x == y
y == x
y == y

x != x
x != y
y != x
y != y

!x

!(y == y)

# And
x & y   
x && y  

# Or
x | y
x || y

# Exclusive Or
xor(x, y)
xor(x, x)

isTRUE (x)
isFALSE(x)

a = 5
b = -5

a == b
a != b
a < b
a > b

"WORD" == "WORD"
"WORD" == "word"

### Conditional Logic ##########################################################
x <- 1
y <- 1

if(x == y) {
  print("x is equal to y")
}

y <- 2

if(x == y) {
  print("x is equal to y")
}

if(x == y) {
  print("x is equal to y")
} else {
  print("x is NOT equal to y")
}

value <- 0

y <- x + 1

if(x == y) {
  value <- value + 1
} else {
  value <- value + 0
}

value

y <- x

if(x == y) {
  value <- value + 1
} else {
  value <- value + 0
}

value


### Functions ##################################################################
x.equals.y <- function(x,y){
  if(x == y) {
    print("x is equal to z")
  } else {
    print("x is NOT equal to z")
  }
}

x.equals.y

x.equals.y(1,1)
x.equals.y(1,1.01)

# Harmonic Mean of 10 & 50
(2 * (10 * 50))/ (10 + 50) 

hMean <- function(x,y) {
  (2 * (x * y))/ (x + y) 
}

hMean

hMean(10,50)
hMean(8,52)


hMean <- function(x,y,z=0) {
  if(z==0){(2 * (x * y))/ (x + y)}
  else {(3 * (x * y * z))/ (x*y + x*z + y*z)}
}

hMean

hMean(10,50)
hMean(10,50,25)

### Loops ######################################################################

# For Loops
sequence <- 1:10

for (val in sequence)
{
  print(val)
}

sequence <- 1:10 %% 2

for (val in sequence)
{
  print(val)
}


# While Loops
i <- 1
while (i < 6) {
  print(i)
  i <- i + 1
}


# While Loops with Break
i <- 1
while (i < 6) {
  print(i)
  i <- i + 1
  if (i == 4) {
    break
  }
}


# While Loops with If and Next  
i <- 0
while (i < 6) {
  i <- i + 1
  if (i == 3) {
    next
  }
  print(i)
}


# Fizzbuzz Test
for (i in 1:50) {
  if (i %% 3 == 0 && i %% 5 == 0) {
    print("FizzBuzz")
  } else if (i %% 3 == 0) {
    print("Fizz")
  } else if (i %% 5 == 0) {
    print("Buzz")
  } else {
    print(i)
  }
}

### Apply Functions ############################################################

# apply: data frame/matrix -> vector/list/array
m1 <- matrix(C<-(1:100),nrow=10, ncol=10)

sum_col_m1 <- apply(m1, 2, sum)
sum_col_m1

str(sum_col_m1)

# sapply: list/vector/data frame -> vector/matrix    WARNING: sapply is not always consistent in output class
strings <- c("Frosted Flakes","FROSTED FLAKES","rice krispies","Rice Krispies")
table(strings)

strings_lower <-sapply(strings, tolower)
table(strings_lower)

set.seed(123)
# lapply: list/vector/data frame -> list
price_samples <- list(sample_frac(diamonds, .8)$price,
                    sample_frac(diamonds, .8)$price,
                    sample_frac(diamonds, .8)$price,
                    sample_frac(diamonds, .8)$price,
                    sample_frac(diamonds, .8)$price)

str(price_samples)
price_samples

price_means <-lapply(price_samples, mean)
price_sd <-lapply(price_samples, sd)

price_means
price_sd


# tapply: factored jagged vector -> vector/matrix
tapply(diamonds$price, diamonds$cut, mean)


### Purrr ######################################################################

# map(.x, .f) returns a list
map(.x = price_samples, 
  .f = mean)

map(price_samples, mean)

# map_dbl(.x, .f) returns a numeric (double) vector
map_dbl(price_samples, mean)

# map_chr(.x, .f) returns a character vector
map_chr(price_samples, mean)

# map_lgl(.x, .f) returns a logical vector
# tilde-dot shorthand for functions  ~{f(.x)}
map_lgl(price_samples, ~{mean(.x) < mean(diamonds$price)})

set.seed(321)
# map_df(.x, .f) returns a data frame
price_samples2 <- list(s10 = sample_frac(diamonds, .1)$price,
                      s10_2 = sample_frac(diamonds, .1)$price,
                      s20 = sample_frac(diamonds, .2)$price,
                      s20_2 = sample_frac(diamonds, .2)$price,
                      s30 = sample_frac(diamonds, .3)$price,
                      s30_2 = sample_frac(diamonds, .3)$price,
                      s40 = sample_frac(diamonds, .4)$price,
                      s40_2 = sample_frac(diamonds, .4)$price,
                      s50 = sample_frac(diamonds, .5)$price,
                      s50_2 = sample_frac(diamonds, .5)$price,
                      s60 = sample_frac(diamonds, .6)$price,
                      s60_2 = sample_frac(diamonds, .6)$price,
                      s70 = sample_frac(diamonds, .7)$price,
                      s70_2 = sample_frac(diamonds, .7)$price,
                      s80 = sample_frac(diamonds, .8)$price,
                      s80_2 = sample_frac(diamonds, .8)$price,
                      s90 = sample_frac(diamonds, .9)$price,
                      s90_2 = sample_frac(diamonds, .9)$price)

map_df(price_samples2, mean) %>% 
  pivot_longer(cols = 1:18, names_to = "Sample", values_to = "Mean") %>% 
  ggplot(aes(x=Sample, y=Mean)) +
  geom_bar(stat="Identity")+
  geom_hline(yintercept=mean(diamonds$price), linetype="dashed", color="red")


### More Purrr #################################################################

# Standard form
map_dbl(diamonds, n_distinct)

# Piped form
diamonds %>%
  map_dbl(n_distinct)

# Using purrr to create class specific models
diamondsByCut <- diamonds %>% 
  group_by(cut) %>% 
  nest()

diamondsByCut
str(diamondsByCut)


diamondColor_model <- function(df) {
  lm(price ~ carat + table, data = df)
}

models <- map(diamondsByCut$data, diamondColor_model)
models

diamondsByCut <- diamondsByCut %>% 
  mutate(model = map(data, diamondColor_model))

diamondsByCut %>% 
  mutate(glance = map(model, broom::glance)) %>% 
  unnest(glance)







