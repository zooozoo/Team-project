from django.conf.urls import url
from django.contrib import admin

from .apis import LoginView

urlpatterns = [
    url(r'^login/$', LoginView.as_view(), name='login'),
]
