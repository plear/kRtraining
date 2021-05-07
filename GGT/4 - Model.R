### Model ######################################################################
library(tidyverse)

# install.packages("broom")
# install.packages("rpart")
library(broom)
library(rpart)

diamonds %>% glimpse()

### Basic Statistics ###########################################################
summary(diamonds)
summary(diamonds$price)  # Five number summary with mean
summary(diamonds$color)  # Class counts

fivenum(diamonds$price)  # Five number summary

mean(diamonds$price)

ggplot(diamonds, aes(x=price)) + geom_boxplot()

tTestData <- diamonds %>% filter(cut %in% c("Ideal", "Premium"))

summary(tTestData$cut)
summary(tTestData$price)

fivenum((tTestData %>% filter(cut == "Premium"))$price)
fivenum((tTestData %>% filter(cut == "Ideal"))$price)

# Means testing
mean((tTestData %>% filter(cut == "Premium"))$price)
mean((tTestData %>% filter(cut == "Ideal"))$price)

sd((tTestData %>% filter(cut == "Premium"))$price)
sd((tTestData %>% filter(cut == "Ideal"))$price)

tTestData %>% 
  ggplot(aes(x=price, color=cut)) + 
  geom_density() +
  geom_vline(xintercept=mean((tTestData %>% filter(cut == "Premium"))$price),
    linetype="dashed", color = "purple") +
  geom_vline(xintercept=mean((tTestData %>% filter(cut == "Ideal"))$price),
    linetype="dashed", color = "yellow")

tTestData %>% 
  ggplot(aes(x=price, color=cut)) + 
  geom_boxplot()

t.test(tTestData$price~tTestData$cut)
t.test(tTestData$price~tTestData$cut,  alternative="less")

# Generating random values
set.seed(77)
normalDist5 <- as_tibble(rnorm(5, m=50, sd=10))
normalDist50 <- as_tibble(rnorm(50, m=50, sd=10))
normalDist500 <- as_tibble(rnorm(500, m=50, sd=10))
normalDist5000 <- as_tibble(rnorm(5000, m=50, sd=10))

mean(normalDist5$value)
sd(normalDist5$value)

mean(normalDist5000$value)
sd(normalDist5000$value)

ggplot() + 
  geom_density(data=normalDist5, aes(x=value), color="red") +
  geom_density(data=normalDist50, aes(x=value), color="blue") +
  geom_density(data=normalDist500, aes(x=value), color="green") +
  geom_density(data=normalDist5000, aes(x=value), color="black") +
  geom_vline(xintercept=50, linetype="dashed", color = "purple") +  # Mean
  geom_vline(xintercept=30, linetype="dotted", color = "purple") +  # Sd-2
  geom_vline(xintercept=70, linetype="dotted", color = "purple")    # Sd+2

### Linear Regression ##########################################################
model1 <- lm(price~carat, diamonds)
model1

newdata <- tribble(
  ~carat ,
  1,
  0.1
  )

predict(model1, newdata)

diamonds %>% 
  ggplot(aes(x=carat, y=price)) + 
  geom_point() + 
  geom_smooth(method="lm", formula = y ~ x)

# Broom package
tidy(model1)
glance(model1)
augment(model1)

augment(model1) %>%
  ggplot(aes(x=.resid)) + 
  geom_density()

augment(model1, diamonds)

augment(model1, diamonds) %>%
  ggplot(aes(x=.resid, color=cut)) + 
  geom_density()

model2 <- lm(price ~ 0 + carat + cut, diamonds)
model2

tidy(model2)
tidy(model1)

glance(model2)
augment(model2)

augment(model2) %>%
  ggplot(aes(x=.resid)) + 
  geom_density()

augment(model2, diamonds) %>%
  ggplot(aes(x=.resid, color=cut)) + 
  geom_density()

model3 <- lm(price ~ 0 + carat + cut + carat*cut, diamonds)

