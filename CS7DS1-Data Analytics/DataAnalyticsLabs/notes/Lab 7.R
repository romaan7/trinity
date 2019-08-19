#method of inversion
#U(0,1)=>bullet:inv.relation=>Exp(lambda)

#single sample

lambda <- 1 #define the rate
u <- runif (1) #generate U(0,1) a sample
x <- - log (1-u)/lambda #define relation & transform to exp
x #output to screen


#Q1.
#multiple sample

n <- 2000 #smaple size
lambda <- 1
u <- runif (n)
x <- - log(1-u)/lambda
x

#wraping our code inside a function

inv.exp<-function (n,lambda){
u <- runif(n)
x<- -log(1-u)/lambda
x 
}
inv.exp(n=2000, lambda=1)


#checking out a histogram of sampled values(is it from EXP?)

x <- inv.exp (n=20000, lambda=1)
hist (x, freq=FALSE) #plot a histogram
t <- 0:150/10 #creating a sequence(from 0 to 15)
lines (t, dexp (t, rate=0.5), lwd=2) #adding the density(y-axis) to the histogram

#Smirnov test how reliable? our sample is from an EXP(0.5)?

ks.test (x, pexp, rate=0.5)

#generating a single sample from Gamma

#Q2.

k<-5 #no.of events (x is waiting time until...)
lambda <-1 #average no.of event/given time
x<-inv.exp(n=k, lambda=lambda)
y <- sum (x)
y

#generating multiple samples from Gamma systematically by creating (n x k)matrix 

n <- 2000 # no.of rows=> no.of samples?
k <- 5 # no.of columns
lambda <- 1
x <- matrix(inv.exp (n=n*k, lambda=lambda), ncol=k)
y <- apply(x,1,sum) #then add up each row
y 


#wrap this code inside a finction

inv.gamma.int  <- function(n, k, lambda) {
x <- matrix (inv.exp(n=n*k, lambda=lambda), ncol=k)
apply (x,1,sum)
}
y <- inv.gamma.int (20, 4, 1)
y


# Q3.

inv.gamma.int  <- function(n, k, lambda) {
x <- matrix (inv.exp(n=n*k, lambda=lambda), ncol=k)
apply (x,1,sum)
}

y <- inv.gamma.int (2000, 5, 3)
hist (y, freq=FALSE, main= "Histogram of 2000 samples of G(k=3,lambda=3)")
t <- 0:150/5
lines (t, dgamma (t, shape=5, rate=3))

ks.test (y, pgamma, shape=5,rate=3)



#rejection practice

t <- 0:500 /100
x=1/gamma(3.5)*t^2.5*3^3.5*exp(-3*t)
y=1/gamma(3)*t^2*2^3*exp(-2*t)
k=x/y
m=k[c(2:501)]
M=max(m)
M

inv.exp <- function(n,lambda ) {
  u <- runif (n)
  t <- -log(1-u)/lambda
  t
}
rejection  =  function(n){
  r=NULL
  i=0
  while (i<n){
    ti <- inv.exp (3, 2)
    x=sum(ti)
    f <- ((x^2.5)*(exp(-3*x))*3^3.5)*(1/gamma(3.5))
    g <- 1.5087*((x^2)*(exp(-2*x))*2^3)*(1/gamma(3))
    y= runif(1,0,g)
    if(y <f)  i=i+1
    r[i]=x
  }
  r
}

rejection(2000);
s <- rejection(2000);
hist(s, freq=FALSE, main="Histogram of 2000 samples of G(k=3.5,lambda=3)");
ks.test( s , pgamma(3.5,3))