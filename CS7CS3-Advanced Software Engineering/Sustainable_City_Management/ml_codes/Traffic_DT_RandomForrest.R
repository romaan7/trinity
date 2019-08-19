library(rpart)
library(randomForest)
setwd("D:/Trinity_DS/AdvancedSoftwareEngineernig/Project/Traffic/TransformedData")
df=read.csv("out.csv")
set.seed(29)
df$hours <- factor(df$hours)
df$day <- factor(df$day)
df$month <- factor(df$month)
trainIndex  <- sample(1:nrow(df), 0.80 * nrow(df))
train <- df[trainIndex,]
test <- df[-trainIndex,]
nrow(df)
df
nrow(train)
nrow(test)
str(train)
DT_Model <- rpart(train$aggerateCount~., data=train)
pred_DT = predict(DT_Model,test)
confMat_DT <- table(pred_DT,test$aggerateCount)
accuracy_DT <- sum(diag(confMat_DT))/sum(confMat_DT)
accuracy_DT
RF <- randomForest(aggerateCount~., data=train)

pred_RF<-predict(RF,test)
pred_RF
confMat_RF <- table(pred_RF,test$aggerateCount)
accuracy_RF <- sum(diag(confMat_RF))/sum(confMat_RF)
confMat_RF
