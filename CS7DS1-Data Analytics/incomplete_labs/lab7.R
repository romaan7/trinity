# inverse transfrom sampling
num.samples <-  2000
U           <-  runif(num.samples)
Lnam        <- 1
X           <- -log(1-U)/Lnam
print(X)
# plot
hist(X, freq=F, xlab='X', main='Generating Exponential R.V.')
curve(dexp(x, rate=2) , 0, 3, lwd=2, xlab = "", ylab = "", add = T)


#gamma distribution sampling
Y <- rgamma (n = X, shape = 1, scale = 5)
ggplot() +
  aes(x=Y) +
  geom_histogram(fill='red', bins=100)

hist(Y, freq=F, xlab='Y', main='Generating Exponential R.V.')

#gamma distribution sampling
Z <- rgamma (n = X, shape = 3.5, scale = 5)
ggplot() +
  aes(x=Z) +
  geom_histogram(fill='red', bins=100)

hist(Z, freq=F, xlab='Y', main='Generating Exponential R.V.')
