from django.urls import path

from . import views

app_name = 'WeatherPollution'
urlpatterns = [
    path('', views.index, name='index'),
    path('weatherData', views.weatherData, name='weatherData'),
    path('interactiveLine', views.interactiveLine, name='interactiveLine'),
    path('weatherPrediction', views.weatherPrediction, name='weatherPrediction'),
]