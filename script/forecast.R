# This forecasting model was developed utilizing the guide posted by
# Arvindhan Rameshbabu on Kaggle.com. I take no credit for the mathematics and
# logic behind these models.
# Link: https://www.kaggle.com/ara0303/forecasting-of-bitcoin-prices/notebook

# packages used to implement forecasts
library("anytime")
library("bsts")
library("car")
library("caret")
library("forecast")
library("keras")
library("MCMCpack")
library("smooth")
library("tensorflow")
library("tseries")
library("TTR")

#importing data
train <- read.csv("script/train.csv")
test <- read.csv("script/test.csv")
head(train)
testdata <- test[,2]
#Converting data for analysis
train$Date <- as.Date(anytime(train$Date))
test$Date <- as.Date(anytime(test$Date))
train$Volume <- gsub(",", "", train$Volume)
train$Market.Cap <- gsub(",", "", train$Market.Cap)
train$Market.Cap <- as.numeric(train$Market.Cap)
train$Volume <- as.numeric(train$Volume)

#Difference between high and low on each day
train$a <- train$High - train$Low


#Volume has missing values
#Data Manipulation
fifty_avg <- round(mean(train$Volume[train$a < 50], na.rm = TRUE), digits = 2)
hun_avg <- round(mean(train$Volume[train$a > 50 & train$a < 100], na.rm = TRUE), digits = 2)
hf_avg <- round(mean(train$Volume[train$a > 100 & train$a < 150], na.rm = TRUE), digits = 2)
th_avg <- round(mean(train$Volume[train$a > 150 & train$a < 350], na.rm = TRUE), digits = 2)
for(i in 1:nrow(train)){
  if(is.na(train[i,6])){
    if(train$a[i] < 50){
      train$Volume[i] <- fifty_avg
    } else if(train$a[i] < 100){
      train$Volume[i] <- hun_avg
    } else if(train$a[i] < 150){
      train$Volume[i] <- hf_avg
    } else if(train$a[i] < 350){
      train$Volume[i] <- th_avg
    }else
      print("Uncaught Title")
  }
}
train <- train[, - 8] #Removing column 8
train_data_plot <- ggplot(train, aes(Date, Close)) + geom_line() + scale_x_date("year") + ylim(0,10000) + ylab("Closing Price")
train_data_plot # this is a plot showcasing the data as it currently is prior to any forecasts


#Convert data set to time series
Train <- xts(train[, -1], order.by = as.POSIXct(train$Date))
tsr <- ts(Train[,4], frequency = 365.25,start = c(2013,4,27))
plot(Train$Close,type='l',lwd = 1.5,col='red', ylim = c(0,10000), main = "Bitcoin Closing Price") # this is a plot showing the current trained data in a time series
#check for trends and seasonality
szn_analysis <- decompose(tsr) #Obtaining the trends and seasonality
plot(szn_analysis) # plot showing us trends and seasonality to allow us to see if there are any trends


# ------------------------- HOLT MODEL -------------------------
holtt <-  holt(Train[1289:1655,'Close'], type = "additive", damped = F) #holt forecast values
holtf <- forecast(holtt, h = 10)
holtdf <- as.data.frame(holtf)
plot(holtf, ylim = c(0,10000)) # plot showing the HOLT forecasted data
holtfdf <- cbind(test, holtdf[,1])
holt_accuracy <- accuracy(holtdf[,1], testdata)
# ggplot() + geom_line(data = holtfdf, aes(Date, holtfdf[,2]), color = "blue") + geom_line(data = holtfdf, aes(Date, holtfdf[,3]), color = "Dark Red")


# ------------------------- ETS MODEL -------------------------
ETS <- ets((Train[,'Close'])) # ETS forecast values
ETSf <- forecast(ETS, h = 10)
etsdf <- as.data.frame(ETSf)
plot(forecast(ETS, h = 10), ylim = c(0,10000)) #ETS forecast plot works perfectly
etsp <- predict(ETS, n.ahead = 10, prediction.interval = T, level = 0.95)
ets_accuracy <- accuracy(etsdf[,1], testdata)

# ------------------------- TESTS TO SEE TSDF ACCURACY -------------------------

tsdf <- diff(Train[,4], lag = 2)
tsdf <- tsdf[!is.na(tsdf)]
adf.test(tsdf)
# plot(tsdf, type = 1, ylim = c(-1000, 1000))

# ------------------ ACF AND PACF plots ------------------------
acf(tsdf)
pacf(tsdf)
gege <- arima(Train[,4], order = c(4,2,11))
gegef <- as.data.frame(forecast(gege, h = 10))
arim_accuracy <- accuracy(gegef[,1], testdata)
gegefct <- cbind(test, gegef[,1])
arima_plot <- plot(forecast(gege, h = 10), ylim = c(0,10000))
# this plot is comparing the two tyes of arima model types
ggplot() + geom_line(data = gegefct, aes(Date, gegefct[,2]), color = "blue") + geom_line(data = gegefct, aes(Date, gegefct[,3]), color = "Dark Red")


# ---------------------- Bayesian Plot ------------------------
#ss <- AddLocalLinearTrend(list(), Train[,4]) #Adding linear trend to model
#ss <- AddSeasonal(ss, Train[,4], nseasons = 365) #Adding seasonal trend to model
#model1 <- bsts(Train[,4],
  #             state.specification = ss,
   #            niter = 10)
#bayesian_plot <- plot(model1, ylim = c(0,10000)) #Plot based on bayesian regression of the model
#bayesian_plot
#pred1 <- predict(model1, horizon = 10)
#plot(pred1, plot.original = 50,ylim = c(0,9000))
#pred1$mean
#accuracy(pred1$mean, testdata)

#model2 <- bsts(Close ~ ., state.specification = ss,
  #             niter = 10,
   #            data = as.data.frame(Train))
#model3 <- bsts(Close ~ ., state.specification = ss,
  #             niter = 10,
   #            data = as.data.frame(Train),
    #           expected.model.size = 10)
#CompareBstsModels(list("Model 1" = model1, "Model 2" = model2, "Model 3" = model3), colors = c("blue", "red", "green"))

