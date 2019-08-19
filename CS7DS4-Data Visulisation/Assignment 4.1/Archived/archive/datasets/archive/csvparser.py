import pandas
from pandas import DataFrame, read_csv
from collections import Counter
import numpy

#Quick script to merge data... Do some manual clean up later on the resulting .csv file.
#unfortunately, we have duplicate data in our rows in one of our datasets that is intended 
#to be combined with the 'country' column to form the key

population_DataFrame = pandas.read_csv('population.csv', index_col=0)

population_dictionary = {}
for row in population_DataFrame.index: #row is country
    for column in population_DataFrame.columns: #column is year
        population_dictionary[row+','+column] = population_DataFrame.at[row,column]

continent_DataFrame = pandas.read_csv('Continents.csv', index_col=0) #Default index
continent_dictionary = {}
for row in continent_DataFrame.index: #row is country
    continent_dictionary[row] = continent_DataFrame.at[row,'continentName']
#populate the continent dictionary with country names as keys, continent names as values

refugee_DataFrame = pandas.read_csv('check.csv', index_col=['Year', 'Country of Residence'])

for i in xrange(0, len(refugee_DataFrame.index)):
    key = str(refugee_DataFrame.index[i][1])+','+str(refugee_DataFrame.index[i][0])
    key2 = refugee_DataFrame.index[i][1]
    #print(refugee_DataFrame.index[i])
    refugee_DataFrame.ix[str(refugee_DataFrame.index[i]), 'Population'] = 0 #initialize to 0, for those with no info on population
    refugee_DataFrame.ix[str(refugee_DataFrame.index[i]), 'Continent'] = 'N/A'
    if (key in population_dictionary):
       
        refugee_DataFrame.ix[str(refugee_DataFrame.index[i]), 'Population'] = population_dictionary[key]
        
        #print(refugee_DataFrame.ix[refugee_DataFrame.index[i], refugee_DataFrame.iat[i,0]])
        #print(refugee_DataFrame.iat[i,0]+','+str(refugee_DataFrame.index[i])) 
    if (key2 in continent_dictionary):
        refugee_DataFrame.ix[str(refugee_DataFrame.index[i]), 'Continent'] = continent_dictionary[key2]

#print(refugee_DataFrame)
refugee_DataFrame.to_csv("out.csv", sep='\t')
 
#out.csv will have a bunch of tuples appended to the end, 
#just copy and paste the populations and continents column and move it to the top. Order is preserved.

#refugee_DataFrame['Population of Country']=' '.join(refugee_DataFrame['Country / territory of asylum/residence']+','+str(refugee_DataFrame.index[0]))
