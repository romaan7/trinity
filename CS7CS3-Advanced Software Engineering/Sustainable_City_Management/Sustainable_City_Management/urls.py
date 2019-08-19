"""Sustainable_City_Management URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import include, path
from APIHandling import DataHandling
import Main

#Start the threads to load the data into database as soon as the server starts

# DataHandling.start_bike_thread()
# DataHandling.start_busLuas_thread()
# DataHandling.start_cityEvent_thread()
# DataHandling.start_parking_thread()
# DataHandling.start_weather_thread()
# DataHandling.start_BusStop_thread()
# DataHandling.start_RealTimeBusStop_thread()



urlpatterns = [
    path('', include('Main.urls')),
    path('admin/', admin.site.urls),
    path('APIHandling/', include('APIHandling.urls')),
    path('BusLuas/', include('BusLuas.urls')),
    path('Bike/', include('Bike.urls')),
    path('Authentication/', include('Authentication.urls')),
    path('CityEvents/', include('CityEvents.urls')),
    path('WeatherPollution/', include('WeatherPollution.urls')),
    path('Parking/', include('Parking.urls')),
    path('CarTraffic/', include('CarTraffic.urls')),

]
handler404 = 'Main.views.handler404'
handler500 = 'Main.views.handler500'