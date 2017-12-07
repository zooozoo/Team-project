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


class PostContent1Serializer(serializers.ModelSerializer):
    text = serializers.StringRelatedField()

    class Meta:
        model = PostContent
        fields = (
            'post',
            'order',
            'content_type',
            'text',
        )


class PostContent2Serializer(serializers.ModelSerializer):
    photo = serializers.StringRelatedField()

    class Meta:
        model = PostContent
        fields = (
            'post',
            'order',
            'content_type',
            'photo',
        )


class PostContent3Serializer(serializers.ModelSerializer):
    path = serializers.StringRelatedField()

    class Meta:
        model = PostContent
        fields = (
            'post',
            'order',
            'content_type',
            'path',
        )
