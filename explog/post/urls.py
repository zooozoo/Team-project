from django.conf.urls import url
from .apis import PostListAPIView,PostDetailAPIView, PostReplyListAPIView,PostReplyUpdateAPIView,PostTextAPIView,PostPathAPIView,PostPhotolistView, \
    PostCreateAPIView, PostPathCreateAPIView, PostTextCreateAPIView, PostPhotoCreateAPIView, PostContentAPIView, \
    PostReplyCreateAPIView, PostPhotoAPIView, PostDeleteAPIView, PostLikeToggle, PostCategoryListAPIView, \
    PostSearchAPIView

urlpatterns = [

    url(r'^$', PostListAPIView.as_view(), name='post_list'),
    url(r'(?P<category>\d+)/list/$',PostCategoryListAPIView.as_view(),name='post_category_list'),
    url(r'search/$',PostSearchAPIView.as_view(),name='post_search'),
    url(r'^create/',PostCreateAPIView.as_view(),name='post_create'),
    url(r'^(?P<post_pk>\d+)/$',PostDetailAPIView.as_view(), name='post_detail'),
    url(r'^(?P<post_pk>\d+)/delete/$',PostDeleteAPIView.as_view(),name='post_delete'),
    url(r'^(?P<post_pk>\d+)/reply/$',PostReplyListAPIView.as_view(),name='post_reply'),
    url(r'^(?P<post_pk>\d+)/reply/create/$',PostReplyCreateAPIView.as_view(),name='post_reply_create'),
    url(r'^reply/(?P<reply_pk>\d+)/$',PostReplyUpdateAPIView.as_view(),name='post_reply_update'),
    url(r'^content/(?P<content_pk>\d+)/$',PostContentAPIView.as_view(),name='post_content'),
    url(r'^(?P<post_pk>\d+)/text/$',PostTextCreateAPIView.as_view(),name='post_text_create'),
    url(r'^text/(?P<text_pk>\d+)/$',PostTextAPIView.as_view(),name='post_text'),
    url(r'^(?P<post_pk>\d+)/path/$',PostPathCreateAPIView.as_view(),name='post_path_create'),
    url(r'^path/(?P<path_pk>\d+)/$',PostPathAPIView.as_view(),name='post_path'),
    url(r'^(?P<post_pk>\d+)/photo/$',PostPhotoCreateAPIView.as_view(),name='post_photo_create'),
    url(r'^photo/(?P<photo_pk>\d+)/$',PostPhotoAPIView.as_view(),name='post_photo'),
    url(r'^(?P<post_pk>\d+)/like/$', PostLikeToggle.as_view(), name='post_like'),

]
