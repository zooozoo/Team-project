from django.conf.urls import url
from .apis import PostListAPIView,PostDetailAPIView, PostReplyAPIView,PostReplyUpdateAPIView,PostTextAPIView,PostPathAPIView,PostPhotolistView, \
    PostCreateAPIView, PostPathCreateAPIView

urlpatterns = [

    url(r'^$', PostListAPIView.as_view(), name='post_list'),
    url(r'^create',PostCreateAPIView.as_view(),name='post_create'),
    url(r'^(?P<post_pk>\d+)/$',PostDetailAPIView.as_view(), name='post_detail'),
    url(r'^reply/$',PostReplyAPIView.as_view(),name='post_reply'),
    url(r'^reply/(?P<reply_pk>\d+)/$',PostReplyUpdateAPIView.as_view(),name='post_reply_update'),
    #url(r'^text/$',PostTextCreateAPIView.as_view(),name='post_text_create'),
    url(r'^text/(?P<text_pk>\d+)/$',PostTextAPIView.as_view(),name='post_text'),
    url(r'^(?P<post_pk>\d+)/path/$',PostPathCreateAPIView.as_view(),name='post_path_create'),
    url(r'^path/(?P<path_pk>\d+)/$',PostPathAPIView.as_view(),name='post_path'),

]
