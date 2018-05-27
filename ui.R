# Setup
library(shiny)
library(shinythemes)
library(dplyr)
library(ggplot2)

# Define the ui
ui <- navbarPage(theme = shinytheme("readable"),
  tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
  tabPanel("Introduction"
           ),
  tabPanel("Coin volatility"),
  tabPanel("Twitter"),
  tabPanel("Recommendation"),
  tabPanel("Feedback")
)
# Call the ui
shinyUI(ui)