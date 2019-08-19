from django.urls import path
from . import views

app_name = 'CarTraffic'
urlpatterns = [
    path('', views.index, name='index'),
]   