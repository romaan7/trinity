from django.test import TestCase
from django.urls import reverse, resolve


class APIHandlingTestCase(TestCase):
    # Test view for BusLuas app
    def test_home_url_resolves_home_view(self):
        view = resolve('/APIHandling/')
        self.assertEquals(view.view_name, 'APIHandling:index')
