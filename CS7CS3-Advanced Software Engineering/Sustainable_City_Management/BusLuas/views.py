from django.template import loader
from django.http import HttpResponse, HttpResponseRedirect
from BusLuas.models import BusLuas as IrishRail
from BusLuas.models import DublinBusStopData
from django.http import JsonResponse
from APIHandling import DublinBusAPI
from django.db.models import Count
import xmltodict

import requests
import simplejson as json

def index(request):
    template = loader.get_template('BusLuas/IrishRail.html')
    return HttpResponse(template.render())


def irishrail_data(request):
    template = loader.get_template('IrishRail.html')
    if request.user.is_authenticated:
        return HttpResponse(template.render())
    else:
        return HttpResponse("You are not logged in.")


def IrishRailData(request):
    queryset = list(IrishRail.objects.filter().distinct('TrainCode').values())
    return JsonResponse(queryset, safe=False)

def IrishRailLateData(request):
    distinct_obj = IrishRail.objects.all().distinct('TrainCode')
    top_lates = (distinct_obj
                  .order_by('-Late')
                  .values_list('Late', flat=True)
                  .distinct())
    top_records = (IrishRail.objects
                   .order_by('-Late')
                   .filter(Late__in=top_lates[:10]).values())
    queryset = list(top_records)
    return JsonResponse(queryset, safe=False)

def DublinBusData(request):
    test = DublinBusAPI.getAllDublinBusStandInfo()
    queryset = list(DublinBusStopData.objects.filter().values())
    return JsonResponse(queryset, safe=False)

def RealTimeBusData(request):
    stopid=request.GET['stopnumber']
    url = "http://rtpi.dublinbus.ie/DublinBusRTPIService.asmx"
    querystring = {"WSDL":""}
    payload = "<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:dub=\"http://dublinbus.ie/\">\r\n   <soap:Header/>\r\n   <soap:Body>\r\n      <dub:GetRealTimeStopData>\r\n         <dub:stopId>"+ str(stopid)+"</dub:stopId>\r\n      </dub:GetRealTimeStopData>\r\n   </soap:Body>\r\n</soap:Envelope>"
    headers = {
        'Content-Type': "text/xml",
        'cache-control': "no-cache",
        'Postman-Token': "618820e6-6411-40c5-805a-9846f9812b55"
        }
    response = requests.request("POST", url, data=payload, headers=headers, params=querystring)
    stopDataRealTime=jsonResponse(response.text)

    #fileName=str(stopid)+ '.json'
   ## with open(fileName, 'w') as outfile:
     #   json.dump(stopDataRealTime, outfile)
    return JsonResponse(stopDataRealTime, safe=False) 


def jsonResponse(xmlText):
    o = xmltodict.parse(xmlText)
    response=json.loads(json.dumps(o['soap:Envelope']["soap:Body"]["GetRealTimeStopDataResponse"]["GetRealTimeStopDataResult"]["diffgr:diffgram"]["DocumentElement"]["StopData"]))
    stopDataRealTime=json.loads(json.dumps(o['soap:Envelope']["soap:Body"]["GetRealTimeStopDataResponse"]["GetRealTimeStopDataResult"]["diffgr:diffgram"]["DocumentElement"]["StopData"]))
    return stopDataRealTime


def DublinBusSearchResult(request):
    if request.is_ajax():
        q = request.GET.get('term', '').capitalize()
        test = list(DublinBusStopData.objects.filter(BusStopStationName__icontains=q))
        results = []
        for r in test:
            results.append(json.dumps({'StopName': r.BusStopStationName,'StationId':r.BusStopNumber,'lat':r.BusStopLatitude,'lng':r.BusStopLongitude},use_decimal=True ))
        data = json.dumps(results)
    else:
        data = 'fail'
    mimetype = 'application/json'
    return HttpResponse(data, mimetype)
