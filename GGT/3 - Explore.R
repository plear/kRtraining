### 1 - Data Wrangling 1 ######################################################
library(tidyverse)

# See what data is loaded into the environment
data() 

glimpse(diamonds)

### ggplot Basic Structure ##################################################### 
# Assing data to the plot
ggplot(data=diamonds)

# Map aesthetics to the plot
ggplot(data=diamonds, aes(x=carat, y=price))

# Add geometric object
ggplot(data=diamonds, aes(x=carat, y=price)) +
  geom_point()

ggplot(data=diamonds) +
  geom_point(aes(x=carat, y=price))

# Add third variable as a color
ggplot(data=diamonds, aes(x=carat, y=price, color=cut)) +
  geom_point()

ggplot(data=diamonds, aes(x=carat, y=price, shape=cut, color=carat)) +
  geom_point()

# Color outside aesthetics
ggplot(data=diamonds, aes(x=carat, y=price)) +
  geom_point(color="red")

# Add third variable as a shape
ggplot(data=diamonds, aes(x=carat, y=price, shape=cut)) +
  geom_point()

# Alpha
ggplot(data=diamonds, aes(x=carat, y=price, alpha=cut)) +
  geom_point()

ggplot(data=diamonds, aes(x=carat, y=price, color=cut)) +
  geom_point(alpha=0.25)

### One variable geoms with continuous variables ###############################
# View distribution with geom_density
ggplot(data=diamonds, aes(x=price)) +
  geom_density()

# View distribution with geom_density + color for class variable
ggplot(data=diamonds, aes(x=price, color=cut)) +
  geom_density()

# Fill instead of color
ggplot(data=diamonds, aes(x=price, fill=cut)) +
  geom_density()

# Binned distribution
ggplot(data=diamonds, aes(x=price)) +
  geom_histogram()

ggplot(data=diamonds, aes(x=price)) +
  geom_histogram(bins = 10)

ggplot(data=diamonds, aes(x=price)) +
  geom_histogram(binwidth =  2500)

### One variable geoms with discrete variables ################################# 

# This works but there's a better way
ggplot(data=diamonds, aes(x=cut)) +
  geom_histogram(stat="count")         

ggplot(data=diamonds, aes(x=cut)) +
  geom_bar()         

# Advanced geom_bar
# Side by side 
ggplot(data=diamonds, aes(x=cut, y=price, fill=color)) +
  geom_bar(position="dodge", stat="identity")

# Stacked
ggplot(data=diamonds, aes(x=cut, y=price, fill=color)) +
  geom_bar(position="stack", stat="identity")

ggplot(data=diamonds, aes(x=cut, y=price, color=color)) +
  geom_bar(position="stack", stat="identity")

### Two variable geoms with one continuous + one discrete ########################### 
ggplot(data=diamonds, aes(x=color, y=price)) +
  geom_boxplot()

ggplot(data=diamonds, aes(x=color, y=price)) +
  geom_violin()

ggplot(data=diamonds, aes(x=color, y=price, color=cut )) +
  geom_violin()


# More bar charts
ggplot(data=diamonds, aes(x=color, y=price)) +
  geom_col()

ggplot(data=diamonds, aes(x=color, y=price, fill=cut)) +
  geom_col()

ggplot(data=diamonds, aes(x=color, y=price, color=cut)) +
  geom_col()


### Two variable geoms with two continuous variables ########################### 
ggplot(data=diamonds %>% filter(cut == "Very Good"), aes(x=carat, y=price)) +
  geom_point()

diamondsRoundedCut <- diamonds %>% mutate(carat = round(carat, 0))

ggplot(data=diamondsRoundedCut %>% filter(cut == "Very Good"), aes(x=carat, y=price)) +
  geom_point()

ggplot(data=diamondsRoundedCut %>% filter(cut == "Very Good"), aes(x=carat, y=price)) +
  geom_jitter()

ggplot(data=diamonds %>% filter(cut == "Very Good"), aes(x=carat, y=price)) +
  geom_line()

ggplot(data=diamonds %>% filter(cut == "Very Good"), aes(x=carat, y=price)) +
  geom_smooth()

ggplot(data=diamonds %>% filter(cut == "Very Good"), aes(x=carat, y=price)) +
  geom_smooth(method = lm)

ggplot(data=diamonds %>% filter(cut == "Very Good"), aes(x=carat, y=price)) +
  geom_point() +
  geom_smooth(method = lm)

ggplot(data=diamonds, aes(x=carat, y=price, color = cut)) +
  geom_point() +
  geom_smooth(method = lm)

ggplot(data=diamonds, aes(x=carat, y=price, color = cut)) +
  geom_rug()

ggplot(data=diamonds, aes(x=carat, y=price, color = cut)) +
  geom_point() +
  geom_smooth() +
  geom_rug()

