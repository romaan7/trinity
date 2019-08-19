from django.shortcuts import render
import requests


from django.template import loader
from django.http import HttpResponse, HttpResponseRedirect
from CityEvents.models import CityEvents
from django.http import JsonResponse
from django.template.response import TemplateResponse

def index(request):
    template = loader.get_template('CityEvents/MonthView.html')
    return HttpResponse(template.render())

def CityEventData(request):
    queryset = list(CityEvents.objects.all().order_by('startutc').values())
    # data = CityEvents.objects.all()
    return JsonResponse(queryset, safe=False)
    
def MonthView(request):
    template = loader.get_template('CityEvents/MonthView.html')
    context = {
        'data': [],
    }
    return HttpResponse(template.render(context, request))

def ListEventData(request):
    template = loader.get_template('CityEvents/animations.html')
    queryset = list(CityEvents.objects.all().order_by('startutc').values())
    response = TemplateResponse(request, 'CityEvents/animations.html', {'eventList':queryset})
    context = {
        'data': [],
    }
    # return HttpResponse(template.render(context, request))
    if request.user.is_authenticated:
        return response
    else:
        return HttpResponse("You are not logged in.")
