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


#   Functions




#   Purr
