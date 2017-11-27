from django.conf.urls import url
from .views import PostListAPIView,PostDetailAPIView, PostReplyAPIView,PostReplyUpdateAPIView,PostTextAPIView,PostPathAPIView,PostPhotolistView

urlpatterns = [

    url(r'^$', PostListAPIView.as_view(), name='post_list'),
    url(r'^(?P<post_pk>\d+)/$',PostDetailAPIView.as_view(), name='post_detail'),
    url(r'^postreply/$',PostReplyAPIView,name='post_reply'),
    url(r'^postreply/(?P<postreply_pk>\d+)',PostReplyUpdateAPIView,name='post_reply_detail'),
    url(r'^posttext/(?P<posttext_pk>\d+)',PostTextAPIView,name='post_text'),
    url(r'^postpath/(?P<postpath_pk>\d+)',PostPathAPIView,name='post_path'),

]
