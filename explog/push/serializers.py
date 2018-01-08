from django.contrib.auth import get_user_model
from rest_framework import serializers

from post.models import PostLike

User = get_user_model()


class UserSerializer(serializers.ModelSerializer):
    img_profile = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = (
            'username',
            'img_profile',
        )

    def get_img_profile(self, obj):
        s = obj.img_profile.url
        return s.split('?')[0]


class PushListSerializer(serializers.ModelSerializer):
    author = UserSerializer()
    post = serializers.SerializerMethodField()

    class Meta:
        model = PostLike
        fields = (
            'liked_date',
            'author',
            'post',
        )

    def get_post(self, obj):
        return obj.post.title