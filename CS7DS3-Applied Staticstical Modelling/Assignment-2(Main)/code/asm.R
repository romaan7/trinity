library(jsonlite)
library(ggplot2)
library(MCMCpack)
library(RColorBrewer)


#read the file
json_file <- stream_in(file("data/Business_Toronto_Restaurant.json"))

#select data 
data = json_file[json_file$neighborhood == "Etobicoke"|json_file$neighborhood == "Scarborough",]
#x2 = json_file[,]
#data = rbind(x1,x2)
data = data[data$is_open == 1,]
data1 = data[grepl("Indian",data$categories)==TRUE,]
data_compare = data1[c("business_id","name","stars","review_count","neighborhood")]
data_compare$neighborhood[data_compare$neighborhood == "Etobicoke"] = 1
data_compare$neighborhood[data_compare$neighborhood == "Scarborough"] = 2

#First Part
#creating a box plot
ggplot(data_compare) + geom_boxplot(aes(neighborhood, stars, fill = neighborhood)) + geom_jitter(aes(neighborhood, stars, shape = data_compare$neighborhood))

# Checking the mean, median and sd of the data
mean = tapply(data_compare$stars, data_compare$neighborhood, mean) 
tapply(data_compare$stars, data_compare$neighborhood, median)
sd = tapply(data_compare$stars, data_compare$neighborhood, sd)

#t test
t.test(stars ~ neighborhood, data=data_compare, var.equal = TRUE)

#Compare the means
b0 = (2.5 / (1.25^2))
a0 = b0*2.5
compare_2_gibbs <- function(y, ind, mu0 = 2.5, tau0 = 1/(1.25^2), del0 = 0, gamma0 = 1/(1.25^2), a0 = 4, b0 = 1.6, maxiter = 5000)
{
  y1 <- y[ind == 1]
  y2 <- y[ind == 2]
  
  n1 <- length(y1) 
  n2 <- length(y2)
  
  ##### starting values
  mu <- (mean(y1) + mean(y2)) / 2
  del <- (mean(y1) - mean(y2)) / 2
  
  mat_store <- matrix(0, nrow = maxiter, ncol = 3)
  #####
  
  ##### Gibbs sampler
  an <- a0 + (n1 + n2)/2
  
  for(s in 1 : maxiter) 
  {
    
    ##update tau
    bn <- b0 + 0.5 * (sum((y1 - mu - del) ^ 2) + sum((y2 - mu + del) ^ 2))
    tau <- rgamma(1, an, bn)
    ##
    
    ##update mu
    taun <-  tau0 + tau * (n1 + n2)
    mun <- (tau0 * mu0 + tau * (sum(y1 - del) + sum(y2 + del))) / taun
    mu <- rnorm(1, mun, sqrt(1/taun))
    ##
    
    ##update del
    gamman <-  gamma0 + tau*(n1 + n2)
    deln <- ( del0 * gamma0 + tau * (sum(y1 - mu) - sum(y2 - mu))) / gamman
    del<-rnorm(1, deln, sqrt(1/gamman))
    ##
    
    ## store parameter values
    mat_store[s, ] <- c(mu, del, tau)
  }
  colnames(mat_store) <- c("mu", "del", "tau")
  return(mat_store)
}

# burn in and thinning
fit <- compare_2_gibbs(data_compare$stars, as.factor(data_compare$neighborhood))
plot(as.mcmc(fit))
raftery.diag(as.mcmc(fit))

#posterior mean and sd
apply(fit, 2, mean)
apply(fit, 2, sd)

# to interperate tau we convert it to sd
mean(1/sqrt(fit[, 3])) 
sd(1/sqrt(fit[, 3]))

# calculating probablilty 
y1_sim <- rnorm(5000, fit[, 1] + fit[, 2], sd = 1/sqrt(fit[, 3]))
y2_sim <- rnorm(5000, fit[, 1] - fit[, 2], sd = 1/sqrt(fit[, 3]))
ggplot(data.frame(y_sim_diff = y1_sim - y2_sim), aes(x=y_sim_diff)) + stat_bin(aes(y_sim_diff)) +geom_histogram(color="blue", fill="white")

mean(y1_sim > y2_sim)
ggplot(data.frame(y1_sim, y2_sim)) + geom_point(color='#8dd3c7',fill="white",aes(y1_sim, y2_sim), alpha = 0.3) + geom_abline(slope = 1, intercept = 0) 

# how much better?
(mean(y2_sim) - mean(y1_sim))