tidy(model3)
glance(model3)
augment(model3)

augment(model3, diamonds) %>%
  ggplot(aes(x=.resid)) + 
  geom_density()

model4 <- lm(log(price) ~ 0 + carat + cut, diamonds)
tidy(model4)

augment(model4, diamonds) %>%
  ggplot(aes(x=.resid)) + 
  geom_density()

model5 <- lm(log(price) ~ 0 + log(carat) + cut, diamonds)
tidy(model5)

augment(model5, diamonds) %>%
  ggplot(aes(x=.resid)) + 
  geom_density()

model6 <- lm(price ~ ., diamonds)
tidy(model6)

augment(model6, diamonds) %>%
  ggplot(aes(x=.resid)) + 
  geom_density()

bind_rows(glance(model1),
          glance(model2),
          glance(model3),
          glance(model4),
          glance(model5),
          glance(model6))


# Subset train/test 70/30 split
trainDiamonds <- sample_frac(diamonds, 0.7)
testDiamonds <- diamonds %>% anti_join(testDiamonds)

model5Train <- lm(log(price) ~ 0 + log(carat) + cut, trainDiamonds)

bind_rows(glance(model5),
  glance(model5Train))

bind_cols(testDiamonds,as_tibble(predict(model5Train, testDiamonds))) %>%
  mutate(forecastPrice = exp(value), diff = price - forecastPrice) %>% 
  ggplot(aes(x=price, y=diff)) + 
  geom_point()


### Classification Tree ########################################################
fit1 <- rpart(cut ~ x + y + z + table,
  method="class", data=diamonds)

printcp(fit1) # display the results
plotcp(fit1) # visualize cross-validation results
summary(fit1) # detailed summary of splits

# plot tree
plot(fit1, uniform=TRUE,
  main="Classification Tree for Diamond cut")
text(fit1, use.n=TRUE, all=TRUE, cex=.6)

### Regression Tree ########################################################
fit2 <- rpart(price ~ carat + cut + color + clarity,
  method="anova", data=diamonds)

printcp(fit2) # display the results
plotcp(fit2) # visualize cross-validation results
summary(fit2) # detailed summary of splits

# plot tree
plot(fit2, uniform=TRUE,
  main="Regression Tree for Diamond Price")
text(fit2, use.n=TRUE, all=TRUE, cex=.6)


### K Nearest Neighbors ########################################################
set.seed(777)

# Two dimensional example
diamonds2d <- diamonds %>% 
  select(x, y)

k2d <- kmeans(diamonds2d, 5, nstart = 25)
k2d

example2d <- bind_cols(diamonds, cluster = k2d$cluster)

ggplot(example2d, aes(x=x, y=y, color=cluster)) +
    geom_point()

ggplot(example2d, aes(x=x, y=y, color=factor(cluster))) +
  geom_point() +
  scale_y_continuous(limits = c(0, 10)) +
  scale_x_continuous(limits = c(3, 10))

diamondsDims <- diamonds %>% 
  select(x, y, z, table)

kCut <- kmeans(diamondsDims, 5, nstart = 25)
kCut

exampleDims <- bind_cols(diamondsDims, cluster = kCut$cluster)

ggplot(exampleDims, aes(x=x, y=y, color=z, size=table)) +
  geom_point(alpha=0.25)

ggplot(exampleDims, aes(x=x, y=y, color=z, size=table, shape=factor(cluster))) +
  geom_point(alpha=0.25) +
  scale_y_continuous(limits = c(2.5, 10)) +
  scale_x_continuous(limits = c(3, 10))


# Dimension Reduction For a Linear Model
diamondsSegmentation <- diamonds %>% 
  select(-x, -y, -z, -table)

model7 <- lm(price ~ ., diamondsSegmentation)
tidy(model7)

bind_rows(
  glance(model1),
  glance(model2),
  glance(model3),
  glance(model4),
  glance(model5),
  glance(model6),
  glance(model7))


