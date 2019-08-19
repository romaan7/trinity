from django.urls import path
from . import views

app_name = 'CityEvents'
urlpatterns = [
    path('', views.index, name='index'),
    path('ListEventData', views.ListEventData, name='ListEventData'),
    path('CityEventData', views.CityEventData, name='CityEventData'),
    path('MonthView', views.MonthView, name='MonthView'),
]