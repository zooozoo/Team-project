from rest_framework import serializers

from member.serializers import UserSerializer
from post.models import PostReply


class PostReplySerializer(serializers.ModelSerializer):
    # User 정보를 author에 표현하기 위해 멤버 모델 완성 후 바꿔줘야함
    author = UserSerializer()

    class Meta:
        model = PostReply
        fields = (
            'pk',
            'post',
            'author',
            'content',
            'created_at',
        )


class PostReplyCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = PostReply
        fields = (
            'pk',
            'content',
            'created_at',
        )

