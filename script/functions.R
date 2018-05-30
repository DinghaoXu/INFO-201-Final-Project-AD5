library(dplyr)
library(ggplot2)

coin_history <- read.csv("data/consolidated_coin_data.csv", stringsAsFactors = F)
names(coin_history) <- coin_history[4,]
coin_history <- coin_history[-c(1:4),]
coin_history <- mutate(coin_history, average = (as.numeric(Open) + as.numeric(Close) + as.numeric(High) + as.numeric(Low)) / 4)
coin_history <- mutate(coin_history, year = substring(Date, 9, 12))
coin_history <- mutate(coin_history, month = substring(Date, 1, 3))
coin_history <- mutate(coin_history, day = as.numeric(substring(Date, 5, 6)))

df <- read.csv("data/coins.csv", stringsAsFactors = FALSE)
coin_volume <- df$Volume
currency <- df$Currency
# Barplot
bp<- ggplot(coin_volume, aes(x="", y=coin_volume, fill= currency))+
  geom_bar(width = 1, stat = "identity")
bp
pie <- bp + coord_polar("y", start=0)
pie
