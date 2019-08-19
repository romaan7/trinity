
library('ggplot2')

library("mice")
library("VIM")
library("randomForest")
df = read.csv("D:/Trinity_DS/AdvancedSoftwareEngineernig/WeatherPredictions/disjoint_weather.csv")
df_predict = read.csv("D:/Trinity_DS/AdvancedSoftwareEngineernig/WeatherPredictions/April.csv")
names(df)
str(df)
cols <- c(1:5)
df[cols]<-lapply(df[cols],factor)
str(df)
summary(df) 
df <- df[complete.cases(df), ]
df$station_id<- NULL
df
names(df)
set.seed(2)
trainIndex  <- sample(1:nrow(df), 0.80 * nrow(df))
train <- df[trainIndex,]
test <- df[-trainIndex,]
nrow(df)
nrow(train)
nrow(test)


lm1 <- lm(Temperture~., data = train)
yhat <- predict(lm1,test[1:4])
summary(lm1)
lm_rmse <- sqrt(mean((test$Temperture - yhat)^2))
lm_rmse
str(train$Temperture)
names(train)
cols <- c(1:4)
df_predict[cols]<-lapply(df_predict[cols],factor)
df_predict <- as.datfactor(df_predict)
df_predict
yhat_april <- predict(lm1,df_predict)
yhat_april
predicted_df <- as.data.frame(yhat_april)
colnames(predicted_df)
df_april_predicted <- cbind(df_predict,predicted_df)
write.csv(df_april_predicted,"2019_TempPredicted.csv")
names(df_predict)






##########RF###############




RF <- randomForest(Temperture~., data=df)


print(RF)
importance(RF)
varImpPlot(RF)
summary(df_predict)
colnames(df[,2:5])
colnames(df_predict[,2:4])
pred_RF<-predict(RF,df_predict)
yhat_RF<- data.frame(pred_RF)
