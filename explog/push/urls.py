from django.conf.urls import url

from .apis import (
    ResetBadgeCount,
    PushList,
    SetBadgeCount,
    SetAPNsDeviceToken
)


urlpatterns = [
    url(r'^reset-badge/$', ResetBadgeCount.as_view(), name='reset-badge'),
    url(r'^set-badge/$', SetBadgeCount.as_view(), name='set-badge'),
    url(r'^list/$', PushList.as_view(), name='push-list'),
    url(r'^device-token/$', SetAPNsDeviceToken.as_view(), name='device-token'),
]
