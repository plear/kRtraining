### Programming ################################################################

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

!(y == y)

!x

x & y
x && y

x | y
x || y

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


### Conditional Logic ##########################################################
x <- 1
y <- 0
z <- 1

if(x == z) {
  print("x is equal to z")
}

z <- 2

if(x == z) {
  print("x is equal to z")
} else {
  print("x is NOT equal to z")
}

value <- 0

if(x == z) {
  value <- value + 1
} else {
  value <- value + 0
}

value

z <- x

if(x == z) {
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
x.equals.y(1,1.1)


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

hMean(10,50)
hMean(10,50,25)

### Apply Functions ############################################################

# apply: data frame/matrix -> vector/list/array
m1 <- matrix(C<-(1:100),nrow=10, ncol=10)

sum_col_m1 <- apply(m1, 2, sum)
sum_col_m1

str(sum_col_m1)

# sapply: list/vector/data frame -> vector/matrix    WARNING: sapply is not always consistent
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


### More Purrr ###############################################################

map_dbl(diamonds, n_distinct)

diamonds %>%
  map_dbl(n_distinct)


diamondsByCut <- diamonds %>% 
  group_by(cut) %>% 
  nest()

diamondsByCut

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

