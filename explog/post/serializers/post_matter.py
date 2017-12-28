from rest_framework import serializers

from post.models import PostContent, PostPhoto, PostPath, PostText
from post.serializers import PostContentSerializer, PostContentListSerializer


class PostTextSerializer(serializers.ModelSerializer):
    class Meta:
        model = PostText
        fields = (
            'pk',

            'content',
            'created_at',
            'type',

        )

class PostTextListSerializer(serializers.ModelSerializer):

    class Meta:
        model = PostText
        fields = (
            'pk',
            'post_content',
            'content',
            'created_at',
            'type',

        )



class PostPhotoSerializer(serializers.ModelSerializer):
    class Meta:
        model = PostPhoto
        fields = (
            'pk',
            'photo',
            'created_at',

        )


class PostPathCreateSerializer(serializers.Serializer):
    pk = serializers.IntegerField()
    path = serializers.CharField()
    order = serializers.IntegerField()


# PostPhoto 객체를 여러 개 받기 위한 시리얼라이저
# 강사님께 트러블슈팅 요망
# class PhotoListSerializer(serializers.Serializer):
#     photo = serializers.ListField(
#         # PostPhoto를 Image필드로 주었는데 여기서 Image필드인지 File필드인지 확인 필요
#         child=serializers.FileField(max_length=100000,
#                                     allow_empty_file=False,
#                                     use_url=False)
#     )
#
#     def create(self, validated_data):
#         content_group = PostContent.objects.latest('created_at')
#         photo = validated_data.pop('photo')
#         for img in photo:
#             photo = PostPhoto.objects.create(photo=img, content_group=content_group, **validated_data)
#         return photo


class PostPathSerializer(serializers.ModelSerializer):
    class Meta:
        model = PostPath
        fields = (
            'pk',
            'lat',
            'lng',
        )
