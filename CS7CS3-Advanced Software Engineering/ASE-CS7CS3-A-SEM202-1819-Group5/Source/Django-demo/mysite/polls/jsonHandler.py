import requests, json

def getLatestData():
    # Call API for dublin bikes
    dublinbike_data_request = requests.get(
        'https://api.jcdecaux.com/vls/v1/stations?contract=Dublin&apiKey=29374861957fe56e1b065c24f9cf06f84ae8dce2')
    dublinbike_data = json.loads(dublinbike_data_request.text)
    return dublinbike_data

def getBikeStandNames():
    bike_stand_name_list = []
    for bikes in getLatestData():
        bike_stand_name_list.append(bikes["name"])
    return bike_stand_name_list

def getBikeStandData():
    return getLatestData()
