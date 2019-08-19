library(jsonlite)
library(ggplot2)
library(MCMCpack)
library(dplyr)
library(gridExtra)
library(grid)
library("glmnet")
library("tm") 
library("SnowballC")
library("wordcloud") 
library("RColorBrewer") 
library("RCurl") 
library("XML")
library(rquery)

#read the file
json_file_1 = stream_in(file("Business_Toronto_Restaurant.json"))
json_file_2 = stream_in(file("Review_Toronto_Restaurant.json"))

x = unlist(json_file_1$categories)
write.table(x, "x", sep="\t", col.names = F, row.names = F) 
res<-rquery.wordcloud(x, type ="file", lang = "english",
                      colorPalette = "RdBu")
# Data Exploration
l = matrix(c(length(json_file_2$useful[json_file_2$useful >= 3]),length(json_file_2$useful[json_file_2$useful >= 4]),length(json_file_2$useful[json_file_2$useful >= 5]),length(json_file_2$useful[json_file_2$useful >= 6]),length(json_file_2$useful[json_file_2$useful >= 7])),ncol=5)
colnames(l) = c("Atleast 3 People","Atleast 4 People","Atleast 5 People","Atleast 6 People","Atleast 7 People")
barplot(as.table(l),ylab = "Total Count of Reviews")
print(length(unique(json_file_2$business_id)))

# Create a new data frame which has a new column with number of useful counts greater than 5
for(i in 1:nrow(json_file_2)){
 if(json_file_2$useful[i] >=2){
   json_file_2$usefulind[i] = 1
 }
  else{
    json_file_2$usefulind[i] = 0
  }
}

df = data.frame(userind = aggregate(json_file_2$usefulind, by=list(Category=json_file_2$business_id), FUN=sum))
names(df) <- c("business_id", "usefulind")

ndf = merge(json_file_1,df,by = "business_id")


# flatten out the df
ndf = flatten(ndf)

# remove columns which has more than 80% NA values
temp = as.integer((25/100)*7051)
temp_list = list()
for(i in 1:ncol(ndf)){
  if(sum(is.na(ndf[i]))>temp){
    b = i
    temp_list = c(temp_list,b)
  }
}

tempdf <- ndf[ -as.numeric(temp_list) ]
tempdf = subset(tempdf,select = -c(business_id,address,postal_code,name,city,latitude,longitude,state))

#factorise attributes
tempdf[7:38] = lapply(tempdf[7:38],factor)

#handling categories
cat_total <- unlist(tempdf$categories)
class(cat_total)
length(cat_total)
## Repeated non-numeric values should have 'factor' class
cat_total <- factor(cat_total)
nlevels(cat_total)
cat_total <- unlist(tempdf$categories)
## Which categories are most popular?
cat_names_sort <- sort(table(cat_total), decreasing = TRUE)
t1 <- ttheme_default(core=list(
  fg_params=list(fontface=c(rep("plain", 4), "bold.italic")),
  bg_params = list(fill=c(rep(c("grey95", "grey90"),
                              length.out=4), "#6BAED6"),
                   alpha = rep(c(1,0.5), each=5))
))
random = as.data.frame(head(cat_names_sort, 10))
grid.table((random), theme = t1)
#grid.table(d)
cat_names <- names(cat_names_sort)[-1] ## 1 is Restaurants - we don't need this
cat_bus_ind_mat <- sapply(tempdf$categories, function(y) as.numeric(cat_names %in% y))
cat_bus_ind_mat <- t(cat_bus_ind_mat)
colnames(cat_bus_ind_mat) <- cat_names
tempdf <- cbind(tempdf, cat_bus_ind_mat)

# complete cases
tempdf = subset(tempdf,select=-c(categories))
t <- tempdf[complete.cases(tempdf), ]

#logistic regression
glm1 <- glm(is_open ~ ., data = t, family = binomial())
pred_glm <- plogis(predict(glm1))
boxplot(pred_glm  ~ t$is_open)

#calulate accuracy
confusin_matrix = table(pred_glm > 0.5, t$is_open)
acc = (confusin_matrix[1]+confusin_matrix[4])/sum(confusin_matrix)

#further exploration
lm1 <- lm(is_open~., data = t)
x = summary(lm1)

#new model with relevent attributes
z= x$coefficients[,4]
z = as.data.frame(z)
rownamesVector <-rownames(z)
z1 <- data.frame(rownamesVector,c(z$z))
z1significant <- z1[which(z1$c.z.z. < 0.01),]
significantcols = z1significant$rownamesVector
tempdf_new = subset(t,select = significantcols)
tempdf_new$is_open = t$is_open
glm2 <- glm(is_open ~ ., data = tempdf_new, family = binomial())
pred_glm2 <- plogis(predict(glm2))
confusin_matrix2 = table(pred_glm2 > 0.5, tempdf_new$is_open)
acc2 = (confusin_matrix2[1]+confusin_matrix2[4])/sum(confusin_matrix2)
boxplot(pred_glm2  ~ t$is_open)
#using mean imputation
filtered = tempdf
for(i in 1:ncol(filtered)) {
  filtered[ , i][is.na(filtered[ , i])] <- mean(filtered[ , i], na.rm = TRUE)
}
colSums(is.na(filtered))
filtered = filtered[-c(6:37)]
#filtered = subset(filtered,select = -c(attributes.BusinessParking.validated,attributes.Ambience.intimate,attributes.RestaurantsDelivery,attributes.BusinessParking.lot,attributes.RestaurantsGoodForGroups, attributes.Ambience.upscale,attributes.Ambience.classy))
glm3 <- glm(is_open ~ ., data = filtered, family = binomial())
pred_glm3 <- plogis(predict(glm3))
confusin_matrix3 = table(pred_glm3 > 0.5, filtered$is_open)
acc3 = (confusin_matrix3[1]+confusin_matrix3[4])/sum(confusin_matrix3)
boxplot(pred_glm3  ~ filtered$is_open)

# lasso regression
t_new = t
t$neighborhood = as.factor(t$neighborhood)
y_spam <- as.factor(as.numeric(t$is_open) - 1)
table(y_spam, t$is_open)
#x_spam <- as.matrix(t[, -4])

#x_spam = as.matrix(sapply(t[, -4], as.numeric))  
#x_spam <- apply(x_spam, 2, scale)
#x_spam = complete.cases(x_spam)

#cor(x_spam)
x_spam <- model.matrix(is_open~., t)[,-1]
spam_fit <- glmnet(x_spam, y_spam, family = "binomial")
plot(spam_fit, label = FALSE)
spam_fitcv <- cv.glmnet(x_spam, y_spam, family = "binomial")
plot(spam_fitcv)
pred1 <- predict(spam_fitcv, newx = x_spam, s="lambda.min", type = "class")
confusion_matrix4 = table(pred1, y_spam)
acc4 = (confusion_matrix4[1]+confusion_matrix4[4])/sum(confusion_matrix4)
pred2 <- predict(spam_fitcv, newx = x_spam, s="lambda.1se", type = "response")
boxplot(pred2 ~ y_spam)
acc_f = data.frame(acc,acc2,acc3,acc4)
colnames(acc_f) = c("Model with NA Dropped(without feature selection)","Model with NA Dropped(with feature selection)","Model with mean imputation","Model with Lasso Regression")
grid.table((acc_f))
