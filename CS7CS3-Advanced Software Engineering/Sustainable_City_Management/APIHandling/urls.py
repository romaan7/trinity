from django.urls import path

from . import views

app_name = 'APIHandling'
urlpatterns = [
    path('', views.index, name='index'),
]