# Setup
library(shiny)
library(shinythemes)
library(dplyr)
library(ggplot2)

# Define the ui
ui <- navbarPage(theme = shinytheme("readable"),
  tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
  tabPanel("Introduction"),
  tabPanel("Coin volatility",
           titlePanel("Coin Volatility"),
           sidebarLayout(
             sidebarPanel(
               tags$h2("Choose the types of cryptocurrency you want to compare"),
               selectInput(
                 "crypto_a",
                 label = "The first cryptocurrency",
                 choices = c("a", "b")
                 ),
               selectInput(
                 "crypto_b",
                 label = "The Second cryptocurrency",
                 choices = c("a", "b")
               ),
               selectInput(
                 "time_year",
                 label = "Year",
                 choices = c("a", "b")
               ),
               selectInput(
                 "time_month",
                 label = "Month",
                 choices = c("a", "b")
               )
             ),
             mainPanel(
               tags$h3("Here is the first plot"),
               tags$h3("Here is the second plot")
             )
           )
           ),
  tabPanel("Twitter"),
  tabPanel("Recommendation"),
  tabPanel("Feedback")
)
# Call the ui
shinyUI(ui)