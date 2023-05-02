# We will learn how to extract information from a website in a JSON file

# We need these libraries
library(httr)
library(jsonlite)
library(tidyverse)
library(lessR)
library(stringr)

# We use the GET function from httr to make a GET request to the URL
response <- GET('https://api.covid19api.com/summary')

# We use the content function from "httr" to extract the text content of the response. 
# Since the response contains JSON data, we pass the argument "text" to content.
covid_data <- fromJSON(content(response, "text"))

# Finally, we use the fromJSON function from jsonlite to parse the JSON text into an R object, 
# which we store in the variable covid_data
covid_data

# ---------------------------------

# We can convert this data to a dataframe with "as.data.frame" 
covid_df <- as.data.frame(covid_data)

# We can check the column names and the data structure
covid_df %>% names()
covid_df %>% str()

# There is a lot of useless information. It is better to focus
# just on data from the countries
countries <- select(covid_df, contains("Countries"))

# We can check the column names again, because we need to remove extra characters
# applying the "sub" function
countries %>% names()
names(countries) <- sub("^Countries\\.", "", names(countries))

# Finally we can select specific columns to do our analysis
countries <- countries %>% select(Country:TotalDeaths)
countries

# Create a new data frame with the first 20 rows of the TotalConfirmed column
top_20 <- countries %>% arrange(desc(TotalConfirmed)) %>% head(20)

# Create a horizontal bar chart using ggplot2
ggplot(top_20, aes(x = reorder(Country, TotalConfirmed), y = TotalConfirmed)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Top 10 Countries by Total Confirmed Cases",
       x = "Country",
       y = "Total Confirmed Cases") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))  +
  coord_flip()

# Create a scatterplot to see the relation between cases and deaths
ggplot(countries, aes(x=TotalConfirmed, y=TotalDeaths)) + geom_point(color='red') +
  theme_minimal() + labs(title = "Relation between Cases and Deaths",
                         x='Confirmed cases',
                         y='Deaths')
