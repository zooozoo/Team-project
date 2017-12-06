from django.conf.urls import url

from .apis import LoginView, Signup, Follwing


urlpatterns = [
    url(r'^login/$', LoginView.as_view(), name='login'),
    url(r'^signup/$', Signup.as_view(), name='signup'),
    url(r'^following/$', Follwing.as_view(), name='signup'),

]
