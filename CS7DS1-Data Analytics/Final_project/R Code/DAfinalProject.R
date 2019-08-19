# Install all the required packages
#install.packages(c("partykit","rpart","randomForest","naniar","ggplot2","corrgram","sm"))

# Import all the required libs
library(partykit)
library(rpart)
library(randomForest)
library(naniar)
library(ggplot2)

library(corrgram)
library(corrplot)
library(sm)

library("VIM")
library("dplyr")
library(ggplot2)
library("gridExtra")

install.packages("sm")

# Read data from CSV and attach to R
rm(list=ls())
getwd()
setwd("C:/Users/romaa/Desktop/")
Data <- read.csv("ProjectData.csv",header=TRUE,sep=",")
View(Data)

#2.1.	Data structure
str(Data)
names(Data)
attach(Data)
#change values for group
Data$Group <- ifelse(Data$Group == 1, "Male", ifelse(Data$Group == 0, "Female", "B"))


#2.2.	Visualizing Missing data
vis_miss(Data)
gg_miss_upset(Data)
gg_miss_var(Data)
gg_miss_case(Data, order_cases = TRUE)
aggr(Data, numbers = TRUE, prop = c(TRUE, FALSE))
aggr(Data, combined = TRUE, numbers = TRUE, prop = c(TRUE, FALSE))


#2.3.	Analyzing Shape and Variance

#with outliers
boxplot(Data,main="With outliers")

#without outliers
boxplot(Data,main="Without outliers",outline=FALSE)

#with respect to groups
boxplot(X1~Group,data=Data,main="Without outliers")


#Histogram
hist(Data$X1,main="Histogram of X1",xlab="X1",breaks=100,col="gray")
hist(Data$X2,main="Histogram of X2",xlab="X2",breaks=100,col="gray")
hist(Data$X3,main="Histogram of X3",xlab="X3",breaks=100,col="gray")
hist(Data$X4,main="Histogram of X4",xlab="X4",breaks=100,col="gray")
hist(Data$X5,main="Histogram of X5",xlab="X5",breaks=100,col="gray")
hist(Data$X6,main="Histogram of X6",xlab="X6",breaks=100,col="gray")
hist(Data$X7,main="Histogram of X7",xlab="X7",breaks=100,col="gray")

#density curve
d <- density(na.omit(Data$X1))
plot(d, main="Density of X1")
polygon(d, col="turquoise", border="blue")

d <- density(na.omit(Data$X2))
plot(d, main="Density of X2")
polygon(d, col="turquoise", border="blue")

d <- density(na.omit(Data$X3))
plot(d, main="Density of X3")
polygon(d, col="turquoise", border="blue")

d <- density(na.omit(Data$X4))
plot(d, main="Density of X4")
polygon(d, col="turquoise", border="blue")

d <- density(na.omit(Data$X5))
plot(d, main="Density of X5")
polygon(d, col="turquoise", border="blue")

d <- density(na.omit(Data$X6))
plot(d, main="Density of X6")
polygon(d, col="turquoise", border="blue")

d <- density(na.omit(Data$X7))
plot(d, main="Density of X7")
polygon(d, col="turquoise", border="blue")


#2.4.	X and Y Relationship

ggplot(Data, aes(x=X1, y=Y1,shape=Group, color=Group)) + ggtitle("Plot of X1 vs Y1 w.r.t group") +geom_point(size=2, shape=Group) + scale_y_continuous(limits=c(0, 1)) +scale_x_continuous(name="X1", limits=c(0, 250))+geom_vline(xintercept = 36)
ggplot(Data, aes(x=X2, y=Y2,shape=Group, color=Group)) + ggtitle("Plot of X2 vs Y2 w.r.t group") + geom_point(size=2, shape=Group) + scale_y_continuous(limits=c(0, 1)) +scale_x_continuous(name="X2", limits=c(0, 550))+geom_vline(xintercept = 250)
ggplot(Data, aes(x=X3, y=Y3,shape=Group, color=Group)) + ggtitle("Plot of X3 vs Y3 w.r.t group") + geom_point(size=2, shape=Group) + scale_y_continuous(limits=c(0, 1)) +scale_x_continuous(name="X3", limits=c(0, 550))+geom_vline(xintercept = 250)
ggplot(Data, aes(x=X4, y=Y4,shape=Group, color=Group)) + ggtitle("Plot of X4 vs Y4 w.r.t group") + geom_point(size=2, shape=Group) + scale_y_continuous(limits=c(0, 1)) +scale_x_continuous(name="X4", limits=c(0, 250))+geom_vline(xintercept = 70)
ggplot(Data, aes(x=X5, y=Y5,shape=Group, color=Group)) + ggtitle("Plot of X5 vs Y5 w.r.t group") + geom_point(size=2, shape=Group) + scale_y_continuous(limits=c(0, 1)) +scale_x_continuous(name="X5", limits=c(0, 250))#+geom_vline(xintercept = 30)
ggplot(Data, aes(x=X6, y=Y6,shape=Group, color=Group)) + ggtitle("Plot of X6 vs Y6 w.r.t group") + geom_point(size=2, shape=Group) + scale_y_continuous(limits=c(0, 1)) +scale_x_continuous(name="X6", limits=c(0, 20))+geom_vline(xintercept = 1.5)
ggplot(Data, aes(x=X7, y=Y7,shape=Group, color=Group)) + ggtitle("Plot of X7 vs Y7 w.r.t group") + geom_point(size=2, shape=Group) + scale_y_continuous(limits=c(0, 1)) +scale_x_continuous(name="X7", limits=c(0, 1000))+geom_vline(xintercept = 510)


