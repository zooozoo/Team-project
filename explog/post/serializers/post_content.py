from rest_framework import serializers

from post.models import PostContent


class PostContentSerializer(serializers.ModelSerializer):
    class Meta:
        model = PostContent
        fields = (
            'post',
            'order',
            'content_type',
        )

class PostContentListSerializer(serializers.ModelSerializer):
    class Meta:
        model = PostContent
        fields = (
            'pk',
            'post',
            'order',
            'content_type',
        )

