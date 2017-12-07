from rest_framework import generics
from rest_framework import permissions
from rest_framework import viewsets
from rest_framework.parsers import MultiPartParser, FormParser

from post.models import PostText, PostPath, PostPhoto, Post, PostContent
from post.serializers import PostTextSerializer, PostPathSerializer, PostPhotoSerializer, PhotoListSerializer


class PostTextAPIView(generics.RetrieveUpdateDestroyAPIView):
    '''
    여행기 내의 글 수정/삭제 API
    '''
    serializer_class = PostTextSerializer
    lookup_url_kwarg = 'text_pk'

    permission_classes = (
        permissions.IsAuthenticatedOrReadOnly,
    )

    def get_object(self):

        instance = PostText.objects.get(pk=self.kwargs['text_pk'])

        return instance


class PostPathAPIView(generics.RetrieveUpdateDestroyAPIView):
    '''
    여행 경로 레코드 수정/삭제 API
    '''
    serializer_class = PostPathSerializer
    lookup_url_kwarg = 'path_pk'

    permission_classes = (
        permissions.IsAuthenticatedOrReadOnly,
    )

    def get_object(self):

        instance = PostPath.objects.get(pk=self.kwargs['path_pk'])

        return instance


class PostPhotoAPIView(generics.RetrieveUpdateDestroyAPIView):
    '''
    여행기 내의 사진 수정/삭제 API
    '''
    serializer_class = PostPhotoSerializer
    lookup_url_kwarg = 'photo_pk'

    def get_object(self):


        instance = PostPhoto.objects.get(pk=self.kwargs['photo_pk'])

        return instance


# PostPhoto create뷰는 트러블 슈팅 필요
class PostPhotolistView(viewsets.ModelViewSet):
    '''
    사진 여러 장 한번에 생성하기 위한 API - 미구현
    '''
    serializer_class = PhotoListSerializer
    parser_classes = (MultiPartParser, FormParser,)
    queryset = PostPhoto.objects.all()


class PostTextCreateAPIView(generics.CreateAPIView):
    '''
    여행기 내용 중 글 생성을 위한 API
    연결된 PostContent 레코드까지 함께 생성
    '''
    queryset = Post.objects.all()
    serializer_class = PostTextSerializer
    lookup_url_kwarg = 'post_pk'
    permission_classes = (
        permissions.IsAuthenticatedOrReadOnly,
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


class PostPhotoCreateAPIView(generics.CreateAPIView):
    '''
    여행기 내용 중 사진 생성을 위한 API
    연결된 PostContent 레코드 함께 생성
    '''
    queryset = Post.objects.all()
    serializer_class = PostPhotoSerializer
    lookup_url_kwarg = 'post_pk'
    permission_classes = (
        permissions.IsAuthenticatedOrReadOnly,
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


class PostPathCreateAPIView(generics.CreateAPIView):
    '''
    여행기 내용 중 경로 부분 생성을 위한 API
    연결된 PostContent 레코드 함께 생성
    '''
    queryset = Post.objects.all()
    serializer_class = PostPathSerializer
    lookup_url_kwarg = 'post_pk'
    permission_classes = (
        permissions.IsAuthenticatedOrReadOnly,
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
