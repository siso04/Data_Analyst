# US Income and Education dataset

# Libraries

library(tidyverse)
library(lessR)
library(dlookr)
library(readr)
library(skimr)
library(psych)
library(funModeling)
library(Hmisc)

# Set working directory


# Load data

income <- read.csv('us_counties_income_education.csv')
income %>% head()
income %>% names()

# Data overview

income %>% str()
summary(income)
glimpse(income)
describe.by(income)

# Numerical variables
profiling_num(income)
income %>% correlate()

# 1. Change the name of the variables with BaseR

colnames(income) <- c("county_FIPS", "state", "county",
                      "income_2019", 
                      "income_2020", 
                      "income_2021", 
                      "associate_degree_numbers", 
                      "bachelor_degree_numbers", 
                      "associate_degree_percentage", 
                      "bachelor_degree_percentage")

income %>% names()

# 2. Visualizing data

# Income distribution with histograms
Histogram(data = income, income_2019, main = "Income distribution 2019", fill="yellowgreen")
Histogram(data = income, income_2020, main = "Income distribution 2020", fill="palevioletred3")
Histogram(data = income, income_2021, main = "Income distribution 2021", fill="purple3")

# We can create just one plot with the three histograms
# Set up 1 row and 3 columns of plots
par(mfrow=c(1, 3))

# Plot histograms for each year
hist(income$income_2019, main="Income distribution 2019", col="red")
hist(income$income_2020, main="Income distribution 2020", col="green")
hist(income$income_2021, main="Income distribution 2021", col="blue")

# Add a main title
title("Income distribution 2019-2021", font.main=4, outer=T)

# We can check for outliers using boxplots
boxplot(income$income_2019, main="Income outliers 2019", col='blue')
boxplot(income$income_2020, main="Income outliers 2020", col='green')
boxplot(income$income_2021, main="Income outliers 2021", col='pink')

# We can visualize relationships with scatterplots
par(mfrow=c(1, 1))
Plot(data = income, income_2019, associate_degree_numbers, color='navy')
Plot(data = income, income_2020, bachelor_degree_numbers, fill = 'red')

# 3. Delete strings in the column "county" with str_replace()
# We should delete the state name from this column
income$county <- str_replace(income$county, ",.*", "")
income$county 

# 4. Analizing numerical variables

diagnose_numeric(income)

# Correlation between variables
correlate(income)
plot_correlate(income)

# Checking for outliers
diagnose_outlier(income)

# We can imputate outliers, but we have to do this for each variable
# Here is an example
imputate_2019 <- imputate_outlier(income, income_2019, method = "capping")
imputate_2019

# We have the outliers position, and we can search them in out dataset
income[c(1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14, 16, 18, 19, 20, 22, 23, 25, 26, 28, 29,
         31, 33, 35, 36, 37, 39, 43, 45, 47, 49, 51, 52, 53, 54, 56, 57, 59, 60, 61, 62, 64, 65, 66,
         69, 71, 75, 77, 79, 80, 84, 85, 91, 96, 101, 103, 105, 108, 110, 111, 115, 119, 123, 133, 134,
         150, 158, 159, 165, 170, 192, 195, 197, 201, 205, 216, 223, 228, 238, 239, 241, 251, 252, 267,
         280, 298, 299, 321, 333, 337, 341, 373, 404, 444, 461, 521, 532, 546, 655, 680, 695, 735, 786,
         814, 849, 851, 890, 963, 1030, 1044, 1166, 1269, 1299), ] %>% select(county_FIPS:income_2019)

# We can compare the data with and without outliers
summary(imputate_2019)

# And plot
plot(imputate_2019)

# 5. Calculate the mean and median income for each county (state) over the three years, 
# and rank the counties based on these values

income_mean_median <- income %>%
  group_by(county, state) %>%
  summarise(mean_income = mean(c(income_2019, income_2020, income_2021), na.rm = TRUE),
            median_income = median(c(income_2019, income_2020, income_2021), na.rm = TRUE))

income_mean_median %>% arrange(desc(median_income)) %>% head(20)

