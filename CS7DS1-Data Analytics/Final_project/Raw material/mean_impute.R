# Mean Imputation
data_mean = Data
for(i in 1:ncol(data_mean)){
  data_mean[is.na(data_mean[,i]), i] = mean(data_mean[,i], na.rm = TRUE)
}

# Train Test Split
train_temp = sample(nrow(data_mean), 0.7*nrow(data_mean), replace = FALSE)
train = data_mean[train_temp,]
test = data_mean[-train_temp,]

# Random Forest
rf = randomForest(formula = train$Response ~ ., data = train, importance = TRUE) 
pred = predict(rf,test,type = "class")
tab = table(pred,test$Response)
result = confusionMatrix(tab)
accuracy_rf_mean = result$overall['Accuracy']
precision_rf_mean = result$byClass['Pos Pred Value']    
recall_rf_mean = result$byClass['Sensitivity']
f_measure_rf_mean = 2 * ((precision_rf_mean * recall_rf_mean) / (precision_rf_mean + recall_rf_mean))

# Decision tree
dt = rpart(train$Response~.,data=train,method='class')
pred = predict(dt,test,type = "class")
tab = table(pred,test$Response)
result = confusionMatrix(tab)
accuracy_dt_mean = result$overall['Accuracy']
precision_dt_mean = result$byClass['Pos Pred Value']    
recall_dt_mean = result$byClass['Sensitivity']
f_measure_dt_mean = 2 * ((precision_dt_mean * recall_dt_mean) / (precision_dt_mean + recall_dt_mean))

# Logistic Regression
lr = glm(train$Response ~.,family=binomial,data=train)
pred = round(predict(lr,test,type = "response"))
tab = table(pred,test$Response)
result = confusionMatrix(tab)
acc_lr_mean = result$overall['Accuracy']
precision_lr_mean = result$byClass['Pos Pred Value']    
recall_lr_mean = result$byClass['Sensitivity']
f_measure_lr_mean = 2 * ((precision_lr_mean * recall_lr_mean) / (precision_lr_mean + recall_lr_mean))
