import pytest
from django.test import TestCase

# from mixer.backend.django import mixer
pytestmark = pytest.mark.django_db
from BusLuas.models import BusLuas
from BusLuas.models import IrishRailStationCode
from datetime import datetime
import django.utils.timezone
# from BusLuas.views import BusLuasView
from django.urls import reverse, resolve


class TestIrishRail(TestCase):

    # #Initialize Model
    # def test_init(self):
    #       obj = mixer.blend('BusLuas.BusLuas')
    #       self.assertEqual(obj.pk,1)

    # Test url for BusLuas app
    def test_index(self):
        resp = self.client.get('/BusLuas/')
        self.assertEqual(resp.status_code, 200)

    # Test view for BusLuas app
    def test_home_url_resolves_home_view(self):
        view = resolve('/BusLuas/')
        self.assertEquals(view.view_name, 'BusLuas:index')

    # Testing string type models
    def test_string_representation(self):
        entry = BusLuas(TrainCode="A130", StationFullName="Dalkey", StationCode="BALNA", Origin="Ballina",
                        Destination="Cork", Status="En Route", LastLocation="Departed Raheny", Direction="North",
                        TrainType="C", LocationType="City")  # ,DueIn="4" )
        assert isinstance(entry.TrainCode, str)
        assert isinstance(entry.StationFullName, str)
        assert isinstance(entry.StationCode, str)
        assert isinstance(entry.Origin, str)
        assert isinstance(entry.Destination, str)
        assert isinstance(entry.Status, str)
        assert isinstance(entry.LastLocation, str)
        assert isinstance(entry.Direction, str)
        assert isinstance(entry.TrainType, str)
        assert isinstance(entry.LocationType, str)

    #  assert isinstance(entry.DueIn,str)

    # Testing datetime type models
    def test_datetime_representation(self):
        entry = BusLuas(TrainDate=datetime.now(), OriginTime=django.utils.timezone.now(),
                        DestinationTime=django.utils.timezone.now(), ExpArrival=django.utils.timezone.now(),
                        ExpDepart=django.utils.timezone.now(), cm_last_insert_dttm=django.utils.timezone.now())
        assert isinstance(entry.TrainDate, datetime)
        assert isinstance(entry.OriginTime, datetime)
        assert isinstance(entry.DestinationTime, datetime)
        assert isinstance(entry.ExpArrival, datetime)
        assert isinstance(entry.ExpDepart, datetime)
        assert isinstance(entry.cm_last_insert_dttm, datetime)

    # Testing integer type models
    def test_integer_representation(self):
        entry = BusLuas(DueIn=2, Late=3)
        assert isinstance(entry.DueIn, int)
        assert isinstance(entry.Late, int)

    # Testing string type models
    def test_string1_representation(self):
        entry = IrishRailStationCode(StationDesc="Belfast", StationAlias="Belfast", StationCode="BALNA")
        assert isinstance(entry.StationDesc, str)
        assert isinstance(entry.StationAlias, str)
        assert isinstance(entry.StationCode, str)

    # Testing datetime type models
    def test_datetime1_representation(self):
        entry = IrishRailStationCode(cm_last_insert_dttm=django.utils.timezone.now())
        assert isinstance(entry.cm_last_insert_dttm, datetime)

    # Testing float type models
    def test_numeric1_representation(self):
        entry = IrishRailStationCode(StationLatitude=53.291516862, StationLongitude=-6.316224651, StationId=12)
        assert isinstance(entry.StationLatitude, float)
        assert isinstance(entry.StationLongitude, float)
        assert isinstance(entry.StationId, int)


    def test_view_IrishRailData1(self):
        view = resolve('/BusLuas/IrishRailData')
        self.assertEquals(view.view_name, 'BusLuas:IrishRailData')

    def test_view_DublinBusData(self):
        view = resolve('/BusLuas/DublinBusData')
        self.assertEquals(view.view_name, 'BusLuas:DublinBusData')