from rest_framework import generics
from rest_framework import permissions

from post.models import PostContent
from post.serializers import PostContentSerializer


class PostContentAPIView(generics.RetrieveDestroyAPIView):
    '''
    여행기 내용 하나를 삭제하기 위한 API
    하위 테이블 Text/Photo/Path를 같이 삭제
    '''
    queryset = PostContent.objects.all()
    serializer_class = PostContentSerializer
    lookup_url_kwarg = 'content_pk'
    permission_classes = (
        permissions.IsAuthenticatedOrReadOnly,
    )