### Faceting ###########################
ggplot(data=diamonds, aes(x=price, color=cut)) +
  geom_density()

ggplot(data=diamonds, aes(x=price)) +
  geom_density() + 
  facet_grid(cols = vars(cut))

ggplot(data=diamonds, aes(x=price)) +
  geom_density() + 
  facet_grid(rows = vars(cut))

ggplot(data=diamonds, aes(x=price)) +
  geom_density() + 
  facet_grid(rows = vars(color), cols = vars(clarity))

ggplot(data=diamonds, aes(x=price, fill=cut)) +
  geom_density() + 
  facet_grid(rows = vars(color), cols = vars(clarity))

ggplot(data=diamonds, aes(x=price, y=depth, fill=cut)) +
  geom_point() + 
  facet_grid(rows = vars(color), cols = vars(clarity)) +
  geom_smooth()

ggplot(data=diamonds, aes(x=price, fill=cut)) +
  geom_density() +   
  facet_wrap(vars(clarity))


### Labeling ###########################
economics %>% glimpse()

plot1 <- ggplot(economics, aes(x=date, y=uempmed)) +
  geom_line()

plot1 +
  labs(title="Unemployment Rate Trend",
    x ="Date", y = "Unemployment Rate")

plot1 +
  labs(title="Unemployment Rate Trend",
    x ="Date", y = "Unemployment Rate")

plot2 <- ggplot(economics, aes(x=date, y=uempmed, color=psavert)) +
  geom_line()

plot2 +
  labs(title="Unemployment Rate Trend",
    x ="Date", y = "Unemployment Rate", color="Personal Savings Rate")

plot2 +
  labs(title="Unemployment Rate Trend",
    x ="Date", y = "Unemployment Rate", color="Personal Savings Rate") + 
  theme(legend.position="bottom")

plot2 +
  labs(title="Unemployment Rate Trend",
    x ="Date", y = "Unemployment Rate", color="Personal Savings Rate") + 
  theme(legend.position="bottom") +
  scale_color_gradient(low="red", high="green")

plot2 +
  labs(title="Unemployment Rate Trend",
    x ="Date", y = "Unemployment Rate", color="Personal Savings Rate") + 
  theme(legend.position="bottom") +
  scale_color_gradient2(low="red", high="green", mid = "yellow", midpoint = mean(economics$psavert)) 


plot3 <- plot2 +
  labs(title="Unemployment Rate Trend",
    x ="Date", y = "Unemployment Rate", color="Personal Savings Rate") + 
  theme(legend.position="bottom") +
  scale_color_gradient2(low="red", high="green", mid = "yellow", midpoint = mean(economics$psavert)) 


### Scales #####################################################################

plot3 +
  scale_x_date(date_labels = "%Y (%b)")

plot4 <- ggplot(economics, aes(x=uempmed, y=psavert)) +
  geom_point()  +
  geom_smooth(method="lm")

plot4

plot4 +
  scale_x_sqrt()

plot4 + 
  scale_x_log10()

plot4 + 
  scale_x_log10() +
  scale_y_continuous(limits = c(0, 20))

plot4 + 
  scale_y_continuous(
  breaks = c(5, 10, 15), label = c("Some", "A Little", "A Lot")
  )



### Exploratory data analysis with ggplot ######################################
# Example with real world data 

gMob <- read_csv("data/Google Mobility - State - Daily.csv")

glimpse(gMob)

gMob2 <- gMob %>% 
  mutate(date = lubridate::mdy(paste(month, day,year, "-")))

ggplot(data=gMob2, aes(x=date, y=gps_workplaces)) +
  geom_point() +
  geom_smooth()


ggplot(data=gMob2, aes(x=date, y=gps_workplaces, color=factor(statefips))) +
  geom_point(alpha=0.25) +
  geom_smooth(alpha=0.75, se=FALSE) +
  theme(legend.position="none")

ggplot(data=gMob2, aes(x=factor(lubridate::quarter(date, with_year = TRUE)), y=gps_workplaces)) +
  geom_boxplot()

ggplot(data=gMob2, aes(x=factor(lubridate::quarter(date, with_year = TRUE)), y=gps_workplaces)) +
  geom_boxplot() +
  geom_violin(alpha=0.5)

ggplot(data=gMob2) +
  geom_boxplot(aes(x=factor(lubridate::quarter(date, with_year = TRUE)), y=gps_workplaces), color="blue") +
  geom_boxplot(aes(x=factor(lubridate::quarter(date, with_year = TRUE)), y=gps_grocery_and_pharmacy), color="red")

ggplot(data=gMob2) +
  geom_point(aes(x=date, y=gps_workplaces), color="blue", alpha=.5) +
  geom_point(aes(x=date, y=gps_grocery_and_pharmacy), color="red", alpha=.5)





