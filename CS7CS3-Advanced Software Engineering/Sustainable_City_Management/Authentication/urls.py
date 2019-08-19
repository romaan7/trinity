from django.urls import path

from . import views

app_name = 'Authentication'
urlpatterns = [
    path('login/', views.login_process, name='login'),
    path('logout/', views.logout_process, name='logout'),
]