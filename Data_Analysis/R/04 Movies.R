# Analysis movies dataset
rm(list = ls())
# Set working directory


# Libraries
library(tidyverse)
library(lessR)
library(dlookr)
library(skimr)
library(funModeling)
library(readr)

# Read the data file
movies <- read.csv("movies.csv")
movies

# Data overview
movies %>% names()
movies %>% str()

# 1. Cleaning and wrangling data

# 1.1 Delete the column index, it is unnecessary
movies <- movies %>% select(-index)
movies %>% head(10) 

# 1.2 Transform the data type of the column "votes"
# This column appears as character, and should be numeric.
# We have to delete the commas with "gsub" and convert to numbers with "as.numeric"
movies$votes <- as.numeric(gsub(",", "", movies$votes))
movies$votes

# 1.3 Fix the column gross_total
# This column appears as characters and should be numeric

# First we need to delete the dollar symbol "$" and the letter "M"
# and after that, convert the column to numeric
movies$gross_total <- movies$gross_total %>% str_replace("\\$", "") %>% 
  str_replace("M", "") %>% as.numeric()

# 1.4 Fix the column "run_time"
# We should delete the word "min" and convert the column to numeric
movies$run_time <- movies$run_time %>% str_replace(" min", "") %>% as.numeric()

# 1.5 Fix the column "year_of_release"
# In this column we are going to delete the parenthesis, it's not necessary to transform it
# to numeric
# We are going to use str_replace_all, to delete the two parenthesis in the same operation
movies$year_of_release <- movies$year_of_release %>% 
  str_replace_all("\\(|\\)", "") 

# We can check the data types again
movies %>% str()

# -----------------------------------

# 2. Data analysis

# 2.1 Data description
describe(movies)
diagnose(movies)
diagnose_numeric(movies)
diagnose_category(movies)
plot_num(movies)

# 2.2 Data Correlation
correlate(movies)
plot_correlate(movies)

# 2.3 Top ten movies by rating
movies %>% arrange(desc(imdb_rating )) %>% 
  head(10) %>% 
  select(movie_name, year_of_release, imdb_rating)

# 2.4 Top ten movies by total collection
movies %>% arrange(desc(gross_total)) %>% head(10) %>% 
  select(movie_name, year_of_release, imdb_rating, gross_total)

# 2.5 Relation between rating and total collection
Plot(data = movies, imdb_rating, gross_total, fill="red", color="red",
     xlab = "Rating", ylab = "Total collection")

# 2.6 Relation between rating and run time

ggplot(data = movies, aes(x=imdb_rating, y=run_time)) + 
  geom_point( color = "red") + 
  labs(title = "Movies rating and runtime",
       x="Rating", y="Run time") +
  theme_bw()

# 2.7 Movies by category
BarChart(data = movies, category, sort="-", horiz = TRUE)

# 2.8 Movies from 2000 with a rating higher than 8
movies %>% filter(year_of_release >= 2000 & imdb_rating > 8) %>% 
  arrange(desc(imdb_rating)) %>% 
  select(movie_name, year_of_release, run_time, imdb_rating)

# 2.9 Movies by genre
BarChart(data = movies, genre, sort = "-", horiz = TRUE)

# The genre movies are mixed and difficult to understand
# Let's use the function "grep" to capture only the genres that includes crime
movies[grep("Crime", movies$genre), ]
