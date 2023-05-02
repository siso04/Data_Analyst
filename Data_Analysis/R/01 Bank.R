# Analysis bank dataset


# Libraries
library(tidyverse)
library(lessR)
library(readr)
library(dlookr)
library(skimr)
library(pysch)

# Read the data set

bank <- read.csv("bank.csv", sep = ";")
bank

# Information overview
bank %>% names()
bank %>% str()
bank %>% describe()
bank %>% diagnose()
bank %>% diagnose_category()
bank %>% diagnose_numeric()

# Check the correlation between variables
# All the correlation between variables is weak
correlate(bank)
plot_correlate(bank)

# 1. Let's make some data analysis

# 1.1 Check the percentage of people based on their marital status
bank %>% count(marital) %>%
  mutate(percentage = n/sum(n)*100) %>% 
  arrange(desc(percentage))

# Let's create a barchart with the information above

bank %>% count(marital) %>% 
  mutate(percentage = n/sum(n)*100) %>% 
  arrange(desc(percentage)) %>% 
  ggplot(aes(x=reorder(marital, -percentage), y=percentage, fill=marital)) +
  geom_bar(stat = "identity") +
  labs(title = "Marital Status of Bank Customers",
       x = "Marital Status",
       y = "Percentage") +
  theme_bw() + theme(legend.position = "none")

# 1.2 Calculate the amount of people by occupation
bank %>% count(job) %>% arrange(desc(n))

# Let's create another barchart
bank %>% count(job) %>% arrange(desc(n)) %>% 
  ggplot(aes(x=reorder(job, -n), y=n, fill=job)) +
  geom_bar(stat = "identity", fill='red') +
  labs(title = "Bank costumers by occupation",
       x='Occupation',
       y='Number of costumers') +
  theme_classic() + theme(axis.text.x = element_text(size = 7))

# 1.3 The number of people in default
bank %>% count(default) %>% 
  mutate(percentage = n/sum(n)*100)

# 2. Let's filter the dataset to only include customers who are in default

defaulters <- bank %>% filter(default == "yes")
defaulters

# 2.1 Defaulters by occupation
defaulters %>% count(job) %>% arrange(desc(n))
BarChart(data=defaulters, job, sort = "-", horiz = TRUE, fill = "orangered4")

# 2.2 Defaulters and education
defaulters %>% count(education) %>% arrange(desc(n))
BarChart(data=defaulters, education, sort = "-", fill = "blue")

# 2.3 Defaulters by marital status
defaulters %>% count(marital) %>% arrange(desc(n))
BarChart(data=defaulters, marital, sort = "-", fill = "brown")

# 3. Let's group by "job" and make some calculations

# 3.1 Customers who are unemployed have the highest debt time.
bank %>% group_by(job) %>% filter(job=="unemployed") %>% 
  arrange(desc(duration)) %>% head(20)

# 3.2 Duration time is in days, we can transform to years for a better understanding

bank <- bank %>% mutate(duration_years = duration/365)

bank %>% group_by(job) %>% filter(job == "unemployed") %>% 
  arrange(desc(duration)) %>% head(20) %>% 
  mutate(duration_years = duration/365) %>% 
  select(age, job, education, duration_years)

# 3.3 Plot the duration debt in years with the occupation

ggplot(data = bank, aes(reorder(job, +duration_years), y=duration_years)) + 
  geom_bar(stat = "summary", fun="mean", fill="lightgray") +
  labs(title="Mean debt duration by occupation",
       x='Ocuppations', y='Duration years') + 
  coord_flip() + theme_classic()

# 3.4 Plot the relation between Age and Duration years
Plot(data = bank, age, duration_years, color = "red", fill = "red",
     xlab = "Age", ylab = "Years", main = "Age and Duration years")

# 3.5 Plot the customers by Age, Years and Job determining if they are or not in default
ggplot(bank, aes(x = age, y = duration_years, color = job)) +
  geom_point(alpha = 0.7) +
  facet_wrap(~ default, ncol = 1) +
  labs(x = "Age", y = "Years", color = "Job") +
  theme_bw()

# 3.6 Create a plot that compares the balance, pdays, and duration years variables in one chart
library(GGally)
ggpairs(bank[, c("balance", "pdays", "duration_years")], mapping = aes(color = "job"))
