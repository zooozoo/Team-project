from rest_framework import generics
from rest_framework import permissions

from post.models import PostContent
from post.serializers import PostContentSerializer


class PostContentAPIView(generics.RetrieveDestroyAPIView):
    queryset = PostContent.objects.all()
    serializer_class = PostContentSerializer
    lookup_url_kwarg = 'content_pk'
    permission_classes = (
        permissions.IsAuthenticatedOrReadOnly,
    )
