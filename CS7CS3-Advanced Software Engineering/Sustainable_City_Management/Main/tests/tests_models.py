# test_models.py
import pytest
from mixer.backend.django import mixer
pytestmark = pytest.mark.django_db
from django.test import TestCase
from datetime import datetime
from django.urls import reverse, resolve


class TestMainEvents(TestCase):

    # URL Testing

    def test_url_index(self):
        resp = self.client.get('/')
        self.assertEqual(resp.status_code, 200)

    def test_url_DublinBikesView(self):
        resp = self.client.get('/DublinBikes')
        self.assertEqual(resp.status_code, 200)

    def test_url_IrishRailView(self):
        resp = self.client.get('/IrishRail')
        self.assertEqual(resp.status_code, 200)
    
    def test_url_CityEventsView(self):
        resp = self.client.get('/CityEvents')
        self.assertEqual(resp.status_code, 200)
    
    def test_url_WeatherView(self):
        resp = self.client.get('/Weather')
        self.assertEqual(resp.status_code, 200)
    
    def test_url_CarParkrView(self):
        resp = self.client.get('/CarPark')
        self.assertEqual(resp.status_code, 200)

   

    #Test view for CityEvent app
    def test_views_index(self):
        view = resolve('/')
        self.assertEquals(view.view_name, 'Main:index')
        
    def test_view_DublinBikes(self):
        view = resolve('/DublinBikes')
        self.assertEquals(view.view_name, 'Main:DublinBikes')
    
    def test_view_IrishRail(self):
        view = resolve('/IrishRail')
        self.assertEquals(view.view_name, 'Main:IrishRail')
    
    def test_view_CityEvents(self):
        view = resolve('/CityEvents')
        self.assertEquals(view.view_name, 'Main:CityEvents')
    
    def test_view_Weather(self):
        view = resolve('/Weather')
        self.assertEquals(view.view_name, 'Main:Weather')

    def test_view_Weather(self):
        view = resolve('/CarPark')
        self.assertEquals(view.view_name, 'Main:CarPark')