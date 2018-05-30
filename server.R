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
library(wordcloud)
library("tm")
library("SnowballC")
library("RColorBrewer")
#source("script/api-key.R")

# Change the next four lines based on your own consumer_key, consume_secret, access_token, and access_secret. 
consumer_key <- "Xg8vT7FzyHPHtgTmgOyezAE82"
consumer_secret <- "B9jZ8RqOW87Fhdz7NQeAO4GMp8JLcPFgHL0nxN7730EbojcrlD"
access_token <- "1012610244-LeiPJYlrZVkJrANOQmTsf2ohpBrg2AYsFAjZZfd"
access_secret <- "mzXiNGcNVQnJcLjyoKgcmxNL84liz65ErkG7cz1fep65F"

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


server <- function(input, output) {
  output$plot <- renderPlot({
    wordcloud(words = d$word, freq = d$freq, min.freq = 3,
              max.words=350, random.order=FALSE, rot.per=0.35, 
              colors=brewer.pal(8, "Dark2")) 
  })

# Call the server
shinyServer(server)
}