library(lattice)
library(ggplot2)
library(caret)
#packages for preprocess
library(rpart)
library(rpart.plot)
#packages for decision tree
library(mlbench)
#package with data sample
data("PimaIndiansDiabetes2",package = 'mlbench')
data <- PimaIndiansDiabetes2
head(data)
summary(data)
preProValues <- preProcess(data[,-9],method = c("center","scale"))
scaleddata <- predict(preProValues,data[,-9])
#Normalization
preProcbox <- preProcess(scaleddata,method = c("YeoJohnson"))
boxdata <- predict(preProcbox,scaleddata)
#YeoJohnson Transfer (to norm distribution)
preProcimp <- preProcess(boxdata,method = "bagImpute")
procdata <- predict(preProcimp,boxdata)
#Missing Values
procdata$class <- data[,9]
head(procdata)

summary(procdata)
featurePlot(scaleddata,data[,9],plot='box')
rpartModel <- rpart(class~.,data=procdata,control = rpart.control(cp=0))
#Tree growth without limitation
rpart.plot(rpartModel)
#Print tree plot
plotcp(rpartModel)
#Print CP value Vs. tree levels 
rpartModel$cptable
