# Install all the required packages
#install.packages(c("partykit","rpart","randomForest","naniar","ggplot2","corrgram","sm"))

# Import all the required libs
library(partykit)
library(rpart)
library(randomForest)
library(naniar)
library(ggplot2)
library(corrplot)
library(sm)
library("VIM")
library("dplyr")
library(ggplot2)
library("gridExtra")
library(mice)
library(caret)
library(rpart)
library("ggpubr")

# Read data from CSV and attach to R
rm(list=ls())
getwd()
setwd("~/Desktop")
Data <- read.csv("data.csv",header=TRUE,sep=",")
View(Data)
attach(Data)

#2.1.	Data structure
str(Data)
names(Data)
summary(Data)

# Data preprocessing
Data$ID = NULL
Data$Response = as.factor(Data$Response)
Data$Group = as.factor(Data$Group)

# 2.1 X and Y correlation
train_temp = sample(nrow(Data), 0.7*nrow(Data), replace = FALSE)
train = Data[train_temp,]
test = Data[-train_temp,]
model = glm(Y7~X7, family = binomial, data = train)
pred = round(predict(model,test,type="response"))
tab = table(pred,test$Y1)
metric = confusionMatrix(tab)
print(metric)
qplot(Data$X1, 
      Data$X2, 
      data = Data, 
      geom = c("point", "smooth"), 
      alpha = I(1 / 5), 
      se = FALSE)
#ggscatter(Data, x = "X1", y = "Y1", add = "reg.line", conf.int = TRUE, cor.coef = TRUE, cor.method = "pearson",xlab = "X1 variable", ylab = "Y1 variable")

#2.2.	Visualizing Missing data
gg_miss_var(Data)
aggr(Data, numbers = TRUE, prop = c(TRUE, FALSE))

#2.3.	Analyzing Shape and Variance

#with outliers
boxplot(Data,main="With outliers",xlab = 'Variables', ylab = 'Outliers')

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
# Barplots
barplot(table(Data$Y1),main="Bar Graph of Y1",ylab='Frequency',col='darkblue')
barplot(table(Data$Y2),main="Bar Graph of Y2",ylab='Frequency',col='darkblue')
barplot(table(Data$Y3),main="Bar Graph of Y3",ylab='Frequency',col='darkblue')
barplot(table(Data$Y4),main="Bar Graph of Y4",ylab='Frequency',col='darkblue')
barplot(table(Data$Y5),main="Bar Graph of Y5",ylab='Frequency',col='darkblue')
barplot(table(Data$Y6),main="Bar Graph of Y6",ylab='Frequency',col='darkblue')
barplot(table(Data$Y7),main="Bar Graph of Y7",ylab='Frequency',col='darkblue')
barplot(table(Data$Group),main="Bar Graph of Group",ylab='Frequency',col='darkblue')
barplot(table(Data$Response),main="Bar Graph of Response",ylab='Frequency',col='darkblue')

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
onlyY <- Data[,c(11,12,13,14,15,16,17)] #extract only Y variables
res <- cor(onlyY, use="na.or.complete", method="pearson")
corrplot(res, method = "number",type = "upper", tl.col = "black")
res <- cor(Data, use="na.or.complete", method="pearson")
corrplot(res, method = "number",type = "upper", tl.col = "black")


#2.6.	Response vs X 
ggplot(Data, aes(x=X1, y=Response,shape=Group, color=Group)) + ggtitle("Plot of X1 vs Response") + geom_point(size=2, shape=Group) + scale_y_continuous(limits=c(0, 1)) +scale_x_continuous(name="X1", limits=c(0, 250))
ggplot(Data, aes(x=X2, y=Response,shape=Group, color=Group)) + ggtitle("Plot of X2 vs Response") + geom_point(size=2, shape=Group) + scale_y_continuous(limits=c(0, 1)) +scale_x_continuous(name="X2", limits=c(0, 250))
ggplot(Data, aes(x=X3, y=Response,shape=Group, color=Group)) + ggtitle("Plot of X3 vs Response") + geom_point(size=2, shape=Group) + scale_y_continuous(limits=c(0, 1)) +scale_x_continuous(name="X3", limits=c(0, 250))
ggplot(Data, aes(x=X4, y=Response,shape=Group, color=Group)) + ggtitle("Plot of X4 vs Response") + geom_point(size=2, shape=Group) + scale_y_continuous(limits=c(0, 1)) +scale_x_continuous(name="X4", limits=c(0, 250))
ggplot(Data, aes(x=X5, y=Response,shape=Group, color=Group)) + ggtitle("Plot of X5 vs Response") + geom_point(size=2, shape=Group) + scale_y_continuous(limits=c(0, 1)) +scale_x_continuous(name="X5", limits=c(0, 250))
ggplot(Data, aes(x=X6, y=Response,shape=Group, color=Group)) + ggtitle("Plot of X6 vs Response") + geom_point(size=2, shape=Group) + scale_y_continuous(limits=c(0, 1)) +scale_x_continuous(name="X6", limits=c(0, 250))
ggplot(Data, aes(x=X7, y=Response,shape=Group, color=Group)) + ggtitle("Plot of X7 vs Response") + geom_point(size=2, shape=Group) + scale_y_continuous(limits=c(0, 1)) +scale_x_continuous(name="X7", limits=c(0, 250))

