from django.shortcuts import render

# Create your views here.
from rest_framework import generics
from rest_framework import permissions
from rest_framework import viewsets
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.views import APIView

from .serializers import PostSerializer, PhotoListSerializer, PostReplySerializer, PostTextSerializer, \
    PostPathSerializer
from .models import Post, PostPhoto, PostReply, PostText, PostPath


class PostListAPIView(generics.ListCreateAPIView):
    queryset = Post.objects.all()
    serializer_class = PostSerializer
    # 멤버모델, 로그인뷰 회원가입뷰 완성 후 주석처리 없앨 것
    # permission_classes = (
    #     permissions.IsAuthenticatedOrReadOnly,
    # )

    def perform_create(self, serializer):
        serializer.save(author=self.request.user)

class PostDetailAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Post.objects.all()
    serializer_class = PostSerializer



class PostReplyAPIView(generics.ListCreateAPIView):
    queryset = PostReply.objects.all()
    serializer_class = PostReplySerializer

    def perform_create(self, serializer):
        serializer.save(author=self.request.user)
class PostReplyUpdateAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = PostReply.objects.all()
    serializer_class = PostReplySerializer


class PostTextAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = PostText.objects.all()
    serializer_class = PostTextSerializer

class PostPathAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = PostPath.objects.all()
    serializer_class = PostPathSerializer

class PostPhotolistView(viewsets.ModelViewSet):
    serializer_class = PhotoListSerializer
    parser_classes = (MultiPartParser, FormParser,)
    queryset=PostPhoto.objects.all()




