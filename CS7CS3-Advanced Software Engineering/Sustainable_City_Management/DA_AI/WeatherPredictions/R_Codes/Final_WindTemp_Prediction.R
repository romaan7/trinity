library("mice")
library("VIM")
library("randomForest")
df = read.csv("D:/Trinity_DS/AdvancedSoftwareEngineernig/WeatherPredictions/WindTempTraining.csv")
df_predict = read.csv("D:/Trinity_DS/AdvancedSoftwareEngineernig/WeatherPredictions/April.csv")
names(df)[names(df) == "ï..month"] <- "month"

cols <- c(1:3)
df[cols]<-lapply(df[cols],factor)
names(df)
names(df_predict)
str(df_predict)
cols <- c(1:3)
df_predict[cols]<-lapply(df_predict[cols],factor)
summary(df_predict)


df <- df[complete.cases(df), ]
df_wind <- df[,1:4]
df_temp <- df[,c(1:3,5)]
names(df_wind)


names(df)


lm_temp <- lm(Tempreture~., data = df_temp)
summary(lm_temp)

df_predict
yhat_april <- predict(lm_temp,df_predict)
yhat_april
predicted_df <- as.data.frame(yhat_april)
colnames(predicted_df)
df_april_predicted <- cbind(df_predict,predicted_df)
df_wind

write.csv(df_april_predicted,"2019_TempPredicted.csv")
names(df_predict)


