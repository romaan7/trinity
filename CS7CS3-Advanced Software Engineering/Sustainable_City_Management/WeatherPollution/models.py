from django.db import models
from django.utils import timezone


class WeatherData(models.Model):
    Station = models.CharField(max_length=50)
    Temperature = models.IntegerField(null=True)
    Weather = models.CharField(max_length=25,null=True)
    WindSpeed = models.IntegerField(null=True)
    WindGust = models.IntegerField(null=True)
    WindDirection = models.CharField(max_length=10,null=True)
    Humidity = models.IntegerField(null=True)
    Rainfall = models.DecimalField(max_digits=9, decimal_places=3,null=True)
    Pressure = models.IntegerField(null=True)
    cm_last_insert_dttm = models.DateTimeField(default=timezone.now, blank=True)

class WeatherPrediction(models.Model):
    time = models.DateTimeField()
    Temperature = models.DecimalField(max_digits=9, decimal_places=3,null=True)
    WindSpeed = models.DecimalField(max_digits=9, decimal_places=3,null=True)