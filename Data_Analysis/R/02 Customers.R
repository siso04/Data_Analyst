# Analysis customers dataset

# Set working directory


# Libraries
library(readr)
library(tidyverse)
library(lessR)
library(dlookr)
library(skimr)
library(funModeling)

# Read data file
customers <- read.csv("Mall_Customers.csv")
customers %>% head(10)

# 1. Data overview
customers %>% names()
customers %>% str()
diagnose(customers)
plot_num(customers)
sum(is.na(customers))
which(duplicated(customers))

# We can rename the columns before the analysis
colnames(customers) <- c("ID", "genre", "age", "income", "score")

# The column ID is not pretty useful, so we can delete it
customers <- customers %>% select(-ID)

# 2. Data analysis

# 2.1 Count total of male and female
customers %>% count(genre) 

# Let's calculate the percentage
customers %>% count(genre) %>% 
  mutate(percentage = n/sum(n)*100)

# Plot a barchart
BarChart(data = customers, genre, sort = "-", 
         fill = "lightblue", values_color = "Black", values_size = 2,
         ylab = "Count")

# 2.2 Calculate the correlation
correlate(customers)
plot_correlate(customers)

# 2.3 We can plot the customers by age
BarChart(data = customers, age, horiz = TRUE, fill="gray", sort = "-")

# 2.4 Calculate the max, min and mean by genre
customers %>% group_by(genre) %>% 
  filter(income >= 100) %>% 
  summarise(max=max(income), 
            min=min(income), 
            mean=mean(income))

# 2.5 Relation between age and income
ggplot(data = customers, aes(age, income)) + 
  geom_point(color="red") + 
  theme_bw()

# 2.6 A quick and simple cluster analysis

# Select the variables for the cluster analysis
cluster_vars <- customers %>% select(age, income, score)

# Normalize the variables
cluster_vars_norm <- scale(cluster_vars)

# Choose the number of clusters (k)
k <- 3

# Perform k-means clustering
set.seed(123) # for reproducibility
cluster_results <- kmeans(cluster_vars_norm, k)

# View the cluster assignments
cluster_assignments <- cluster_results$cluster
cluster_assignments

# Plot the clusters
ggplot(cluster_vars, aes(x = income, y = score, 
                         color = factor(cluster_assignments))) +
  geom_point() +
  labs(x = "Income", y = "Score", color = "Cluster") +
  theme_bw()
