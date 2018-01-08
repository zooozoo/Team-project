from django.conf.urls import url

from .apis import (
    LoginView,
    Signup,
    Follwing,
    UserProfileUpdate,
    UserPasswordUpdate,
    CheckTokenExists,
    MyProfile,
    UserProfile,
)

urlpatterns = [
    url(r'^login/$', LoginView.as_view(), name='login'),
    url(r'^signup/$', Signup.as_view(), name='signup'),
    url(r'^following/$', Follwing.as_view(), name='following'),
    url(r'^userprofile/$', MyProfile.as_view(), name='my-profile'),
    url(r'^userprofile/(?P<user_pk>\d+)/$', UserProfile.as_view(), name='user-profile'),
    url(r'^userprofile/update/$', UserProfileUpdate.as_view(), name='userprofile-update'),
    url(r'^userpassword/update/$', UserPasswordUpdate.as_view(), name='userpassword-update'),

    url(r'^token/$', CheckTokenExists.as_view(), name='token'),
]
