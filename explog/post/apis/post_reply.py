from rest_framework import generics
from rest_framework import permissions
from rest_framework import status
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response

from post.models import PostReply, Post
from post.serializers import PostReplySerializer, PostReplyCreateSerializer
from utils.permissions import IsPostAuthorOrReadOnly


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
        self.check_permissions(self.request)

        return pk

    def perform_create(self, serializer):
        instance = get_object_or_404(Post.objects.filter(pk=self.get_queryset()))


        serializer.save(author=self.request.user, post=instance)
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        reply = PostReply.objects.get(pk=serializer.data['pk'])
        data = PostReplySerializer(reply).data
        return Response(data, status=status.HTTP_201_CREATED, headers=headers)


class PostReplyDeleteUpdateAPIView(generics.RetrieveUpdateDestroyAPIView):
    '''
    댓글 수정/삭제 API
    '''
    serializer_class = PostReplySerializer
    lookup_url_kwarg = 'reply_pk'
    permission_classes = (
        IsPostAuthorOrReadOnly,
    )
    def get_object(self):
        instance = get_object_or_404(PostReply.objects.filter(pk=self.kwargs['reply_pk']))
        self.check_object_permissions(self.request, instance)
        return instance

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        self.perform_destroy(instance)
        return Response({"detail":"댓글 하나가 삭제되었습니다."},status=status.HTTP_204_NO_CONTENT)