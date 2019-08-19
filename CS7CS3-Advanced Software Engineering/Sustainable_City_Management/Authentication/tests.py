# pytestmark = pytest.mark.django_db
from django.test import TestCase
from django.urls import reverse, resolve
from datetime import datetime
import django.utils.timezone

class AuthenticationTestCase(TestCase):
    def test_login(self):
        resp = self.client.get('/Authentication/login/')
        self.assertEqual(resp.status_code, 200)


    # Test view for BusLuas app
    def test_logout(self):
        resp = self.client.get('/Authentication/logout/')
        self.assertEqual(resp.status_code, 302)


