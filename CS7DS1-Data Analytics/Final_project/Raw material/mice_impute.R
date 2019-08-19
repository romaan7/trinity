# Mice Imputation
data_mice = Data
data_mice = mice(data_mice,m=5,maxit=10,method='pmm')
data_mice = complete(data_mice,5)

# Train Test Split
train_temp = sample(nrow(data_mice), 0.7*nrow(data_mice), replace = FALSE)
train = data_mice[train_temp,]
test = data_mice[-train_temp,]

# Random Forest
rf = randomForest(formula = train$Response ~ ., data = train, importance = TRUE) 
pred = predict(rf,test,type = "class")
tab = table(pred,test$Response)
result = confusionMatrix(tab)
accuracy_rf_mice = result$overall['Accuracy']
precision_rf_mice = result$byClass['Pos Pred Value']    
recall_rf_mice = result$byClass['Sensitivity']
f_measure_rf_mice = 2 * ((precision_rf_mice * recall_rf_mice) / (precision_rf_mice + recall_rf_mice))

# Decision tree
dt = rpart(train$Response~.,data=train,method='class')
pred = predict(dt,test,type = "class")
tab = table(pred,test$Response)
result = confusionMatrix(tab)
accuracy_dt_mice = result$overall['Accuracy']
precision_dt_mice = result$byClass['Pos Pred Value']    
recall_dt_mice = result$byClass['Sensitivity']
f_measure_dt_mice = 2 * ((precision_dt_mice * recall_dt_mice) / (precision_dt_mice + recall_dt_mice))

# Logistic Regression
lr = glm(train$Response ~.,family=binomial(link='logit'),data=train)
pred = round(predict(lr,test,type = "response"))
tab = table(pred,test$Response)
result = confusionMatrix(tab)
acc_lr_mice = result$overall['Accuracy']
precision_lr_mice = result$byClass['Pos Pred Value']    
recall_lr_mice = result$byClass['Sensitivity']
f_measure_lr_mice = 2 * ((precision_lr_mice * recall_lr_mice) / (precision_lr_mice + recall_lr_mice))
