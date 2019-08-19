import numpy as np
import matplotlib.pyplot as plt

def distance(X,mu):
  # calculate the euclidean distance between numpy arrays X and mu
  d = (((X-mu)**2).sum(axis=-1))
  return d
	
def findClosestCentres(X,mu):
  # finds the centre in mu closest to each point in X
  (k,n)=mu.shape # k is number of centres
  (m,n)=X.shape # m is number of data points
  C=list()
  for j in range(k):
    C.append(list()) 
  for index_of_X, element_of_X in enumerate(X):
    C[np.argmin(distance(np.full((k,n), element_of_X), mu))].append(index_of_X)
  return C
  
def updateCentres(X,C):
  # updates the centres to be the average of the points closest to it.  
  k=len(C) # k is number of centres
  (m,n)=X.shape # n is number of features
  mu=np.zeros((k,n))
  for j in range(k):
    mu[j] = X[C[j]].mean(axis=0)
  return mu

def plotData(X,C,mu):
  # plot the data, coloured according to which centre is closest. and also plot the centres themselves
  fig, ax = plt.subplots(figsize=(12,8))
  ax.scatter(X[C[0],0], X[C[0],1], c='c', marker='o')
  ax.scatter(X[C[1],0], X[C[1],1], c='b', marker='o')
  ax.scatter(X[C[2],0], X[C[2],1], c='g', marker='o')
  # plot centres
  ax.scatter(mu[:,0], mu[:,1], c='r', marker='x', s=100,label='centres')
  ax.set_xlabel('x1')
  ax.set_ylabel('x2')  
  ax.legend()
  fig.savefig('graph.png') 
  
def main():
  print('testing the distance function ...')
  print(distance(np.array([[1,2],[3,4]]), np.array([[1,2],[1,2]])))
  print('expected output is [0,8]')
  
  print('testing the findClosestCentres function ...')
  print(findClosestCentres(np.array([[1,2],[3,4],[0.9,1.8]]),np.array([[1,2],[2.5,3.5]])))
  print('expected output is [[0,2],[1]]')

  print('testing the updateCentres function ...')
  print(updateCentres(np.array([[1,2],[3,4],[0.9,1.8]]),[[0,2],[1]]))
  print('expected output is [[0.95,1.9],[3,4]]')

  print('loading test data ...')
  X=np.loadtxt('data.txt')
  [m,n]=X.shape
  iters=10
  k=3
  print('initialising centres ...')
  init_points = np.random.choice(m, k, replace=False)
  mu=X[init_points,:] # initialise centres randomly
  print('running k-means algorithm ...')
  for i in range(iters):
    C=findClosestCentres(X,mu)
    mu=updateCentres(X,C)
  print('plotting output')
  plotData(X,C,mu)  

  # Optional Exercise: Image compression with k-means  (ungraded)  
  image_X=np.loadtxt('image.txt')
# convert to values between 0 and 1
  image_X=np.array(image_X, dtype=np.float64) / 255 
  image_X=image_X.reshape(427,640,3)
  fig, ax = plt.subplots(figsize=(12,8))
  ax.axis('off')
  ax.imshow(image_X)
  fig.savefig('image.png') 
  
  image_X=image_X.reshape(427*640,3)

  [image_m,n]=image_X.shape
  image_iters = 5
  image_k = 16
  image_init_points = np.random.choice(image_m, image_k, replace=False)
  image_mu=image_X[image_init_points,:] 
  for i in range(image_iters):
    image_C=findClosestCentres(image_X,image_mu)
    image_mu=updateCentres(image_X,image_C)
  print('plotting output')

  for j in range(image_k):
    image_X[image_C[j],:]=image_mu[j,:]
  image_X=image_X.reshape(427,640,3)
  fig, ax = plt.subplots(figsize=(12,8))
  ax.axis('off')
  ax.imshow(image_X)
  fig.savefig('compressed.png') 


if __name__ == '__main__':
  main()