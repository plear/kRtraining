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

hMean(5,6)

hMean <- function(x,y,z=0) {
  if(z==0){(2 * (x * y))/ (x + y)}
  else {(3 * (x * y * z))/ (x*y + x*z + y*z)}
}

hMean(5,6)
hMean(5,6,8)


#   Purr
