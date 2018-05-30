#install.packages("twitteR")
#install.packages("RCurl")
library(RCurl)
library(twitteR)
library(httr)
library(jsonlite)
library(shiny)
library(shinythemes)
library(dplyr)
library(ggplot2)
library(ggthemes)
library("wordcloud")
library("tm")
library("SnowballC")
library("RColorBrewer")
source("script/api-key.R")
source("script/functions.R")
source("script/forecast.R")


# Change the next four lines based on your own consumer_key, consume_secret, access_token, and access_secret.
consumer_key <- api_consumer_key
consumer_secret <- api_consumer_secret
access_token <- api_access_token
access_secret <- api_access_secret

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
tw = twitteR::searchTwitter('#bitcoin', n=300, lang = "en")
tweets = twitteR::twListToDF(tw)

text <- ""

for (row in 1:1000) {
  text <- paste(text, tweets[row,])
}

data <- Corpus(VectorSource(text))
#inspect(data)

toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
data <- tm_map(data, toSpace, " ' ")

# Convert the text to lower case
data <- tm_map(data, content_transformer(tolower))
# Remove numbers
data <- tm_map(data, removeNumbers)
# Remove english common stopwords
data <- tm_map(data, removeWords, stopwords("english"))
# Remove your own stop word
# specify your stopwords as a character vector
data <- tm_map(data, removeWords, c("RT", "@"))
# Remove punctuations
data <- tm_map(data, removePunctuation)
# Eliminate extra white spaces
data <- tm_map(data, stripWhitespace)

dtm <- TermDocumentMatrix(data)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)

for (row in 1:nrow(d)) {
  if(grepl("true", d[row,1]) || grepl("false", d[row,1]) || grepl("http", d[row,1]) || grepl("href", d[row,1]) || grepl("twitter", d[row,1]) || grepl("web", d[row,1]) || grepl("client", d[row,1])) {
    d <- d[-row,]
  }
}

for (row in 1:nrow(d)) {
  if(grepl("true", d[row,1]) || grepl("false", d[row,1]) || grepl("http", d[row,1]) || grepl("href", d[row,1]) || grepl("twitter", d[row,1]) || grepl("web", d[row,1]) || grepl("client", d[row,1])) {
    d <- d[-row,]
  }
}

#output$max_freq <- reactive({
#max(d$freq)
#})
#ALL FOR DISPLAYING TWEETS
#display <- select(twitter_data, user.profile_image_url, text, created_at, user.followers_count)
#Change column names

#colnames(display) <- c("Profile_Picture", "Tweet", "Date_and_Time", "Followers")

# Change photo and email to correct format to show in index
#display$Profile_Picture <- paste0("![](", display$Profile_Picture, ")")
#display[display$Profile_Picture == "![](NA)", "Profile_Picture"] <- "Not available"

#display <- filter(display, is.na(Tweet) == FALSE)

#require("tm")
#removeWords("+0000",display$Date_and_Time)
#formatted <- kable(display)

# Define the server
server <- function(input, output) {
  output$crptoline_1 <- renderPlot({
    coin_history_wanted_1 <- coin_history %>%
      filter(Currency == input$crypto_1) %>%
      filter(year == input$time_year) %>%
      filter(month == input$time_month)
    title <- paste0(input$crypto_1, " in ", input$time_month, ", ", input$time_year)
    x <- coin_history_wanted_1$day
    y <- coin_history_wanted_1$average
    p <- ggplot() +
      geom_line(mapping = aes(x = x, y = y), color = "blue") +
      labs(title = title, x = "Date", y = "Exchange Rate") +
      theme_solarized()
    p
  })
  output$cryptoline_2 <- renderPlot({
    coin_history_wanted_2 <- coin_history %>%
      filter(Currency == input$crypto_2) %>%
      filter(year == input$time_year) %>%
      filter(month == input$time_month)
    title <- paste0(input$crypto_2, " in ", input$time_month, ", ", input$time_year)
    x <- coin_history_wanted_2$average
    y <- coin_history_wanted_2$day
    p <- ggplot() +
      geom_line(mapping = aes(x = x, y = y), color = "green") +
      labs(title = title, x = "Exchange Rate", y = "Date") +
      theme_solarized()
    p
  })
  output$ets_plot <- renderPlot({
    plot(forecast(ETS, h = 10), ylim = c(0,10000))
  })
  output$holt_plot <- renderPlot({
    plot(holtf, ylim = c(0,10000))
  })
  output$arima_plot <- renderPlot({
    plot(forecast(gege, h = 10), ylim = c(0,10000))
  })
  output$bayesian_plot <- renderPlot({
    plot(model1, ylim = c(0,10000))
  })
  output$szn_analysis <- renderPlot({
    plot(szn_analysis)
  })

  output$plot <- renderPlot({
    wordcloud(words = d$word, freq = d$freq, min.freq = 3,
              max.words=350, random.order=FALSE, rot.per=0.35,
              colors=brewer.pal(8, "Dark2"))
  })



# Call the server
shinyServer(server)
}