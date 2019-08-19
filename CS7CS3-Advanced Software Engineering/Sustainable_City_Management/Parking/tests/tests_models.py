# test_models.py
import pytest
from mixer.backend.django import mixer
pytestmark = pytest.mark.django_db
from Parking.models import carparkData 
from django.test import TestCase
from datetime import datetime
from django.urls import reverse, resolve


class TestParkingEvents(TestCase):

    # URL Testing

    def test_url_index(self):
        resp = self.client.get('/Parking/')
        self.assertEqual(resp.status_code, 200)

    def test_data_character_fields(self):
        entry = carparkData(name ="PARNELL" ,spaces="323" , area="Northwest" ,Timestamp=datetime.now(), cm_last_insert_dttm = datetime.now())
        assert isinstance(entry.name, str)
        assert isinstance(entry.spaces,str)
        assert isinstance(entry.area,str)
        assert isinstance(entry.Timestamp,datetime)
        assert isinstance(entry.cm_last_insert_dttm,datetime)


    #Test view for Parking app
    def test_views_index(self):
        view = resolve('/Parking/')
        self.assertEquals(view.view_name, 'Parking:index')
        
    def test_view_ParkingData(self):
        view = resolve('/Parking/parking_data')
        self.assertEquals(view.view_name, 'Parking:parking_data')
