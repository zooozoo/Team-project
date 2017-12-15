from rest_framework import generics
from rest_framework import permissions
from rest_framework.generics import get_object_or_404

from post.models import PostContent
from post.serializers import PostContentSerializer
from utils.permissions import IsPostContentAuthorOrReadOnly


class PostContentAPIView(generics.RetrieveUpdateDestroyAPIView):
    '''
    여행기 내용 하나를 삭제하기 위한 API
    하위 테이블 Text/Photo/Path를 같이 삭제
    '''
    serializer_class = PostContentSerializer
    lookup_url_kwarg = 'content_pk'
    permission_classes = (
        IsPostContentAuthorOrReadOnly,
    )
    def get_object(self):
        instance = get_object_or_404(PostContent.objects.filter(pk=self.kwargs['content_pk']))
        self.check_object_permissions(self.request, instance)
        return instance