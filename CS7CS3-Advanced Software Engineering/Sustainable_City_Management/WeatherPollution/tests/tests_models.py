# test_models.py
import pytest
from mixer.backend.django import mixer
pytestmark = pytest.mark.django_db
from WeatherPollution.models import WeatherData
from django.test import TestCase
from datetime import datetime
from django.urls import reverse, resolve


class TestWeatherEvents(TestCase):

    # URL Testing

    def test_url_index(self):
        resp = self.client.get('/WeatherPollution/')
        self.assertEqual(resp.status_code, 200)



    def test_data_character_fields(self):
        entry = WeatherData(Station='Belmullet',Temperature=9,Weather="Fair" ,WindSpeed=4, WindGust=0, WindDirection = "NW", Humidity = 77, Rainfall= 0.000, Pressure=1036, cm_last_insert_dttm=datetime.now())
        assert isinstance(entry.Station, str)
        assert isinstance(entry.Temperature,int)
        assert isinstance(entry.Weather,str)
        assert isinstance(entry.WindSpeed,int)
        assert isinstance(entry.WindGust,int)
        assert isinstance(entry.WindDirection,str)
        assert isinstance(entry.Humidity,int)
        assert isinstance(entry.Rainfall,float)
        assert isinstance(entry.Pressure,int)
        assert isinstance(entry.cm_last_insert_dttm,datetime)

    def test_view_WeatherPollution(self):
        view = resolve('/WeatherPollution/weatherData')
        self.assertEquals(view.view_name, 'WeatherPollution:weatherData')
