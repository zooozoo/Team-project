from django.conf.urls import url

from .apis import LoginView, Signup, GetUserProfile

urlpatterns = [
    url(r'^login/$', LoginView.as_view(), name='login'),
    url(r'^signup/$', Signup.as_view(), name='signup'),
    url(r'^user-post-list/$', GetUserProfile.as_view(), name='user-post-list'),
]
