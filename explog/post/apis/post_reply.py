from rest_framework import generics
from rest_framework import permissions
from rest_framework import status
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response

from post.models import PostReply, Post
from post.serializers import PostReplySerializer, PostReplyCreateSerializer


class PostReplyListAPIView(generics.ListAPIView):
    '''
    여행기에 달린 댓글 모두 가져오는 API
    '''
    serializer_class = PostReplySerializer

    def get_queryset(self):
        post_pk = self.kwargs['post_pk']

        return PostReply.objects.filter(post=post_pk)


class PostReplyCreateAPIView(generics.CreateAPIView):
    '''
    여행기에 댓글을 다는 API
    '''
    serializer_class = PostReplyCreateSerializer
    lookup_url_kwarg = 'post_pk'
    permission_classes = (
        permissions.IsAuthenticated,
    )

    def get_queryset(self):
        pk = self.kwargs.get(self.lookup_url_kwarg)
        return pk

    def perform_create(self, serializer):
        instance = get_object_or_404(Post.objects.filter(pk=self.get_queryset()))


        serializer.save(author=self.request.user, post=instance)


class PostReplyDeleteUpdateAPIView(generics.RetrieveUpdateDestroyAPIView):
    '''
    댓글 수정/삭제 API
    '''
    serializer_class = PostReplySerializer
    lookup_url_kwarg = 'reply_pk'
    permission_classes = (
        permissions.IsAuthenticatedOrReadOnly,
    )
    def get_queryset(self):
        instance = get_object_or_404(PostReply.objects.filter(pk=self.kwargs['reply_pk']))
        return instance