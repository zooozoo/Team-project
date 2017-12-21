import datetime

from django.contrib.auth import get_user_model
from rest_framework import serializers

from member.serializers import UserSerializer
from post.models import Post, PostLike

User = get_user_model()


class PostSerializer(serializers.ModelSerializer):
    # User 정보를 author에 표현하기 위해 멤버 모델 완성 후 바꿔줘야함


    class Meta:
        model = Post
        fields = (
            'pk',

            'title',
            'start_date',
            'end_date',
            'img',
            'continent',

        )

    def validate(self, data):
        start_date = data['start_date']
        end_date = data['end_date']
        if start_date - end_date > datetime.timedelta(days=0):
            raise serializers.ValidationError('여행 시작날짜보다 끝나는 날짜가 더 이전입니다.')
        return data


class PostUpateSerializer(serializers.ModelSerializer):
    # User 정보를 author에 표현하기 위해 멤버 모델 완성 후 바꿔줘야함


    class Meta:
        model = Post
        fields = (
            'pk',
            'author',
            'title',
            'start_date',
            'end_date',
            'img',
            'continent',

        )


class PostLikeSerializer(serializers.ModelSerializer):
    # User 정보를 author에 표현하기 위해 멤버 모델 완성 후 바꿔줘야함
    author = UserSerializer()

    # PostList뷰에서 Post의 첫 사진을 커버로 이용하기 위한 필드
    # method필드가 아니라 릴레이션필드를 사용해야함.
    liked = serializers.SerializerMethodField()

    class Meta:
        model = Post
        fields = (
            'pk',
            'author',
            'title',
            'start_date',
            'end_date',
            'img',
            'continent',
            'liked',
            'num_liked',

        )

    def get_liked(self, obj):
        Like = PostLike.objects.filter(post=obj)
        data = {}
        for qs in Like:
            data.update({"liker{}".format(User.objects.get(email=qs.author).pk): UserSerializer(
                User.objects.get(email=qs.author)).data})

        return data


class PostListSerializer(serializers.ModelSerializer):
    # User 정보를 author에 표현하기 위해 멤버 모델 완성 후 바꿔줘야함
    author = UserSerializer()

    # PostList뷰에서 Post의 첫 사진을 커버로 이용하기 위한 필드
    # method필드가 아니라 릴레이션필드를 사용해야함.
    img = serializers.SerializerMethodField()
    liked = serializers.SerializerMethodField()

    class Meta:
        model = Post
        fields = (
            'pk',
            'author',
            'title',
            'start_date',
            'end_date',
            'img',
            'continent',
            'liked',
            'num_liked',

        )


    def get_img(self, obj):
        return obj.img.url

    def get_liked(self, obj):
        Like = PostLike.objects.filter(post=obj)
        data = {}
        for qs in Like:
            data.update({"liker{}".format(User.objects.get(email=qs.author).pk): UserSerializer(
                User.objects.get(email=qs.author)).data})

        return data

class PostDetailSerializer(serializers.ModelSerializer):
    # User 정보를 author에 표현하기 위해 멤버 모델 완성 후 바꿔줘야함
    author = UserSerializer()
    content = serializers.StringRelatedField(many=True)
    reply = serializers.StringRelatedField(many=True)
    like = serializers.StringRelatedField(many=True)

    class Meta:
        model = Post
        fields = (
            'pk',
            'author',
            'title',
            'start_date',
            'end_date',
            'img',
            'content',
            'reply',
            'like',
        )

        # 역참조 postreply.set relationfield


# 검색어를 받는 시리얼라이저 초안

class PostSearchSerializer(serializers.Serializer):
    word = serializers.CharField()
