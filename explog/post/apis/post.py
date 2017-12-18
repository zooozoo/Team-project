from datetime import datetime, timedelta, date

from django.db.models import Q
from rest_framework import filters
from rest_framework import generics
from rest_framework import permissions
from rest_framework import status
from rest_framework.generics import get_object_or_404
from rest_framework.mixins import ListModelMixin
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.response import Response

from post.models import Post, PostContent, PostText, PostPhoto, PostPath, PostLike, PostReply
from post.pagination import PostListPagination, PostCategoryPagination
from post.serializers import PostListSerializer, PostSerializer, PostContentSerializer, PostTextSerializer, \
    PostPhotoSerializer, PostPathSerializer, PostDetailSerializer, PostSearchSerializer, PostReplySerializer, PostUpateSerializer
from utils.permissions import IsPostAuthorOrReadOnly




now = datetime.now().date()
earlier=now - timedelta(days=3)


class PostListAPIView(generics.ListAPIView):
    '''
    포스트를 리스트로 보여줄 때 첫 사진도 함께 보여줘야 함
    3일 이내 좋아요 순으로 보여주는 것 또한 구현해야 함
    = 아직 구현하지 못함.
    '''

    serializer_class = PostListSerializer
    pagination_class = PostListPagination
    filter_backends = (filters.OrderingFilter,)
    ordering=('-num_liked','-pk')
    def get_queryset(self):

        queryset = Post.objects.filter(start_date__range=(earlier,now))
        return queryset

class PostCategoryListAPIView(generics.ListAPIView):
    serializer_class = PostListSerializer
    pagination_class = PostCategoryPagination
    lookup_url_kwarg = 'category'
    filter_backends = (filters.OrderingFilter,)
    ordering=('-pk',)

    def get_queryset(self):
        queryset = Post.objects.filter(continent=self.kwargs['category'])

        return queryset


class PostCreateAPIView(generics.CreateAPIView):
    '''
    Post 만드는 API

    '''
    queryset = Post.objects.all()
    serializer_class = PostSerializer

    # 멤버모델, 로그인뷰 회원가입뷰 완성 후 주석처리 없앨 것
    permission_classes = (
        permissions.IsAuthenticated,
    )

    def perform_create(self, serializer):
        serializer.save(author=self.request.user)

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        instance = Post.objects.get(pk=serializer.data['pk'])
        data = PostListSerializer(instance).data

        return Response(data, status=status.HTTP_201_CREATED, headers=headers)


class PostDetailAPIView(ListModelMixin, generics.GenericAPIView):
    '''
    여행기 내의 내용을 보여주기 위한 API
    데이터 모델이 복잡한 관계로 로직이 복잡 - 트러블슈팅 필요
    '''
    lookup_url_kwarg = 'post_pk'
    queryset = Post.objects.all()

    content_serializer = PostContentSerializer
    text_serializer = PostTextSerializer
    photo_serializer = PostPhotoSerializer
    path_serializer = PostPathSerializer

    def list(self, request, *args, **kwargs):
        data = {"post_content":[]}
        post_pk = self.get_object().pk


        post_content_queryset = PostContent.objects.filter(post=post_pk).order_by('order')
        for queryset in post_content_queryset:
            if queryset.content_type == 'txt':
                post_content_serializer = self.content_serializer(queryset)
                text_qs = PostText.objects.get(post_content=queryset)
                text_serializer = self.text_serializer(text_qs)
                dic = post_content_serializer.data
                dic.update({'content'.format(queryset.pk):text_serializer.data})
                data["post_content"].append(
                    dic

                )

            elif queryset.content_type == 'img':
                post_content_serializer = self.content_serializer(queryset)
                photo_qs = PostPhoto.objects.get(post_content=queryset)
                photo_serializer = self.photo_serializer(photo_qs)
                dic = post_content_serializer.data
                dic.update({"content".format(queryset.pk): photo_serializer.data})
                data["post_content"].append(
                    dic

                )
            elif queryset.content_type == 'path':
                post_content_serializer = self.content_serializer(queryset)
                path_qs = PostPath.objects.get(post_content=queryset)
                path_serializer = self.path_serializer(path_qs)
                dic=post_content_serializer.data
                dic.update({"content".format(queryset.pk): path_serializer.data})
                data["post_content"].append(
                    dic

                )

        #reply=PostReplySerializer(PostReply.objects.filter(post=post_pk),many=True)
        #data.update({"post_reply":reply.data})
        return Response(data)

    def get(self, request, *args, **kwargs):
        return self.list(request, *args, **kwargs)

        # class PostDetailAPIView(generics.ListAPIView):
        #     queryset = PostContent.objects.filter()
        #     lookup_url_kwarg = 'post_pk'
        #     serializer_class = PostContentSerializer
        #
        #
        #
        # 멤버모델, 로그인뷰 회원가입뷰 완성 후 주석처리 없앨 것
        # permission_classes = (
        #    IsPostAuthorOrReadOnly,
        # )


class PostDeleteUpdateAPIView(generics.RetrieveUpdateDestroyAPIView):
    '''
    여행기 하나를 삭제하기 위한 API

    '''
    lookup_url_kwarg = 'post_pk'
    serializer_class = PostUpateSerializer
    permission_classes = (
        IsPostAuthorOrReadOnly,
    )

    def get_object(self):
        instance = get_object_or_404(Post.objects.filter(pk=self.kwargs['post_pk']))
        self.check_object_permissions(self.request, instance)

        return instance


# 포스트 좋아요 & 좋아요 취소 토글
class PostLikeToggle(generics.GenericAPIView):
    '''
    포스트에 좋아요를 누르기 위한 API
    '''
    queryset = Post.objects.all()
    lookup_url_kwarg = 'post_pk'
    permission_classes = (
        # 회원만 좋아요 가능
        IsAuthenticatedOrReadOnly,
    )

    def get_object(self):
        instance = get_object_or_404(Post.objects.filter(pk=self.kwargs['post_pk']))
        self.check_object_permissions(self.request, instance)

        return instance

    # /post/post_pk/like/ 에 POST 요청
    def post(self, request, *args, **kwargs):
        # pk 값으로 필터해서 Post 인스턴스 하나 가져옴
        instance = self.get_object()
        # 현재 로그인된 유저. AnonymousUser인 경우 permission에서 거름.
        user = request.user

        # 현재 로그인된 유저가 Post 인스턴스의 liked 목록에 있으면
        if user in instance.liked.all():
            # PostLike 테이블에서 해당 관계 삭제
            liked = PostLike.objects.get(author_id=user.pk, post_id=instance.pk)
            liked.delete()
            instance.save_num_liked()  # Post의 num_liked 업데이트
            instance.author.save_total_liked()  # User의 total_liked 업데이트

        # 없으면
        else:
            # PostLike 테이블에서 관계 생성
            PostLike.objects.create(author_id=user.pk, post_id=instance.pk)
            instance.save_num_liked()  # Post의 num_liked 업데이트
            instance.author.save_total_liked()  # User의 total_liked 업데이트

        # 업데이트된 instance를 PostSerializer에 넣어 직렬화하여 응답으로 돌려줌
        # serializer만 수정하면 될듯
        data = {
            "post": PostListSerializer(instance).data
        }
        return Response(data)


class PostSearchAPIView(generics.GenericAPIView):
    serializer_class = PostSearchSerializer


    def post(self,request):
        word=request.data['word']
        # 쿼리는 구현해야 할듯
        qs=Post.objects.filter(Q(title__contains=word) | Q(author__username__contains=word) | Q(author__email__contains=word)).order_by('-pk',)

        return Response(PostListSerializer(qs,many=True).data,)


