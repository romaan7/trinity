# KNN Imputation
data_knn = Data
data_knn = kNN(data_knn,k=10)
data_knn = data_knn[1:17]

# Train Test Split
train_temp = sample(nrow(data_knn), 0.7*nrow(data_knn), replace = FALSE)
train = data_knn[train_temp,]
test = data_knn[-train_temp,]

# Random Forest
rf = randomForest(formula = train$Response ~ ., data = train, importance = TRUE) 
pred = predict(rf,test,type = "class")
tab = table(pred,test$Response)
result = confusionMatrix(tab)
accuracy_rf_knn = result$overall['Accuracy']
precision_rf_knn = result$byClass['Pos Pred Value']    
recall_rf_knn = result$byClass['Sensitivity']
f_measure_rf_knn = 2 * ((precision_rf_knn * recall_rf_knn) / (precision_rf_knn + recall_rf_knn))

# Decision tree
dt = rpart(train$Response~.,data=train,method='class')
pred = predict(dt,test,type = "class")
tab = table(pred,test$Response)
result = confusionMatrix(tab)
accuracy_dt_knn = result$overall['Accuracy']
precision_dt_knn = result$byClass['Pos Pred Value']    
recall_dt_knn = result$byClass['Sensitivity']
f_measure_dt_knn = 2 * ((precision_dt_knn * recall_dt_knn) / (precision_dt_knn + recall_dt_knn))

# Logistic Regression
lr = glm(train$Response ~.,family=binomial(link='logit'),data=train)
pred = round(predict(lr,test,type = "response"))
tab = table(pred,test$Response)
result = confusionMatrix(tab)
acc_lr_knn = result$overall['Accuracy']
precision_lr_knn = result$byClass['Pos Pred Value']    
recall_lr_knn = result$byClass['Sensitivity']
f_measure_lr_knn = 2 * ((precision_lr_knn * recall_lr_knn) / (precision_lr_knn + recall_lr_knn))
