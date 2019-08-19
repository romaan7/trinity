library(ggplot2)

#Check and set the present working directory for R
getwd()
setwd("C:/Users/romaa/Trinity/CS7DS1-Data Analytics/Assignment")

#Read the CSV file into data frame full_data
#full_data <- read.csv("siswave3v4impute3.csv", header = TRUE)[,c('sex','race', 'educ_r', 'r_age', 'police','immig','rearn')]
full_data <- read.csv("siswave3v4impute3.csv", header = TRUE)
View(full_data)
attach(full_data) #attach R objects to search path
n <- nrow (full_data)

plot(rearn, age)

# VARIABLES 
# rearn - candidate's earnings
# tearn - partners's earnings
# Function to fix(simplify) the earning variables
na.fix <- function (a) {
  ifelse (a<0 | a==999999, NA, a)
}
earnings <- na.fix(rearn) + na.fix(tearn)
earnings <- earnings/1000

# Take only some rows to see missing data values.
cbind (Data$sex, Data$race, Data$educ_r, Data$r_age, earnings, Data$police)[91:95,]

# Function to impute missing values of earnings based on the observed data for this variable
random.imp <- function (a){
  missing <- is.na(a)
  n.missing <- sum(missing)
  a.obs <- a[!missing]
  imputed <- a
  imputed[missing] <- sample (a.obs, n.missing, replace=TRUE)
  return (imputed)
}

#Function to top code the earnings to $100,000 
#topcoding reduces the sensitivity of the results to the highest values, which
#in this survey go up to the millions.
topcode <- function (a, top){
  return (ifelse (a>top, top, a))
}

earnings.imp <- random.imp (earnings) #IMPUTE
earnings.top <- topcode (earnings, 100) # earnings are in $thousands

#Plot histogram of earnings vs Observerd
hist (earnings.top[earnings>0], xlab = "earnings", main = "Observed earnings (excluding 0's)") 

#calculate each variable
white <- ifelse (race==1, 1, 0)
white[is.na(race)] <- 0
male <- ifelse (sex==1, 1, 0)
over65 <- ifelse (r_age>65, 1, 0)
immig[is.na(immig)] <- 0
educ_r[is.na(educ_r)] <- 2.5
workhrs.top <- topcode (workhrs, 40)

#Function to calculate abs value
is.any <- function (a) {
  any.a <- ifelse (a>0, 1, 0)
  any.a[is.na(a)] <- 0
  return(any.a)
}

workmos <- workmos
earnings[workmos==0] <- 0
any.ssi <- is.any (ssi)
any.welfare <- is.any (welfare)
any.charity <- is.any (charity)

#Create Data fram of above variables.
sis <- data.frame (cbind (earnings, earnings.top, male, over65, white,immig, educ_r, workmos, workhrs.top, any.ssi, any.welfare, any.charity))

#fit a regression to positive values of earnings
lm.imp.1 <- lm (earnings ~ male + over65 + white + immig + educ_r + workmos + workhrs.top + any.ssi + any.welfare + any.charity,data=sis, subset=earnings>0)

#predictions for the data
pred.1 <- predict (lm.imp.1, sis)

#Function to impute predicted values into missing values.
impute <- function (a, a.impute){
  ifelse (is.na(a), a.impute, a)
}

#compute missing earnings
earnings.imp.1 <- impute (earnings, pred.1)
View(earnings.imp.1)

#transforming and top coding
lm.imp.2.sqrt <- lm (I(sqrt(earnings.top)) ~ male + over65 + white + immig + educ_r + workmos + workhrs.top + any.ssi + any.welfare + any.charity, data=sis, subset=earnings>0)
pred.2.sqrt <- predict (lm.imp.2.sqrt, sis)
pred.2 <- topcode (pred.2.sqrt^2, 100)
earnings.imp.2 <- impute (earnings.top, pred.2)


#Display summery of R mempry and calls
summary(lm.imp.2.sqrt)
lm(formula = I(sqrt(earnings.top)) ~ male + over65 + white +
       immig + educ_r + workmos + workhrs.top + any.ssi + any.welfare +
       any.charity, data = sis, subset = earnings > 0)

#Display of histogram 
hist (earnings.imp.2[is.na(earnings)],xlab = "earnings", main = "Imputed earnings")
