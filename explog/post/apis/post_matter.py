from rest_framework import generics
from rest_framework import permissions
from rest_framework import status
from rest_framework import viewsets
from rest_framework.generics import get_object_or_404
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.response import Response

from post.models import PostText, PostPath, PostPhoto, Post, PostContent
from post.serializers import PostTextSerializer, PostPathSerializer, PostPhotoSerializer, PostTextListSerializer, \
    PostContentListSerializer
from utils.permissions import IsMatterAuthorOrReadOnly


class PostTextAPIView(generics.RetrieveUpdateDestroyAPIView):
    '''
    여행기 내의 글 수정/삭제 API
    '''
    serializer_class = PostTextSerializer
    lookup_url_kwarg = 'text_pk'

    permission_classes = (
        IsMatterAuthorOrReadOnly,
    )

    def get_object(self):

        instance = get_object_or_404(PostText.objects.filter(pk=self.kwargs['text_pk']))
        self.check_object_permissions(self.request, instance)

        return instance


class PostPathAPIView(generics.RetrieveUpdateDestroyAPIView):
    '''
    여행 경로 레코드 수정/삭제 API
    '''
    serializer_class = PostPathSerializer
    lookup_url_kwarg = 'path_pk'

    permission_classes = (
        IsMatterAuthorOrReadOnly,
    )

    def get_object(self):

        instance = get_object_or_404(PostPath.objects.filter(pk=self.kwargs['path_pk']))
        self.check_object_permissions(self.request, instance)

        return instance


class PostPhotoAPIView(generics.RetrieveUpdateDestroyAPIView):
    '''
    여행기 내의 사진 수정/삭제 API
    '''
    serializer_class = PostPhotoSerializer
    lookup_url_kwarg = 'photo_pk'
    permission_classes = (
        IsMatterAuthorOrReadOnly,
    )
    def get_object(self):


        instance = get_object_or_404(PostPhoto.objects.filter(pk=self.kwargs['photo_pk']))
        self.check_object_permissions(self.request, instance)

        return instance



class PostTextCreateAPIView(generics.CreateAPIView):
    '''
    여행기 내용 중 글 생성을 위한 API
    연결된 PostContent 레코드까지 함께 생성
    '''
    queryset = Post.objects.all()
    serializer_class = PostTextSerializer
    lookup_url_kwarg = 'post_pk'
    permission_classes = (
        permissions.IsAuthenticated,
    )

    def perform_create(self, serializer):

        if PostContent.objects.first() is None:

            instance = self.get_object()
            post_content = PostContent.objects.create(post=instance, content_type='txt')
            serializer.save(post_content=post_content)

        else:
            instance = self.get_object()

            post_content_order = PostContent.objects.latest(field_name='pk').order + 1
            post_content = PostContent.objects.create(post=instance, order=post_content_order, content_type='txt')

            serializer.save(post_content=post_content)

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        text = PostText.objects.get(pk=serializer.data['pk'])
        instance = PostContent.objects.get(pk=text.post_content.pk)
        data = PostContentListSerializer(instance).data
        data.update({"content": PostTextSerializer(text).data})

        return Response(data, status=status.HTTP_201_CREATED, headers=headers)


class PostPhotoCreateAPIView(generics.CreateAPIView):
    '''
    여행기 내용 중 사진 생성을 위한 API
    연결된 PostContent 레코드 함께 생성
    '''
    queryset = Post.objects.all()
    serializer_class = PostPhotoSerializer
    lookup_url_kwarg = 'post_pk'
    permission_classes = (
        permissions.IsAuthenticated,
    )

    def perform_create(self, serializer):

        if PostContent.objects.first() is None:

            instance = self.get_object()
            post_content = PostContent.objects.create(post=instance, content_type='img')
            serializer.save(post_content=post_content)

        else:
            instance = self.get_object()

            post_content_order = PostContent.objects.latest(field_name='pk').order + 1
            post_content = PostContent.objects.create(post=instance, order=post_content_order, content_type='img')

            serializer.save(post_content=post_content)
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        photo = PostPhoto.objects.get(pk=serializer.data['pk'])
        instance = PostContent.objects.get(pk=photo.post_content.pk)
        data = PostContentListSerializer(instance).data
        data.update({"content": PostPhotoSerializer(photo).data})

        return Response(data, status=status.HTTP_201_CREATED, headers=headers)



class PostPathCreateAPIView(generics.CreateAPIView):
    '''
    여행기 내용 중 경로 부분 생성을 위한 API
    연결된 PostContent 레코드 함께 생성
    '''
    queryset = Post.objects.all()
    serializer_class = PostPathSerializer
    lookup_url_kwarg = 'post_pk'
    permission_classes = (
        permissions.IsAuthenticated,
    )

    def perform_create(self, serializer):

        if PostContent.objects.first() is None:

            instance = self.get_object()
            post_content = PostContent.objects.create(post=instance, content_type='path')
            serializer.save(post_content=post_content)

        else:
            instance = self.get_object()

            post_content_order = PostContent.objects.latest(field_name='pk').order + 1
            post_content = PostContent.objects.create(post=instance, order=post_content_order, content_type='path')

            serializer.save(post_content=post_content)

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        path = PostPath.objects.get(pk=serializer.data['pk'])
        instance = PostContent.objects.get(pk=path.post_content.pk)
        data = PostContentListSerializer(instance).data
        data.update({"content": PostPathSerializer(path).data})

        return Response(data, status=status.HTTP_201_CREATED, headers=headers)