#2.5.	Correlation between all the X variables.
onlyX <- Data[,c(4,5,6,7,8,9,10)] #extract only X variables
res <- cor(onlyX, use="na.or.complete", method="pearson")
corrplot(res, method = "number",type = "upper", tl.col = "black")


#2.6.	Response vs X 
ggplot(Data, aes(x=X1, y=Response,shape=Group, color=Group)) + ggtitle("Plot of X1 vs Response") + geom_point(size=2, shape=Group) + scale_y_continuous(limits=c(0, 1)) +scale_x_continuous(name="X1", limits=c(0, 250))
ggplot(Data, aes(x=X2, y=Response,shape=Group, color=Group)) + ggtitle("Plot of X2 vs Response") + geom_point(size=2, shape=Group) + scale_y_continuous(limits=c(0, 1)) +scale_x_continuous(name="X2", limits=c(0, 250))
ggplot(Data, aes(x=X3, y=Response,shape=Group, color=Group)) + ggtitle("Plot of X3 vs Response") + geom_point(size=2, shape=Group) + scale_y_continuous(limits=c(0, 1)) +scale_x_continuous(name="X3", limits=c(0, 250))
ggplot(Data, aes(x=X4, y=Response,shape=Group, color=Group)) + ggtitle("Plot of X4 vs Response") + geom_point(size=2, shape=Group) + scale_y_continuous(limits=c(0, 1)) +scale_x_continuous(name="X4", limits=c(0, 250))
ggplot(Data, aes(x=X5, y=Response,shape=Group, color=Group)) + ggtitle("Plot of X5 vs Response") + geom_point(size=2, shape=Group) + scale_y_continuous(limits=c(0, 1)) +scale_x_continuous(name="X5", limits=c(0, 250))
ggplot(Data, aes(x=X6, y=Response,shape=Group, color=Group)) + ggtitle("Plot of X6 vs Response") + geom_point(size=2, shape=Group) + scale_y_continuous(limits=c(0, 1)) +scale_x_continuous(name="X6", limits=c(0, 250))
ggplot(Data, aes(x=X7, y=Response,shape=Group, color=Group)) + ggtitle("Plot of X7 vs Response") + geom_point(size=2, shape=Group) + scale_y_continuous(limits=c(0, 1)) +scale_x_continuous(name="X7", limits=c(0, 250))

#3.	Predictive Analytics

#3.1 Mean Imputation
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


# 3.2 Mice Imputation
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


#3.3 KNN Imputation
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



# 5. INdividual accuraccy
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




##########CODE ENDS HERE##########################################################

###################################################################################

#########################Below section is for trying new commands please ignore######
#TRY HERE
x<-rnorm(10000)
boxplot(x,horizontal=TRUE,axes=FALSE)XYrelation01
boxplot(x,horizontal=TRUE,axes=FALSE,outline=FALSE)
ggplot(Data) + geom_density(aes(x=Group, y=X5, color=Group))

vegLengths <-rbind(Data$X1, Data$X2)

ggplot(vegLengths) + geom_density(alpha = 0.2)

ggplot(Data, aes(Data$X1)) + geom_density(adjust = 5)

ggplot(Data, aes(Data$X1, colour = c(Data$X1,Data$X2,Data$X3,Data$X4,Data$X5,Data$X6,Data$X7))) +
  geom_density() 

qplot(x = X1, y= Y1, title="p2 vs a3", 
      size=I(1), geom="point")+scale_x_log10(name = "X1",  breaks = 50)

boxplot(Data,horizontal=TRUE,main="Without outliers",outline=FALSE ,col=c("Blue"))

boxplot(Data$X1,Data$X1,
        horizontal=TRUE,
        names=c("Male","Female"),
        col=c("turquoise","tomato"),
        xlab="Values",
        main="X1 male and female")

hist(Data$X1,xlab="X1",breaks=100,col="turquoise")

ggplot(Data$X1, aes(length, fill = X1)) + geom_density(alpha = 0.2)

res <- cor(Data, use="complete.obs", method="kendall")
cor(Data, use="complete.obs", method="kendall")

res <- Data[,c(4,5,6,7,8,9,10)]
View(res)
data.frame(A=c(1,2),B=c(3,4),C=c(5,6),D=c(7,7),E=c(8,8),F=c(9,9))

corrgram(Data)
corrplot(res, method = "number",type = "upper", order = "hclust", tl.col = "black", tl.srt = 45)

gplot(Data$X1,Data$Y1)
pairs(Data)

View(mtcars)
cyl.f <- factor(Data, levels= c(1,2,3,4,5,6,7), labels = c("X1", "X2", "X3","X4","X5","X6","X7")) 
sm.density.compare(Data$X2, Data$x1, xlab="Miles Per Gallon")


d <- density(na.omit(Data$X5))
plot(d, main="Density of X1")
polygon(d, col="red", border="blue")

tData$Group <- as.factor(tData$Group)
View(tData)
tData$Group <- ifelse(tData$Group == 1, "Male", ifelse(tData$Group == 0, "Female", "B"))

Gender <- as.factor(Data$Group,labels = c("Female","Male"))
