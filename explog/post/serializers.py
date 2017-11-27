from rest_framework import serializers

from post.models import Post


class PostSerializer(serializers.ModelSerializer):

    class Meta:
        model = Post
        fields =




class PostReplySerializer(serializers.ModelSerializer):

    pass

class PostTextSerializer(serializers.ModelSerializer):

    pass

class PostPhotoSerializer(serializers.ModelSerializer):

    pass

class PostItemSerializer(serializers.ModelSerializer):

    pass

class PostPathSerializer(serializers.ModelSerializer):

    pass