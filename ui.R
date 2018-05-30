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
  tabsetPanel(
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
            plotOutput("plot", width = "100%")
          )
        )
      )
    )
  )
)
# Call the ui
shinyUI(ui)
