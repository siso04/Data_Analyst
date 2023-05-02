# TED Talks Data Analysis


# Libraries

library(tidyverse)
library(lessR)
library(tidytext)
library(jsonlite)
library(forcats)
library(readr)
library(skimr)
library(psych)
library(Hmisc)
library(funModeling)

# Read file
ted <- read.csv("ted_main.csv")
ted

# Checking data
ted %>% names()
ted %>% dim()
str(ted)
glimpse(ted)
ted %>% skim_without_charts()
unique(ted$event)
sum(is.na(ted$ratings))

# 1. What talks provoke the most online discussion?

ted %>% select(comments, views) %>% arrange(desc(comments)) %>% head(20)
ted %>% select(comments, views) %>% arrange(desc(views)) %>% head(20)

# Let's create a new column called comments_per_view
ted$comments_per_view <- ted$comments / ted$views
ted$comments_per_view %>% sort(decreasing = TRUE)
ted %>% arrange(desc(comments_per_view)) %>%  head(10)

# The most commented Ted talk in the data
ted %>% filter(main_speaker == "Diane J. Savino") %>% select(description)

# But for an easier interpretation, let's create another variable called: views_per_comment
ted$views_per_comment <- ted$views/ted$comments
ted %>% arrange(views_per_comment) %>% 
  head(10) %>% 
  select(name, main_speaker, views_per_comment)

# Let's create a line plot with the variables: "views" and "comments"
ggplot(data = ted, aes(x=views, y=comments)) + 
  geom_line(color='red')+
  labs(title = "Relation between views and comments",
       x='Views',
       y='Comments')

# We can also watch this in a Histogram
Histogram(data=ted, x=comments, fill='blue')

# Now we can focus only in talks we comments under <1500
ggplot(data = subset(ted, comments <1500), 
       aes(x=comments, fill='red')) +
  geom_histogram(binwidth = 100, color='white') +
  theme_minimal() + theme(legend.position = 'none')

# 2. Plot the number of talks that take place each year

unique(ted$event)
BarChart(data = ted, event, sort = "-", limit=10) 

ggplot(subset(ted, event %in% names(sort(table(event), decreasing = TRUE)[1:10])), aes(x = event)) +
  geom_bar(fill = "blue") +
  labs(title = "Top 10 TED Events by Frequency", x = "Event", y = "Frequency") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

# Trasnforming the data of the film_date column

# Installing the package anytime
install.packages("anytime")
library(anytime)

# Checking the type of data of the column "film_date"
ted$film_date
class(ted$film_date)
sum(is.na(ted$film_date))

# Transforming the data to POSIXct format 
ted$film_date <- anytime(ted$film_date)
ted$film_date

# Now we can convert the POSIXct column to a character string with "YYYY-MM-DD" format
ted$film_date <- format(ted$film_date, "%Y-%m-%d")
ted$film_date

# We can now extract only the string with the year
ted_year <- substr(ted$film_date, 1, 4)
ted_year

# Plot the amount of talks by year
BarChart(data = ted, ted_year, sort = "-", 
         horiz = TRUE, 
         fill = "slateblue3",
         main="Talks by year",
         xlab = "Year",
         ylab = "Total by year")

# 3. What were the best events in TED history to attend?

count(ted$event)

library(dplyr)
ted %>%
  count(event) %>% arrange(desc(n)) %>% head(20)

# A better approximation could be, use agregation function to count and sum 
# the numbers of talks and the number of views
ted %>%
  group_by(event) %>%
  summarise(count = n(), mean = mean(views), sum = sum(views)) %>%
  arrange(desc(sum))


