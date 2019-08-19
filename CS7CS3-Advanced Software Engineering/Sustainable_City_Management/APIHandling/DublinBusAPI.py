import xml.etree.ElementTree as ET
import json
import xmltodict
from BusLuas.models import DublinBusStopData
from datetime import datetime
from BusLuas.models import DublinBusStopZoneData
from django.utils import timezone
import requests

global station_code

def getAllDublinBusStandInfo():

    import requests
    url = "http://rtpi.dublinbus.ie/DublinBusRTPIService.asmx"
    querystring = {"WSDL":""}
    payload = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:dub=\"http://dublinbus.ie/\">\r\n   <soapenv:Header/>\r\n   <soapenv:Body>\r\n      <dub:GetAllDestinations/>\r\n   </soapenv:Body>\r\n</soapenv:Envelope>"
    headers = {
        'Content-Type': "text/xml",
        'cache-control': "no-cache",
        'Postman-Token': "b917a9d8-0e91-4578-a9c4-2c967dd4dcfa"
        }
    response = requests.request("POST", url, data=payload, headers=headers, params=querystring)
    json_response=[]
    stationDetails={}
    xml = ET.fromstring(response.text)
    o = xmltodict.parse(response.text)
    count=0
    dump = json.dumps(json.dumps(o["soap:Envelope"]["soap:Body"]["GetAllDestinationsResponse"]["GetAllDestinationsResult"]["Destinations"]["Destination"]))
    responce = json.loads(dump)
    return responce

def getRealTimeDublinBusStandData():
    dublinBusStop=list(DublinBusStopData.objects.filter())
    dublinBusStopZoneData=list(DublinBusStopZoneData.objects.filter())
    print(dublinBusStopZoneData)
    if(True):
        DublinBusStopZoneData.objects.all().delete()
        for f in dublinBusStop:
            url = "http://rtpi.dublinbus.ie/DublinBusRTPIService.asmx"
            querystring = {"WSDL":""}
            payload = "<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:dub=\"http://dublinbus.ie/\">\r\n   <soap:Header/>\r\n   <soap:Body>\r\n      <dub:GetRealTimeStopData>\r\n         <dub:stopId>"+f.BusStopNumber+"</dub:stopId>\r\n      </dub:GetRealTimeStopData>\r\n   </soap:Body>\r\n</soap:Envelope>"
            headers = {
                'Content-Type': "text/xml",
                'cache-control': "no-cache",
                'Postman-Token': "618820e6-6411-40c5-805a-9846f9812b55"
                }

            response = requests.request("POST", url, data=payload, headers=headers, params=querystring)
            stopDataRealTime,stopRouteId=jsonResponse(response.text)
            finalData={}
            try:
                for busTime,BusRoute in zip(stopDataRealTime,stopRouteId):
                    timeDiff=datetime.strptime(busTime[:-6],'%Y-%m-%dT%H:%M:%S')-datetime.now()
                    if(timeDiff.seconds<300):
                        print('inside')
                        finalData['BusStopNumber']=f.BusStopNumber
                        finalData['BusStopZone']=f.BusStopZone
                        finalData['BusStopRoute']=BusRoute
                        finalData['BusStopIncomingTime']=stopDataRealTime
                        current_dttm = datetime.now(tz=timezone.utc)
                        cm_last_insert_dttm = current_dttm
                        cityEvent = DublinBusStopZoneData.objects.create(BusStopNumber=finalData['BusStopNumber'], BusStopZone=f.BusStopZone, BusStopRoute=BusRoute,
                                                            BusStopIncomingTime=busTime,
                                                            cm_last_insert_dttm=cm_last_insert_dttm)
                    else:
                        break
            except:
                pass
    return ''

def jsonResponse(xmlText):
    
    o = xmltodict.parse(xmlText)
    dataArray=[]
    dataRoute=[]
    try:
        stopDataRealTime=json.loads(json.dumps(o['soap:Envelope']["soap:Body"]["GetRealTimeStopDataResponse"]["GetRealTimeStopDataResult"]["diffgr:diffgram"]["DocumentElement"]["StopData"]))
        if len(stopDataRealTime)==1:
            pass
        elif len(stopDataRealTime)==2:
            dataArray.append(stopDataRealTime['MonitoredCall_ExpectedDepartureTime'])
            dataRoute.append(stopDataRealTime['MonitoredVehicleJourney_PublishedLineName'])
        else:
            for element in stopDataRealTime:
                dataArray.append(element['MonitoredCall_ExpectedDepartureTime'])
                dataRoute.append(element['MonitoredVehicleJourney_PublishedLineName'])
            
    except:
        pass
    return dataArray, dataRoute
