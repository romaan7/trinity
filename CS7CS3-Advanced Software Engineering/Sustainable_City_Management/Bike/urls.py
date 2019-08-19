from django.urls import path

from . import views

app_name = 'Bike'
urlpatterns = [
    path('', views.index, name='index'),
    path('bike_emulated', views.bike_emulated, name='bike_emulated'),
    path('bike_data', views.bike_data, name='bike_data'),
    path('bike_indi', views.bike_indi, name='bike_indi'),

]