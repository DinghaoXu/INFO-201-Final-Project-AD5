# Setup
library(shiny)
library(shinythemes)
library(dplyr)
library(ggplot2)
library(wordcloud)
library("tm")
library("SnowballC")
library("RColorBrewer")

# Define the ui
ui <- navbarPage(
  theme = shinytheme("readable"),
  tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),

  tabPanel("Introduction"),
          titlePanel("KOYN"),
          mainPanel(
            h1("Everything you need to know to be on top of your coin.", 
               align = "center"),
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
  ),
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
          label = h3("Minimum Frequency:"), min = 0,
          max = 6, value = 2
        )
      ),
      # Main panel which displays barplot
      mainPanel(
        plotOutput("plot", width = "200%", height = "200%")
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
  )
)
  # Call the ui
  shinyUI(ui)
