from django.template import loader
from django.http import HttpResponse, HttpResponseRedirect
from WeatherPollution.models import WeatherData as wq
from django.http import JsonResponse
from WeatherPollution.models import WeatherPrediction



def index(request):
    latest_question_list = []
    template = loader.get_template('WeatherPollution/index.html')
    context = {
       'latest_question_list': latest_question_list,
    }
    return HttpResponse(template.render(context, request))

def weatherData(request):
    queryset = list(wq.objects.all().values())
    # data = CityEvents.objects.all()
    #print(queryset)
    return JsonResponse(queryset, safe=False)

def interactiveLine(request):

    template = loader.get_template('WeatherPollution/interactiveLine.html')

    context = {
       'data': [],
    }
    return HttpResponse(template.render(context, request))


def weatherPrediction(request):
    queryset = list(WeatherPrediction.objects.all().values())
    return JsonResponse(queryset, safe=False)