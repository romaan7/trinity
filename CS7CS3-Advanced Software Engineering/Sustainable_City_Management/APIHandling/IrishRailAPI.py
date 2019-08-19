import xml.etree.ElementTree as ET
import requests
from BusLuas import models
import json


global station_code

def getTrainStationCodes():
     r = requests.get('http://api.irishrail.ie/realtime/realtime.asmx/getAllStationsXML')
     root = ET.fromstring(r.content)
     station_code=[]
     for child in root.iter('*'):
      if("StationCode" in child.tag):
        if(requests.get('http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByCodeXML_WithNumMins?StationCode='+child.text.strip()+'&NumMins=5').content):
          station_code += ['http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByCodeXML_WithNumMins?StationCode='+child.text.strip()+'&NumMins=5']
     return(station_code)

# return json for all trains at all stations

def get_trains_at_all_stations():
    station_codes = models.IrishRailStationCode.objects.values_list('StationCode', flat=True)
    json_responce = []
    for station in station_codes:
        train_details = {}
        xml_data = requests.get('http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByCodeXML_WithNumMins?StationCode=' + str(station) + '&NumMins=5').content
        xml = ET.fromstring(xml_data)
        for child in xml.iter('*'):
            if ("Servertime" in child.tag):
                train_details["ServerTime"] = child.text
            if ("Traincode" in child.tag):
                train_details["TrainCode"] = child.text
            if ("Stationfullname" in child.tag):
                train_details["StationFullName"] = child.text
            if ("Stationcode" in child.tag):
                train_details["StationCode"] = child.text
            if ("Querytime" in child.tag):
                train_details["QueryTime"] = child.text + ":00"
            if ("Traindate" in child.tag):
                train_details["TrainDate"] = child.text
            if ("Origin" in child.tag) and ("Origintime" not in child.tag):
                train_details["Origin"] = child.text
            if ("Destination" in child.tag) and ("Destinationtime" not in child.tag):
                train_details["Destination"] = child.text
            if ("Origintime" in child.tag):
                train_details["OriginTime"] = child.text + ":00"
            if ("Destinationtime" in child.tag):
                train_details["DestinationTime"] = child.text + ":00"
            if ("Status" in child.tag):
                train_details["Status"] = child.text
            if ("Lastlocation" in child.tag):
                train_details["LastLocation"] = child.text
            if ("Duein" in child.tag):
                train_details["DueIn"] = child.text
            if ("Late" in child.tag):
                train_details["Late"] = child.text
            if ("Exparrival" in child.tag):
                train_details["ExpArrival"] = child.text + ":00"
            if ("Expdepart" in child.tag):
                train_details["ExpDepart"] = child.text + ":00"
            if ("Scharrival" in child.tag):
                train_details["SchArrival"] = child.text + ":00"
            if ("Schdepart" in child.tag):
                train_details["SchDepart"] = child.text + ":00"
            if ("Direction" in child.tag):
                train_details["Direction"] = child.text
            if ("Traintype" in child.tag):
                train_details["TrainType"] = child.text
            if ("Locationtype" in child.tag):
                train_details["LocationType"] = child.text

        json_responce.append(train_details)
    #removes empty lists from main list
    while {} in json_responce:
        json_responce.remove({})

    dump = json.dumps(json_responce)
    responce = json.loads(dump)
    return responce
