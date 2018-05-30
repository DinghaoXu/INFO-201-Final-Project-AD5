library(dplyr)

coin_history <- read.csv("data/consolidated_coin_data.csv", stringsAsFactors = F)
names(coin_history) <- coin_history[4,]
coin_history <- coin_history[-c(1:4),]
coin_history <- mutate(coin_history, average = (as.numeric(Open) + as.numeric(Close) + as.numeric(High) + as.numeric(Low)) / 4)
coin_history <- mutate(coin_history, year = substring(Date, 9, 12))
coin_history <- mutate(coin_history, month = substring(Date, 1, 3))
coin_history <- mutate(coin_history, day = as.numeric(substring(Date, 5, 6)))
