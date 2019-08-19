from django.template import loader
from django.http import HttpResponse, HttpResponseRedirect
from django.http import JsonResponse
from .models import Bike
from datetime import timedelta
from django.utils import timezone
from APIHandling import CustomUtil

from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login

def index(request):
    template = loader.get_template('bike.html')
    #Return the templet for bike visulization
    if request.user.is_authenticated:
        return HttpResponse(template.render())
    else:
        return HttpResponse("You are not logged in.")

def bike_indi(request):
    #Return the templet for bike visulization
    template = loader.get_template('bike_indi.html')
    return HttpResponse(template.render())

def bike_data(request):
    #get data from database
    this_hour = timezone.now().replace(minute=0, second=0, microsecond=0)
    one_hour_later = this_hour + timedelta(hours=1)
    #q = Bike.objects.filter(cm_last_insert_dttm__range=(this_hour, one_hour_later)).values()
    q = Bike.objects.all().order_by('-id')[:113].values()
    json_object = CustomUtil.query_to_json(q)
    return JsonResponse(json_object, safe=False)

def bike_emulated(request):
    #return a emulated template for bike data
    template = loader.get_template('bike_emu.html')
    return HttpResponse(template.render())
