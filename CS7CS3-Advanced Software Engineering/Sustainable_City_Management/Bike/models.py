from django.db import models
from django.utils import timezone

# Create your models here.
class Bike(models.Model):
    number = models.IntegerField()
    contract_name = models.CharField(max_length=100)
    name = models.CharField(max_length=100)
    address = models.CharField(max_length=100)
    position_lat = models.DecimalField(max_digits=9, decimal_places=6)
    position_lng = models.DecimalField(max_digits=9, decimal_places=6)
    banking = models.BooleanField(max_length=5)
    bonus = models.BooleanField(max_length=5)
    bike_stands = models.IntegerField()
    available_bike_stands = models.IntegerField()
    available_bikes = models.IntegerField()
    status = models.CharField(max_length=10)
    last_update = models.DateTimeField('date published')
    cm_last_insert_dttm = models.DateTimeField(default=timezone.now, blank=True)
