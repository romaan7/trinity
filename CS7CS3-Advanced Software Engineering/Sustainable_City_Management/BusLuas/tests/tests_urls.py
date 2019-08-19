from django.urls import reverse, resolve


class TestUrls:

     #Test Urls.py
  def test_home_url_resolves_home_view(self):
        view = resolve('/BusLuas/')
        self.assertEquals(view.view_name, 'BusLuas:index')
 