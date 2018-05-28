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
  tabPanel("Twitter"),
  tabPanel("Recommendation"),
  tabPanel("Feedback")
)
# Call the ui
shinyUI(ui)