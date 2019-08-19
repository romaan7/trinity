# -*- coding: utf-8 -*-
"""
Created on Wed Apr  3 13:13:34 2019

@author: bhavesh2429
"""

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from sklearn import datasets, linear_model
from sklearn.metrics import mean_squared_error, r2_score
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn import metrics
from sklearn.metrics import accuracy_score, f1_score, precision_score
from sklearn import neighbors, datasets
from sklearn.naive_bayes import GaussianNB
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier

income = pd.read_csv('F:/TCD_HT/ASE/zones/zones2.csv')
income.describe()
income.dtypes

dataip = income.iloc[:,1:]
dataip = pd.DataFrame(dataip)
#outputs
dataop = income.iloc[:,0]
dataop = pd.DataFrame(dataop)
#Uncomment this line for data size = 16k
X_train, X_test, y_train, y_test = train_test_split(dataip, dataop, train_size=0.9)


knn=neighbors.KNeighborsClassifier()
model2 = knn.fit(X_train, y_train)
expected = y_test
predicted = model2.predict(X_test)
accuracy1 = f1_score(expected, predicted, average = 'weighted')

bus = pd.read_csv('F:/TCD_HT/ASE/zones/bus.csv')
bus = pd.Dataframe(bus)

bus_test = bus.iloc[:,3:4]
bus_test[1] =  bus.iloc[:,2:3]

zones = model2.predict(bus_test)
bus_test[2] = zones
bus_test
#bus_test.to_csv('F:/TCD_HT/ASE/zones/busZ.csv')



bus[5] = zones
#bus_test.to_csv('F:/TCD_HT/ASE/zones/busZ1.csv')
bus.to_csv('F:/TCD_HT/ASE/zones/busZ1.csv')

##BIKE 
bike = pd.read_csv('F:/TCD_HT/ASE/zones/bike.csv')
bike = pd.DataFrame(bike)
bike_test = bike.iloc[:,1:3]
zones = model2.predict(bike_test)

bike_test[2] = zones
bike_test
bike[3] = zones
bike
bike.to_csv('F:/TCD_HT/ASE/zones/bikeZ.csv')


##PARKING
parking = pd.read_csv('F:/TCD_HT/ASE/zones/Parking.csv')
parking = pd.DataFrame(parking)
parking_test = parking.iloc[:,6:8]
zones_parking = model2.predict(parking_test)
parking_test[2] = zones_parking
parking[9] = zones_parking
parking.to_csv('F:/TCD_HT/ASE/zones/parkingZ.csv')


##BUS stop data
bus_stop = pd.read_csv('F:/TCD_HT/ASE/zones/bus_stop.csv')
bus_stop = pd.DataFrame(bus_stop)

busstop_test = bus_stop.iloc[:,2:4]

zones_stop = model2.predict(busstop_test)
busstop_test[2] = zones_stop
bus_stop['zones'] = zones_stop
bus_stop.to_csv('F:/TCD_HT/ASE/zones/bus_stopZoned.csv')



