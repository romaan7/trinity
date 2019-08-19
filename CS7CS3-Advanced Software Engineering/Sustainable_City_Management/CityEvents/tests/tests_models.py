# test_models.py
import pytest
from mixer.backend.django import mixer
pytestmark = pytest.mark.django_db
from CityEvents.models import CityEvents
from django.test import TestCase
from datetime import datetime
from django.urls import reverse, resolve


class TestCityEvents(TestCase):

    # URL Testing

    def test_url_index(self):
        resp = self.client.get('/CityEvents/')
        self.assertEqual(resp.status_code, 200)

    def test_url_monthView(self):
        resp = self.client.get('/CityEvents/MonthView')
        self.assertEqual(resp.status_code, 200)

    def test_url_CityEventData(self):
        resp = self.client.get('/CityEvents/CityEventData')
        self.assertEqual(resp.status_code, 200)
    
    def test_url_ListEventData(self):
        resp = self.client.get('/CityEvents/ListEventData')
        self.assertEqual(resp.status_code, 200)


    def test_data_character_fields(self):
        entry = CityEvents(nametext='Test Data',organization_id=156453698952,listed=True ,is_free=False,url='https://www.eventbrite.co.uk/e/love-your-home-dublin-2019-tickets-48641262325?aff=ebapi',startutc=datetime.now(),endutc=datetime.now())
        assert isinstance(entry.nametext, str)
        assert isinstance(entry.descriptiontext,str)
        assert isinstance(entry.resource_uri,str)
        print(entry.descriptiontext)
        assert isinstance(entry.startutc,datetime)
        assert isinstance(entry.endutc,datetime)
        assert isinstance(entry.url,str)
        assert isinstance(entry.organization_id,int)


    #Test view for CityEvent app
    def test_views_index(self):
        view = resolve('/CityEvents/')
        self.assertEquals(view.view_name, 'CityEvents:index')
        
    def test_view_CityEventData(self):
        view = resolve('/CityEvents/MonthView')
        self.assertEquals(view.view_name, 'CityEvents:MonthView')
    
    def test_view_ListEventData(self):
        view = resolve('/CityEvents/ListEventData')
        self.assertEquals(view.view_name, 'CityEvents:ListEventData')