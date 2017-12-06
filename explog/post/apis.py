# Create your views here.
from rest_framework import generics
from rest_framework import permissions
from rest_framework import status

from rest_framework import viewsets
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.response import Response

from .serializers import PostSerializer, PhotoListSerializer, PostReplySerializer, PostTextSerializer, \
    PostPathSerializer, PostDetailSerializer, PostListSerializer, PostContentSerializer, \
     PostPhotoSerializer, PostReplyCreateSerializer
from .models import Post, PostPhoto, PostReply, PostText, PostPath, PostContent

from utils.permissions import IsAuthorOrReadOnly


class PostListAPIView(generics.ListAPIView):
    '''
    포스트를 리스트로 보여줄 때 첫 사진도 함께 보여줘야 함
    3일 이내 좋아요 순으로 보여주는 것 또한 구현해야 함
    '''
    queryset = Post.objects.all()
    serializer_class = PostListSerializer


class PostCreateAPIView(generics.CreateAPIView):
    queryset = Post.objects.all()
    serializer_class = PostSerializer

    # 멤버모델, 로그인뷰 회원가입뷰 완성 후 주석처리 없앨 것
    permission_classes = (
        permissions.IsAuthenticatedOrReadOnly,
    )

    def perform_create(self, serializer):
        serializer.save(author=self.request.user)


class PostDetailAPIView(generics.ListAPIView):
    queryset = PostContent.objects.filter()
    lookup_url_kwarg = 'post_pk'
    serializer_class = PostContentSerializer



    # 멤버모델, 로그인뷰 회원가입뷰 완성 후 주석처리 없앨 것
    # permission_classes = (
    #    IsAuthorOrReadOnly,
    # )


class PostReplyListAPIView(generics.ListAPIView):


    serializer_class = PostReplySerializer

    def get_queryset(self):
        post_pk=self.kwargs['post_pk']

        return PostReply.objects.filter(post=post_pk)




class PostReplyCreateAPIView(generics.CreateAPIView):
    queryset = Post.objects.all()
    serializer_class = PostReplyCreateSerializer
    lookup_url_kwarg = 'post_pk'

    def perform_create(self, serializer):
        instance = self.get_object()
        serializer.save(author=self.request.user, post=instance)


class PostReplyUpdateAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = PostReply.objects.all()
    serializer_class = PostReplySerializer
    lookup_url_kwarg = 'reply_pk'
    # permission_classes = (
    #    IsAuthorOrReadOnly,
    # )

class PostContentAPIView(generics.RetrieveDestroyAPIView):
    queryset = PostContent.objects.all()
    serializer_class = PostContentSerializer
    lookup_url_kwarg = 'content_pk'


class PostTextAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = PostText.objects.all()
    serializer_class = PostTextSerializer
    lookup_url_kwarg = 'text_pk'


# permission_classes = (
#        IsAuthorOrReadOnly,
#    )



class PostPathAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = PostPath.objects.all()
    serializer_class = PostPathSerializer
    lookup_url_kwarg = 'path_pk'

# permission_classes = (
#       IsAuthorOrReadOnly,
#  )

class PostPhotoAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = PostPhoto.objects.all()
    serializer_class = PostPhotoSerializer
    lookup_url_kwarg = 'photo_pk'



# PostPhoto create뷰는 트러블 슈팅 필요
class PostPhotolistView(viewsets.ModelViewSet):
    serializer_class = PhotoListSerializer
    parser_classes = (MultiPartParser, FormParser,)
    queryset = PostPhoto.objects.all()


class PostTextCreateAPIView(generics.CreateAPIView):
    queryset = Post.objects.all()
    serializer_class = PostTextSerializer
    lookup_url_kwarg = 'post_pk'

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
    queryset = Post.objects.all()
    serializer_class = PostPhotoSerializer
    lookup_url_kwarg = 'post_pk'

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
    queryset = Post.objects.all()
    serializer_class = PostPathSerializer
    lookup_url_kwarg = 'post_pk'

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



