# Create your views here.
from rest_framework import generics
from rest_framework import permissions
from rest_framework import viewsets
from rest_framework.parsers import MultiPartParser, FormParser

from utils.permissions import IsAuthorOrReadOnly
from .models import Post, PostPhoto, PostReply, PostText, PostPath
from .serializers import PostSerializer, PhotoListSerializer, PostReplySerializer, PostTextSerializer, \
    PostPathSerializer, PostDetailSerializer, PostListSerializer


class PostListAPIView(generics.ListAPIView):
    queryset = Post.objects.all()
    serializer_class = PostListSerializer


class PostCreateAPIView(generics.CreateAPIView):
    queryset = Post.objects.all()
    serializer_class = PostSerializer

    permission_classes = (
        permissions.IsAuthenticatedOrReadOnly,
    )

    def perform_create(self, serializer):
        serializer.save(author=self.request.user)


class PostDetailAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Post.objects.all()
    lookup_url_kwarg = 'post_pk'
    serializer_class = PostDetailSerializer

    permission_classes = (
        permissions.IsAuthenticatedOrReadOnly,
    )


class PostReplyCreateAPIView(generics.ListCreateAPIView):
    queryset = PostReply.objects.all()
    serializer_class = PostReplySerializer

    permission_classes = (
        permissions.IsAuthenticatedOrReadOnly,
    )

    def perform_create(self, serializer):
        serializer.save(author=self.request.user)


class PostReplyGetDeleteAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = PostReply.objects.all()
    serializer_class = PostReplySerializer
    lookup_url_kwarg = 'reply_pk'


class PostTextCreateAPIView(generics.CreateAPIView):
    queryset = PostText.objects.all()
    serializer_class = PostTextSerializer

    def perform_create(self, serializer):
        serializer.save(author=self.request.user)


class PostTextGetDeleteAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = PostText.objects.all()
    serializer_class = PostTextSerializer
    lookup_url_kwarg = 'text_pk'
    permission_classes = (
        IsAuthorOrReadOnly,
    )


class PostPathCreateAPIView(generics.CreateAPIView):
    queryset = PostPath.objects.all()
    serializer_class = PostPathSerializer

    def perform_create(self, serializer):
        serializer.save()


class PostPathGetDeleteAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = PostPath.objects.all()
    serializer_class = PostPathSerializer
    lookup_url_kwarg = 'path_pk'


# PostPhoto create뷰는 트러블 슈팅 필요
class PostPhotolistView(viewsets.ModelViewSet):
    serializer_class = PhotoListSerializer
    parser_classes = (MultiPartParser, FormParser,)
    queryset = PostPhoto.objects.all()