#First Part end
#Second Part 
#Data preparation
data_multi = json_file[json_file$is_open == 1,]
data_multi_test_1 = data_multi[!data_multi$neighborhood=="",]
data_multi_test_1 = data_multi_test_1[!row.names(data_multi_test_1)%in%c("219","2637"),]
#data_multi$neighborhood = factor(data_multi$neighborhood)
#nlevels(data_multi$neighborhood)

colorCount = 72
getPalette = getPalette = colorRampPalette(brewer.pal(12, "Accent"))
#plotting levels
ggplot(data_multi) + geom_boxplot(aes(x = reorder(neighborhood, stars, median), stars, fill = reorder(neighborhood, stars, median)), show.legend=FALSE)  +   scale_fill_manual(values = getPalette(colourCount))

ggplot(data_multi, aes(x = reorder(neighborhood, neighborhood, length))) + stat_count()
ggplot(data_multi, aes(stars)) + stat_bin(bins = 9)
ggplot(data.frame(size = tapply(data_multi$stars, data_multi$neighborhood, length), mean_score = tapply(data_multi$stars, data_multi$neighborhood, mean)), aes(size, mean_score)) + geom_point()

#gibbs sampler for second part
compare_m_gibbs <- function(y, ind, maxiter = 5000)
{
  
  ### weakly informative priors
  a0 <- 4 ; b0 <- 1.6 ## tau_w hyperparameters
  eta0 <-4 ; t0 <- 1.6 ## tau_b hyperparameters
  mu0<-2.5 ; gamma0 <- 1/(1.25^2)
  ###
  
  ### starting values
  m <- nlevels(ind)
  ybar <- theta <- tapply(y, ind, mean)
  tau_w <- mean(1 / tapply(y, ind, var)) ##within group precision
  mu <- mean(theta)
  tau_b <-var(theta) ##between group precision
  n_m <- tapply(y, ind, length)
  an <- a0 + sum(n_m)/2
  ###
  
  ### setup MCMC
  theta_mat <- matrix(0, nrow=maxiter, ncol=m)
  mat_store <- matrix(0, nrow=maxiter, ncol=3)
  ###
  
  ### MCMC algorithm
  for(s in 1:maxiter) 
  {
    
    # sample new values of the thetas
    for(j in 1:m) 
    {
      taun <- n_m[j] * tau_w + tau_b
      thetan <- (ybar[j] * n_m[j] * tau_w + mu * tau_b) / taun
      theta[j]<-rnorm(1, thetan, 1/sqrt(taun))
    }
    
    #sample new value of tau_w
    ss <- 0
    for(j in 1:m){
      ss <- ss + sum((y[ind == j] - theta[j])^2)
    }
    bn <- b0 + ss/2
    tau_w <- rgamma(1, an, bn)
    
    #sample a new value of mu
    gammam <- m * tau_b + gamma0
    mum <- (mean(theta) * m * tau_b + mu0 * gamma0) / gammam
    mu <- rnorm(1, mum, 1/ sqrt(gammam)) 
    
    # sample a new value of tau_b
    etam <- eta0 + m/2
    tm <- t0 + sum((theta-mu)^2)/2
    tau_b <- rgamma(1, etam, tm)
    
    #store results
    theta_mat[s,] <- theta
    mat_store[s, ] <- c(mu, tau_w, tau_b)
  }
  colnames(mat_store) <- c("mu", "tau_w", "tau_b")
  return(list(params = mat_store, theta = theta_mat))
}

#fitting the model
data_multi_test_1$ind = as.numeric(factor(data_multi_test_1$neighborhood))
fit2 <- compare_m_gibbs(data_multi_test_1$stars, as.factor(data_multi_test_1$ind))

#checking values
#test = tapply(data_multi$stars, data_multi$neighborhood, length)

apply(fit2$params, 2, mean)
apply(fit2$params, 2, sd)
mean(1/sqrt(fit2$params[, 3]))
sd(1/sqrt(fit2$params[, 3]))
theta_hat <- apply(fit2$theta, 2, mean)
ggplot(data.frame(size = tapply(data_multi_test_1$stars, as.factor(data_multi_test_1$ind), length), theta_hat = theta_hat), aes(size, theta_hat)) + geom_point()

#data_multi_test = data_multi[!data_multi$neighborhood=="Cooksville",]
#data_multi_test_1 = data_multi_test[!data_multi$neighborhood=="Meadowvale Village",]
#row.names(data_multi[data_multi$neighborhood=="Meadowvale Village",])
