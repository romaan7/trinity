from django.urls import path
from . import views

app_name = 'BusLuas'
urlpatterns = [
    path('', views.index, name='index'),
    path('IrishRailData', views.IrishRailData, name='IrishRailData'),
    path('IrishRailLateData', views.IrishRailLateData, name='IrishRailLateData'),
    path('DublinBusData', views.DublinBusData, name='DublinBusData'),
    path('DublinBusSearchResult',views.DublinBusSearchResult, name='DublinBusSearchResult'),
    path('RealTimeBusData',views.RealTimeBusData, name='RealTimeBusData')
]   