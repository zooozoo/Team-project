from rest_framework import serializers

from .models import Post, PostReply, PostText, PostPath, PostPhoto, PostItem


class PostSerializer(serializers.ModelSerializer):

    class Meta:
        model = Post
        fields =(
            'pk',
            'author',
            'title',
            'start_date',
            'end_date',
            'created_at',


        )




class PostReplySerializer(serializers.ModelSerializer):
    class Meta:
        model = PostReply
        fields = (
            'pk',
            'author',
            'content',
            'created_at',
        )

class PostTextSerializer(serializers.ModelSerializer):
    class Meta:
        model = PostText
        fields = (
            'pk',
            'title',
            'content',
            'created_at',
            'group',

        )


class PostPhotoSerializer(serializers.ModelSerializer):
    class Meta:
        model = PostPhoto
        fields =(
            'pk',
            'photo',
            'created_at',
            'group',
        )


class PostItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = PostItem
        fields = (
            'pk',
            'post',

        )
# PostPhoto 객체를 여러 개 받기 위한 시리얼라이저
# 강사님께 트러블슈팅 요망
class PhotoListSerializer ( serializers.Serializer ) :
    photo = serializers.ListField(
                        # PostPhoto를 Image필드로 주었는데 여기서 Image필드인지 File필드인지 확인 필요
                       child=serializers.FileField( max_length=100000,
                                         allow_empty_file=False,
                                         use_url=False )
                                )
    def create(self, validated_data):
        group=PostItem.objects.latest('created_at')
        photo=validated_data.pop('photo')
        for img in photo:
            photo=PostPhoto.objects.create(photo=img,group=group,**validated_data)
        return photo


class PostPathSerializer(serializers.ModelSerializer):
    class Meta:
        model = PostPath
        fields = (
            'pk',
            'lat',
            'lng',
            'group',

        )
