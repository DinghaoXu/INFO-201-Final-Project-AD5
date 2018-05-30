# Setup
library(shiny)
library(shinythemes)
library(dplyr)
library(ggplot2)
library(ggthemes)

source("script/functions.R")

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
  
  
}

# Call the server
shinyServer(server)