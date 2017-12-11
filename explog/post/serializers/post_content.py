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

