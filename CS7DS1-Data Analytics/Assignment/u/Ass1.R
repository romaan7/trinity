library(mice)
# Dataset read
dataset = read.csv('siswave3v4impute3.csv')

# Normalizing
dataset$newcol = NA
for(j in 1:ncol(dataset)){
  if(dataset[j,'rearn']>0 && !is.na(dataset[j,'rearn'])){
    dataset[j,'newcol'] = 1
  }
  else if(dataset[j,'rearn'] == 0 && !is.na(dataset[j,'rearn'])){
    dataset[j,'newcol'] = 0
  }
  else if(is.na(dataset[j,'rearn'])){
    dataset[j,'newcol'] = NA
  }
}

# Dataset conversion to integer 
for(i in 1:ncol(dataset)){
  dataset[,i] = as.integer(dataset[,i])
}
# Cleaning Data
#for(k in 1:ncol(dataset)){
 # if(sum(is.na(dataset[,k])) > 1000){
  #  dataset[,k] = NULL
  #}
#}
# Correlation matrix
#cor_mat = cor(dataset,use = "pairwise.complete.obs")

# Selecting features
#feat = which(cor_mat[,'rearn']>0.9)
#names(feat)
feat = c('men','ag65m','white','immig2','educ_r','zwelfare','rearn')

#  imputing data for independent variables
dataset_feat = dataset[feat]
imp.dataset_feat = mice(dataset_feat,m=1,method='cart')
dataset_feat = complete(imp.dataset_feat)

# Adding the dependent variable
dataset_feat$newcol = dataset$newcol

# Making list of missing values index 
na_list = which(is.na(dataset_feat$newcol))
include = which(!is.na(dataset_feat$newcol))

# Dataset with only non missing values
dataset_logistic = dataset_feat[include,]

# Dataset woth only missing values
dataset_missing = dataset_feat[na_list,]

# Logistic Regression
## Fiting the model
temp_0 = match("rearn",names(dataset_logistic))
dataset_logistic_feed = dataset_logistic[,-temp_0]
fit = glm(formula=newcol~.,family=binomial(),data = dataset_logistic_feed)

## Predicting the values on the missing dataset
temp = length(feat)
alldata_dataset_missing = dataset_missing[,-temp]
alldata_dataset_missing = alldata_dataset_missing[,-temp_0]
predicted_temp = predict(fit,newdata = dataset_missing,type='response')
predicted_val = ifelse(predicted_temp > 0.5, "1", "0")

## Merging with the missing dataset
dataset_missing_final = dataset_missing
dataset_missing_final$newcol = predicted_val

# Consolidated dataset
dataset_final_1 = rbind(dataset_missing_final,dataset_logistic)

# data prep for linear
for(j in 1:ncol(dataset)){
  if(dataset_final_1[j,'newcol'] == 1 & !is.na(dataset_final_1[j,'rearn'])){
    dataset_final_1[j,'rearn'] = dataset_final_1[j,'rearn']
  }
  else if(dataset_final_1[j,'newcol'] == 0 & !is.na(dataset_final_1[j,'rearn'])){
    dataset_final_1[j,'rearn'] = 0
  }
  else if(dataset_final_1[j,'newcol'] == 1 & is.na(dataset_final_1[j,'rearn'])){
    dataset_final_1[j,'rearn'] = NA
  }
  else if(dataset[j,'newcol'] == 0 & is.na(dataset[j,'rearn'])){
    dataset_final_1[j,'rearn'] = 0
  }
  
}

### split into missing and training
## Making list of missing values index 
na_list_linear = which(is.na(dataset_final_1$rearn))
include_linear = which(!is.na(dataset_final_1$rearn))

## Dataset with only non missing values
dataset_linear = dataset_final_1[include,]

## Dataset woth only missing values
dataset_missing_linear = dataset_final_1[na_list,]

# Making the model
temp_3 = match("newcol",names(dataset_linear))
dataset_linear_feed = dataset_linear[,-temp_3]
model_linear = lm(rearn~.,data = dataset_linear_feed)

# Predicting the values
temp_1 = match("rearn",names(dataset_missing_linear))
alldata_dataset_missing_linear = dataset_missing_linear[,-temp_1]
temp_4 = match("newcol",names(dataset_logistic))
alldata_dataset_missing_linear = alldata_dataset_missing_linear[,-temp_4]
linear_val = predict.lm(model_linear,newdata = alldata_dataset_missing_linear)

# Final dataset
dataset_missing_linear$rearn = linear_val
dataset_final = rbind(dataset_missing,dataset_linear)

# Mean of earning from final data
mean_final = mean(dataset_final$rearn)
mean_final = as.integer(mean_final)
# standard deviation of earning from final data
standard_deviation = sd(dataset_final$rearn)
standard_deviation = as.integer(standard_deviation)
sprintf('The mean is %s and the standard deviation is %s',mean_final,standard_deviation)

