from django.template import loader
from django.http import HttpResponse, HttpResponseRedirect
from django.http import JsonResponse
from datetime import timedelta
from APIHandling import CustomUtil
from .models import carparkData
from django.utils import timezone

def index(request):
    template = loader.get_template('Parking/Parking.html')
    if request.user.is_authenticated:
        return HttpResponse(template.render())
    else:
        return HttpResponse("You are not logged in.")

def parking_data(request):
    q = carparkData.objects.values().order_by('-id')[:14]
    json_object = CustomUtil.query_to_json(q)
    return JsonResponse(json_object, safe=False)


def parking_stats(request):
    template = loader.get_template('Parking/parking_stats.html')
    return HttpResponse(template.render())


def parking_statsdata(request):
        q1 = carparkData.objects.values().order_by('-id')[:14]
        json_object1 = CustomUtil.query_to_json(q1)
        return JsonResponse(json_object1, safe=False)
