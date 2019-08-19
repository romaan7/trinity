
from django.test import TestCase
from Bike.models import Bike
from django.urls import reverse, resolve
from datetime import datetime
import django.utils.timezone

class BikeTestCase(TestCase):

    def test_index(self):
        resp = self.client.get('/Bike/')
        self.assertEqual(resp.status_code, 200)

    # Test view for BusLuas app
    def test_home_url_resolves_home_view(self):
        view = resolve('/Bike/')
        self.assertEquals(view.view_name, 'Bike:index')

    # Testing string type models
    def test_string_representation(self):
        entry = Bike(contract_name ="Clondalkin", name ="Smithfield", address ="Ninth Lock Road",
                     status ="OPEN")
        assert isinstance(entry.contract_name, str)
        assert isinstance(entry.name, str)
        assert isinstance(entry.address, str)
        assert isinstance(entry.status, str)

    def test_int_representation(self):
        entry = Bike(bike_stands =23, available_bike_stands =2, available_bikes =68)
        assert isinstance(entry.bike_stands, int)
        assert isinstance(entry.available_bike_stands, int)
        assert isinstance(entry.available_bikes, int)

    def test_float_representation(self):
        entry = Bike(position_lat =53.291516862, position_lng =-6.316224651)
        assert isinstance(entry.position_lat, float )
        assert isinstance(entry.position_lng, float)

    def test_boolean_representation(self):
        entry = Bike(banking=True, bonus=False)
        assert isinstance(entry.banking, bool)
        assert isinstance(entry.bonus, bool)

     #Testing datetime type models
    def test_datetime_representation(self):
        entry = Bike(last_update  = datetime.now(), cm_last_insert_dttm  = django.utils.timezone.now())
        assert isinstance(entry.last_update, datetime)
        assert isinstance(entry.cm_last_insert_dttm, datetime)

    def test_view_Bike1Data(self):
        view = resolve('/Bike/bike_indi')
        self.assertEquals(view.view_name, 'Bike:bike_indi')

    def test_view_Bike2Data(self):
        view = resolve('/Bike/bike_data')
        self.assertEquals(view.view_name, 'Bike:bike_data')

    def test_view_BikeEmulatedData(self):
        view = resolve('/Bike/bike_emulated')
        self.assertEquals(view.view_name, 'Bike:bike_emulated')