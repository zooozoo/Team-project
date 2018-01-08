from django.conf.urls import url

from .apis import (
    ResetBadgeCount,
    PushList)

urlpatterns = [
    url(r'^reset-badge/$', ResetBadgeCount.as_view(), name='reset-badge'),
    url(r'^list/$', PushList.as_view(), name='push-list'),
]
