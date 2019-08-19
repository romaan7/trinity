from django.shortcuts import render
import requests
from django.template import loader
from django.http import HttpResponse, HttpResponseRedirect
from django.http import JsonResponse
from django.template.response import TemplateResponse

def index(request):
    template = loader.get_template('CarTraffic/Traffic.html')
    return HttpResponse(template.render())
