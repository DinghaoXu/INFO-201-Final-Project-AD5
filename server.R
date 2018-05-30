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
library(DT)
source("script/api-key.R")
source("script/functions.R")
source("script/forecast.R")


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
  
  
  
  
  
  
  
  # Change the next four lines based on your own consumer_key, consume_secret, access_token, and access_secret.
  consumer_key <- api_consumer_key
  consumer_secret <- api_consumer_secret
  access_token <- api_access_token
  access_secret <- api_access_secret
  
  setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
  
   tweets <- reactive({
     tw = twitteR::searchTwitter(input$keyword, n=300, lang = "en")
     tweets <- twitteR::twListToDF(tw)
     tweets <- tweets[,c(1,5,11)]
     colnames(tweets) <- c("Tweet", "Date_and_Time", "Screen_Name")
   return(tweets)
   })
  
  output$plot <- renderPlot({
  text <- ""
  
  for (row in 1:300) {
    text <- paste(text, tweets()[row,1])
  }
  
  data <- Corpus(VectorSource(text))
  
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
    return (wordcloud(words = d$word, freq = d$freq, c(6,.7), min.freq = input$min_freq_slider,
              max.words=350, random.order=FALSE, rot.per=0.35,
              colors=brewer.pal(8, "Dark2")))
  })
  
  output$tweets <- DT::renderDataTable({
    return(DT::datatable(tweets(), options = list(lengthMenu = c(5, 30, 50, 100), pageLength = 5)))
  })

}

# Call the server
shinyServer(server)
