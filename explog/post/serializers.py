from rest_framework import serializers

from member.serializers import UserSerializer
from .models import Post, PostReply, PostText, PostPath, PostPhoto, PostContent


class PostSerializer(serializers.ModelSerializer):
    # User 정보를 author에 표현하기 위해 멤버 모델 완성 후 바꿔줘야함
    author = UserSerializer()

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

# PostList 뷰에서 Post의 첫 번째 사진을 보여주기위한 시리얼라이저
class PostListSerializer(serializers.ModelSerializer):
    # User 정보를 author에 표현하기 위해 멤버 모델 완성 후 바꿔줘야함
    author = UserSerializer()

    # PostList뷰에서 Post의 첫 사진을 커버로 이용하기 위한 필드
    # method필드가 아니라 릴레이션필드를 사용해야함.
    #PostContent = serializers.StringRelatedField()
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

class PostContentSerializer(serializers.ModelSerializer):
    class Meta:
        model = PostContent
        fields = (

            'order',
            'content_type',
        )


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

class PostTextSerializer(serializers.ModelSerializer):

    class Meta:
        model = PostText
        fields = (
            'pk',
            'title',
            'content',
            'created_at',
            'post_content',

        )


class PostPhotoSerializer(serializers.ModelSerializer):

    class Meta:
        model = PostPhoto
        fields =(
            'pk',
            'photo',
            'created_at',
            'photo_group',
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
        content_group=PostContent.objects.latest('created_at')
        photo=validated_data.pop('photo')
        for img in photo:
            photo=PostPhoto.objects.create(photo=img,content_group=content_group,**validated_data)
        return photo


class PostPathSerializer(serializers.ModelSerializer):

    class Meta:
        model = PostPath
        fields = (
            'pk',
            'lat',
            'lng',


        )
class PostPathCreateSerializer(serializers.ModelSerializer):
    post_content=serializers.ReadOnlyField()
    class Meta:
        model= PostPath
        fields = (
            'pk',
            'lat',
            'lng',
            'post_content',
        )

class PostDetailSerializer(serializers.ModelSerializer):
    # User 정보를 author에 표현하기 위해 멤버 모델 완성 후 바꿔줘야함
    author = UserSerializer()


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



    #역참조 postreply.set relationfield





