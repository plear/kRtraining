### Model ######################################################################
library(tidyverse)
library(broom)

library(rpart)
library(tidymodels)

diamonds %>% glimpse()

### Basic Statistics ###########################################################
summary(diamonds)
summary(diamonds$price)  # Five number summary with mean
summary(diamonds$color)  # Class counts

fivenum(diamonds$price)  # Five number summary

ggplot(diamonds, aes(x=price)) + geom_boxplot()

tTestData <- diamonds %>% filter(cut %in% c("Ideal", "Premium"))

summary(tTestData$cut)
summary(tTestData$price)

mean((tTestData %>% filter(cut == "Premium"))$price)
mean((tTestData %>% filter(cut == "Ideal"))$price)

fivenum((tTestData %>% filter(cut == "Premium"))$price)
fivenum((tTestData %>% filter(cut == "Ideal"))$price)

t.test(tTestData$price~tTestData$cut)
t.test(tTestData$price~tTestData$cut,  alternative="less")

tTestData %>% ggplot(aes(x=price, color=cut)) + geom_density()
tTestData %>% ggplot(aes(x=price, color=cut)) + geom_boxplot()


### Linear Regression ##########################################################

model1 <- lm(price~carat, diamonds)
model1

diamonds %>% 
  ggplot(aes(x=carat, y=price)) + 
  geom_point() + 
  geom_smooth(method="lm")

tidy(model1)
glance(model1)
augment(model1)

augment(model1) %>%
  ggplot(aes(x=.resid)) + 
  geom_density()

augment(model1, diamonds) %>%
  ggplot(aes(x=.resid, color=cut)) + 
  geom_density()


model2 <- lm(price ~ 0 + carat + cut, diamonds)
model2

tidy(model2)
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
  ggplot(aes(x=.resid, color=cut)) + 
  geom_density()

model4 <- lm(log(price) ~ 0 + carat + cut, diamonds)
tidy(model4)

augment(model4, diamonds) %>%
  ggplot(aes(x=.resid, color=cut)) + 
  geom_density()


bind_rows(glance(model1),
          glance(model2),
          glance(model3),
          glance(model4))





### K Nearest Neighbors ########################################################
### Classification Tree ########################################################
### Modeling Frameworks (tidymodels) ###########################################
### Machine Learning ###########################################################