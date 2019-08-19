
# pytestmark = pytest.mark.django_db
from django.test import TestCase
from django.urls import reverse, resolve
from datetime import datetime
import django.utils.timezone

class CarTrafficTestCase(TestCase):
    def test_index(self):
        resp = self.client.get('/CarTraffic/')
        self.assertEqual(resp.status_code, 200)

    # Test view for BusLuas app
    def test_home_url_resolves_home_view(self):
        view = resolve('/CarTraffic/')
        self.assertEquals(view.view_name, 'CarTraffic:index')