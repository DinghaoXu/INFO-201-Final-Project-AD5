# Setup
library(shiny)
library(shinythemes)
library(dplyr)
library(ggplot2)
library(wordcloud)
library("tm")
library("SnowballC")
library("RColorBrewer")
source("server.R")

# Define the ui
ui <- navbarPage(
  theme = shinytheme("readable"),
  tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
 
   tabPanel("Introduction",
          titlePanel("KOYN"),
          mainPanel(
            h1("Everything you need to know to be on top of your coin.", 
               align = "center"),
            img(src = 'https://goo.gl/images/ZQQiZQ', alt = "blockchain"),
            p("KOYN is an", em("interactive"), "outlet for you to learn not
              only basic information regarding your coin, but also deeper
              insights and comparisons to support you in your investments.
              The data is provided by", a("Twitter", href =
              'https://developer.twitter.com/en/docs.html'),"and by user",
              a("pmohun", href =
              'https://www.kaggle.com/philmohun/cryptocurrency-financial-data'),
              "on Kaggle, which we rendered based on", em("common demands"),
              "we saw in our user research.KOYN provides three main
              functionalities-- an illustration of", strong("coin volatility"),
              ", a live twitter feed for",strong("updated news"), ", and a",
              strong("prediction model"), "for your coin."),
            h3("Knowing your coin is essential for successful investments. 
              We make your coin make sense.", align = "center")
  )),
  tabPanel("Introduction",
  titlePanel("KOYN"),
  mainPanel(
    h1("Everything you need to know to be on top of your coin.", align = "center"),
    img(src='https://goo.gl/images/ZQQiZQ', alt = "blockchain"),
    p("KOYN is an", em("interactive"), "outlet for you to learn not
    only basic information regarding your coin, but also deeper 
    insights and comparisons to support you in your investments. 
    The data is provided by", a("Twitter", href = 'https://developer.twitter.com/en/docs.html'),
      "and by user", a("pmohun", href = 'https://www.kaggle.com/philmohun/cryptocurrency-financial-data'),
      "on Kaggle, which we rendered based on", em("common demands"), "we saw in our user research.
    KOYN provides three main functionalities-- an 
    illustration of", strong("coin volatility"), ", a live twitter feed for",
      strong("updated news"), ", and a", strong("prediction model"), "for your coin."),
    h3("Knowing your coin is essential for successful investments. 
     We make your coin make sense.", align = "center")
  )),
  tabPanel("Coin volatility",
           titlePanel("Coin Volatility"),
           sidebarLayout(
             sidebarPanel(
               tags$h2("Choose the types of cryptocurrency you want to compare"),
               textInput(
                 "crypto_1",
                 label = "First cryptocurrency"
               ),
               textInput(
                 "crypto_2",
                 label = "Second cryptocurrency"
               ),
               selectInput(
                 "time_year",
                 label = "Year",
                 choices = c("2014", "2015", "2016", "2017", "2018")
               ),
               selectInput(
                 "time_month",
                 label = "Month",
                 choices = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
                             "Aug", "Sep", "Oct", "Nov", "Dec")
               )
             ),
             mainPanel(
               tags$h3("Here is the first plot"),
               plotOutput("crptoline_1"),
               tags$h3("Here is the second plot"),
               plotOutput("cryptoline_2")
             )
           )
           ),
tabPanel(
  "Twitter",
  titlePanel(
    sidebarLayout(
      sidebarPanel(
        sliderInput(
          "min_freq_slider",
          label = h3("Minimum Frequency:"), min = 1,
          max = 20, value = 3
        ),
        textInput(
          "keyword",
          label = "Type a Keyword", value = "#bitcoin"
        ),
        plotOutput("plot")  
      ),
      
      # Main panel which displays barplot
      mainPanel(
        
        DT::dataTableOutput("tweets")
      )))),
  tabPanel("Holt's Forecasting Model:",
           mainPanel(
           plotOutput("holt_plot"))),
  tabPanel("Exponential Triple Smoothing Model:",
           mainPanel(
           plotOutput("ets_plot"))),
  tabPanel("ARIMA Forecasting Model:",
           plotOutput("arima_plot")),
  tabPanel("Bayesian Forecasting Model:",
           plotOutput("bayesian_plot")),
  tabPanel("Feedback",
           titlePanel("Your Feedbacks"),
           sliderInput(
             "feedback_1",
             label = "1. Overall, how would you rate our app ?",
             min = 0, max = 10, value = 5
           ),
           sliderInput(
             "feedback_2",
             label = "2. How would you rate the layout of the app ?",
             min = 0, max = 10, value = 5
           ),
           sliderInput(
             "feedback_3",
             label = "3. How would you rate the usability of the app ?",
             min = 0, max = 10, value = 5
           ),
           textInput(
             "feedback_4",
             label = "4. Please give us some advices about the part we can improve on"
           ),
           actionButton(
             "feedback_submit",
             label = "submit"
           )
  ),
  tabPanel("About Us",
           titlePanel("KOYN", align = "center"),
           mainPanel(
             h3("What is cryptocurrency?", align = "center"),
             p(
               "Cryptocurrency is, in essence,", em("virtual money"), "that
               can be exchanged online. Unlike centralized banking systems that
               control physical currency, cryptocurrency is controlled
               by what is known as", strong("blockchain technology"), "which
               serves as a public transaction database. The price of
               cryptocurrency can easily fluctuate based on its
               ", em("supply and demand"), ". That is why, for
               example, Bitcoin's value rose up so much and then
               dropped in a short amount of time. Cryptocurrency is without
               a doubt a potential solution for currency altogether in the
               future-- that's why its important for us to learn more about it.
               To be successful in investing in cryptocurrency, the data is the
               most important factor to consider. It tells trends that could
               help us predict how the currency will act in the future.",
               align = "center"
             ),
             h3("Why KOYN?", align = "center"),
             p(
               "With the growing popularity of", em("cryptocurrency"),
               ", more and more people want to know what it is and how to start
               investing in it. For anyone who may be interested in investing
               in cryptocurrency, we provide", em("essential"), "information
               that supports them in their decision making to make the most",
               strong("profit"), "off of their efforts. The pieces are all
               there for anyone to succeed in the", strong("crypto-market"),
               "-- KOYN is just the gateway for you to", em("fully"),
               "understand your coin.", align = "center"
             )
           )
           )
)
  # Call the ui
  shinyUI(ui)
