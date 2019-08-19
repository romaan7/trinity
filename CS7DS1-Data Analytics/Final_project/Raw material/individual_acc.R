library(networkreporting)
# Data read
setwd("~/Desktop")
Data <- read.csv("data.csv",header=TRUE,sep=",")
Data$ID = NULL
Data = subset(Data,select=c("X1","X4","X5","X6","X7","Y2","Y3","Y4","Y7","Response"))
Data = as.data.frame(scale(Data)) 
Data = topcode.data(Data,max=1000)
train_temp = sample(nrow(Data), 0.7*nrow(Data), replace = FALSE)
train = Data[train_temp,]
test = Data[-train_temp,]

# Random Forest
rf = randomForest(formula = train$Response ~ ., data = train, importance = TRUE) 
pred = round(predict(rf,test,type = "class"))
tab = table(pred,test$Response)
result = confusionMatrix(tab)
accuracy_rf_mice = result$overall['Accuracy']
precision_rf_mice = result$byClass['Pos Pred Value']    
recall_rf_mice = result$byClass['Sensitivity']
f_measure_rf_mice = 2 * ((precision_rf_mice * recall_rf_mice) / (precision_rf_mice + recall_rf_mice))
print(accuracy_rf_mice)
print(precision_rf_mice)
print(recall_rf_mice)
print(f_measure_rf_mice)

# Decision tree
dt = rpart(train$Response~.,data=train,method='class')
pred = predict(dt,test,type = "class")
tab = table(pred,test$Response)
result = confusionMatrix(tab)
accuracy_dt_mean = result$overall['Accuracy']
precision_dt_mean = result$byClass['Pos Pred Value']    
recall_dt_mean = result$byClass['Sensitivity']
f_measure_dt_mean = 2 * ((precision_dt_mean * recall_dt_mean) / (precision_dt_mean + recall_dt_mean))
print(accuracy_dt_mean)
print(precision_dt_mean)
print(recall_dt_mean)
print(f_measure_dt_mean)


