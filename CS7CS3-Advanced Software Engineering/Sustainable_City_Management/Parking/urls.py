from django.urls import path

from . import views

app_name = 'Parking'
urlpatterns = [
    path('', views.index, name='index'),
    path('parking_data', views.parking_data, name='parking_data'),
    path('parking_statsdata', views.parking_statsdata, name='parking_statsdata'),
    path('parking_stats', views.parking_stats, name='parking_stats'),

]