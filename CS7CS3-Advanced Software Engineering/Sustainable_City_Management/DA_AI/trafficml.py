
# coding: utf-8

# In[133]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt   #Data visualisation libraries 
import seaborn as sns
get_ipython().run_line_magic('matplotlib', 'inline')


# In[152]:


predtraffic = pd.read_csv('scity.csv')
predtraffic.head()
predtraffic.info()
predtraffic.describe()
predtraffic.columns


# In[153]:


sns.pairplot(predtraffic)


# In[136]:


sns.distplot(predtraffic['pred'])


# In[137]:


predtraffic.corr()


# In[138]:


predtraffic.columns


# In[154]:


X = predtraffic[['date', 'month', 'year',
               'hour', 'min','timeinsec']]
y = predtraffic['pred']


# In[155]:


from sklearn.model_selection import train_test_split


# In[156]:


X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.4, random_state=101)


# In[157]:


from sklearn.linear_model import LinearRegression
lm = LinearRegression()
lm.fit(X_train,y_train)


# In[167]:


lm.score(X_train,y_train)


# In[158]:


prredd = lm.predict(X_test)


# In[159]:


plt.scatter(y_test,prredd)


# In[160]:


datafile = pd.read_csv('scitypred.csv')


# In[161]:


pres = lm.predict(datafile)


# In[162]:


pres


# In[129]:


predictions


# In[108]:





# In[163]:


datafile['predvalue']=pres


# In[164]:


datafile.to_csv("predvalscity.csv")

