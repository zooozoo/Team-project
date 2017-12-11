from django.conf.urls import url

from .apis import (
    LoginView,
    Signup,
    Follwing,
    UserProfileUpdate,
    UserPasswordUpdate,
    UserProfile,
)

urlpatterns = [
    url(r'^login/$', LoginView.as_view(), name='login'),
    url(r'^signup/$', Signup.as_view(), name='signup'),
    url(r'^following/$', Follwing.as_view(), name='following'),
    url(r'^userprofile/$', UserProfile.as_view(), name='profile'),
    url(r'^userprofile/update/$', UserProfileUpdate.as_view(), name='userprofile-update'),
    url(r'^userpassword/update/$', UserPasswordUpdate.as_view(), name='userpassword-update'),

]
