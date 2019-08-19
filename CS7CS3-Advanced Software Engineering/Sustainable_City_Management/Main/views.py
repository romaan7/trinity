from django.template import loader
from django.http import HttpResponse, HttpResponseRedirect
from django.shortcuts import render
from django.http import JsonResponse
from CityEvents import views as CityEvents
from Bike import views as Bike
from BusLuas import views as IrishRail
from WeatherPollution import views as Weather
import json
import psycopg2.extras
import sys,os
import configparser
from psycopg2.extras import RealDictCursor
from django.http import HttpResponse, HttpResponseNotFound

def getAnalyticsView():
    config = configparser.ConfigParser()
    CFG_DIR = os.path.join(os.path.join(os.path.abspath(
        os.path.dirname(__file__)), '..'), 'config.ini')
    config.read(CFG_DIR)
    conn = psycopg2.connect(database=config.get('AWS', 'database'),
                            port=config.get('AWS', 'Port'),
                            user=config.get('USERS_CREDS', 'user'),
                            password=config.get('USERS_CREDS', 'pwd'), host=config.get('AWS', 'host'))
    cursor = conn.cursor('cursor_unique_name',
                         cursor_factory=RealDictCursor)
    cursor.execute('SELECT * FROM public."real_time_analytics"')
    json_output =cursor.fetchall()
    return json_output

def RealTimeData(request):
    return JsonResponse(getAnalyticsView(), safe=False)

def index(request):
    template = loader.get_template('index.html')
    return HttpResponse(template.render({}, request))


def DublinBikes(request):
    template = loader.get_template('DublinBikes.html')
    if request.user.is_authenticated:
        return HttpResponse(template.render({}, request))
    else:
        return HttpResponse("You are not logged in.")



def IrishRail(request):
    template = loader.get_template('IrishRail.html')
    if request.user.is_authenticated:
        return HttpResponse(template.render({}, request))
    else:
        return HttpResponse("You are not logged in.")


def CityEvents(request):
    template = loader.get_template('CityEvents.html')
    if request.user.is_authenticated:
        return HttpResponse(template.render({}, request))
    else:
        return HttpResponse("You are not logged in.")

def Weather(request):
    template = loader.get_template('Weather.html')
    if request.user.is_authenticated:
        return HttpResponse(template.render({}, request))
    else:
        return HttpResponse("You are not logged in.")


def CarPark(request):
    template = loader.get_template('CarPark.html')
    if request.user.is_authenticated:
        return HttpResponse(template.render({}, request))
    else:
        return HttpResponse("You are not logged in.")

def BusDashBoard(request):
    template = loader.get_template('DublinBus.html')
    if request.user.is_authenticated:
        return HttpResponse(template.render({}, request))
    else:
        return HttpResponse("You are not logged in.")

def Analytics(request):
    template = loader.get_template('Analytics.html')
    if request.user.is_authenticated:
        return HttpResponse(template.render({}, request))
    else:
        return HttpResponse("You are not logged in.")

def handler404(request):
    return HttpResponseNotFound(request, '404.html', status=404)


def handler500(request):
    return HttpResponse(request, '500.html', status=500)

