library(jsonlite)
library(ggplot2)
library(mclust)

#read the file
json_file <- stream_in(file("Business_Toronto_Restaurant.json"))

#first part
length(unique(json_file$neighborhood))
# selecting relevant data 
d_name = c("longitude","latitude")
data = json_file[,d_name]
plot(data)

# fitting a two parameters model
fit2 <- Mclust(data, G = 8, modelNames = "VVV")
fit2$parameters$pro
fit2$parameters$mean

#plotting the classification
plot(fit2, what = "classification")

#plotting the uncertainity
plot(fit2, what = "uncertainty")

#multiple class
fit_data <- Mclust(data, G = 1:10)
plot(fit_data, what = "BIC")
fit_data$BIC
