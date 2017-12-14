from rest_framework import serializers

from member.serializers import UserSerializer
from post.models import PostReply


class PostReplySerializer(serializers.ModelSerializer):


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

