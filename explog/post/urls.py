from django.conf.urls import url
from .views import PostListAPIView, PostDetailAPIView, PostReplyCreateAPIView, PostReplyGetDeleteAPIView, PostTextGetDeleteAPIView, \
    PostPathGetDeleteAPIView, PostPhotolistView, \
    PostCreateAPIView, PostTextCreateAPIView, PostPathCreateAPIView

urlpatterns = [

    url(r'^$', PostListAPIView.as_view(), name='post_list'),
    url(r'^create', PostCreateAPIView.as_view(), name='post_create'),
    url(r'^(?P<post_pk>\d+)/$', PostDetailAPIView.as_view(), name='post_detail'),
    url(r'^reply-create/$', PostReplyCreateAPIView.as_view(), name='post_reply'),
    url(r'^reply-get-delete/(?P<reply_pk>\d+)/$', PostReplyGetDeleteAPIView.as_view(), name='post_reply_update'),
    url(r'^text-create/$', PostTextCreateAPIView.as_view(), name='post_text_create'),
    url(r'^text-get-delete/(?P<text_pk>\d+)/$', PostTextGetDeleteAPIView.as_view(), name='post_text'),
    url(r'^path-create/$', PostPathCreateAPIView.as_view(), name='post_path_create'),
    url(r'^path-get-delete/(?P<path_pk>\d+)/$', PostPathGetDeleteAPIView.as_view(), name='post_path'),

]
