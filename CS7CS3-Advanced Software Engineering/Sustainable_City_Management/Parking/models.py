from django.db import models
from django.utils import timezone

#
# class Parking(models.Model):
#     id1 = models.IntegerField()
#     location = models.CharField(max_length=100)
#     roadname = models.CharField(max_length=100)
#     noofspaces = models.IntegerField()
#     spacetype = models.CharField(max_length=100)
#     OBJECTID = models.IntegerField()
#     Point = models.CharField(max_length=100)
#     lat = models.DecimalField(max_digits=12, decimal_places=9)
#     long = models.DecimalField(max_digits=12, decimal_places=9)
#     last_update = models.DateTimeField('date published', null=True)
#     cm_last_insert_dttm = models.DateTimeField(default=timezone.now, blank=True)

class carparkData(models.Model):
    name = models.CharField(max_length=50)
    spaces = models.CharField(max_length=10, null=True) #This is char field because when full the api returns "FULL" insted of number
    area = models.CharField(max_length=50)
    Timestamp = models.DateTimeField('date published', null=True)
    cm_last_insert_dttm = models.DateTimeField(default=timezone.now, blank=True)
