import os
import pandas as pd
#change to csv
directory = os.fsencode("D:\Trinity_DS\AdvancedSoftwareEngineernig\Project\Traffic\SCATS-Dublin")

path_dis="D:/Trinity_DS/AdvancedSoftwareEngineernig/Project/Traffic/SCATS-Dublin/rest_DIS/"
path_gps="D:/Trinity_DS/AdvancedSoftwareEngineernig/Project/Traffic/SCATS-Dublin/rest_gps/"

for file in os.listdir(path_gps):
	pre, ext = os.path.splitext(path_gps+"/"+file)
	os.rename(path_gps+file, pre + ".csv")

for file in os.listdir(path_dis):
	df = pd.read_csv(path_dis+file)
	df['date'] = pd.to_datetime(df['upperTime'],unit='s')
	df['Zone']=file[0:5]
	df.to_csv(path_dis+"merged_dis.csv", mode='a',index=False)
	print("File Completed"+file)
	

df['date'] = pd.to_datetime(df['upperTime'],unit='s')


import pandas as pd
path_dis="D:/Trinity_DS/AdvancedSoftwareEngineernig/Project/Traffic/SCATS-Dublin/rest_DIS/"
path_gps="D:/Trinity_DS/AdvancedSoftwareEngineernig/Project/Traffic/SCATS-Dublin/rest_gps/"
df = pd.read_csv(path_dis+"merged_dis1.csv")
df1 = df[['streetSegId','latd','longd','Zone']]
df1.head()
df1.drop_duplicates()
df1.to_csv(path_gps+"lat_long_Lookup.csv")

df[df.streetSegId = 'streetSegId']
df_inner = pd.merge(df, df_lookup, on='streetSegId', how='inner')

df_inner.to_csv(path_dis+"DIS_GPS_joined.csv")


df_inner.groupby(['date','zone'])['aggerateCount'].sum().reset_index()