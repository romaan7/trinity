from django.urls import path

from . import views

app_name = 'Main'
urlpatterns = [
    path('', views.index, name='index'),
    path('DublinBikes', views.DublinBikes, name ='DublinBikes'),
    path('IrishRail', views.IrishRail, name ='IrishRail'),
    path('CityEvents', views.CityEvents, name ='CityEvents'),
    path('Weather', views.Weather, name ='Weather'),
    path('CarPark', views.CarPark, name ='CarPark'),
    path('BusDashBoard', views.BusDashBoard, name ='DublinBus'),
    path('Analytics', views.Analytics, name='Analytics'),
    path('RealTimeData', views.RealTimeData, name='RealTimeData'),
]
