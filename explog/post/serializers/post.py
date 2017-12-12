from rest_framework import serializers

from member.serializers import UserSerializer
from post.models import Post


class PostSerializer(serializers.ModelSerializer):
    # User 정보를 author에 표현하기 위해 멤버 모델 완성 후 바꿔줘야함


    class Meta:
        model = Post
        fields = (
            'pk',

            'title',
            'start_date',
            'end_date',
            'created_at',
            'continent',

        )



class PostListSerializer(serializers.ModelSerializer):
    # User 정보를 author에 표현하기 위해 멤버 모델 완성 후 바꿔줘야함
    author = UserSerializer()

    # PostList뷰에서 Post의 첫 사진을 커버로 이용하기 위한 필드
    # method필드가 아니라 릴레이션필드를 사용해야함.

    class Meta:
        model = Post
        fields = (
            'pk',
            'author',
            'title',
            'start_date',
            'end_date',
            'created_at',
            'continent',
            'liked',
            'num_liked',

        )

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
            'created_at',
            'content',
            'reply',
            'like',
        )

        # 역참조 postreply.set relationfield


# 검색어를 받는 시리얼라이저 초안

class PostSearchSerializer(serializers.Serializer):
    word = serializers.CharField()
