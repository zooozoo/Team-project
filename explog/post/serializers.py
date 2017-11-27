from rest_framework import serializers

from .models import Post, PostReply, PostText, PostPath, PostPhoto, PostItem


class PostSerializer(serializers.ModelSerializer):
    # User 정보를 author에 표현하기 위해 멤버 모델 완성 후 바꿔줘야함
    #author = UserSerializer()

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

class PostListSerializer(serializers.ModelSerializer):
    # User 정보를 author에 표현하기 위해 멤버 모델 완성 후 바꿔줘야함
    #author = UserSerializer()
    photo = serializers.SerializerMethodField()
    class Meta:
        model = Post
        fields =(
            'pk',
            'author',
            'title',
            'start_date',
            'end_date',
            'created_at',
            'photo',

        )
    def get_photo(self,obj):
        obj_pk = obj.pk
        photo_qs = PostPhoto.objects.filter(post=obj_pk).first()
        photo = PostPhotoSerializer(photo_qs, many=False).data
        return photo


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

class PostTextSerializer(serializers.ModelSerializer):
    class Meta:
        model = PostText
        fields = (
            'pk',
            'title',
            'content',
            'created_at',
            'post',

        )


class PostPhotoSerializer(serializers.ModelSerializer):
    class Meta:
        model = PostPhoto
        fields =(
            'pk',
            'photo',
            'created_at',
            'content_group',
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
        content_group=PostItem.objects.latest('created_at')
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
            'post',

        )


class PostDetailSerializer(serializers.ModelSerializer):
    # User 정보를 author에 표현하기 위해 멤버 모델 완성 후 바꿔줘야함
    #author = UserSerializer()
    text = serializers.SerializerMethodField()
    photo = serializers.SerializerMethodField()
    path = serializers.SerializerMethodField()
    class Meta:
        model = Post
        fields =(
            'pk',
            'author',
            'title',
            'start_date',
            'end_date',
            'created_at',
            'text',
            'photo',
            'path',
        )

    def get_text(self,obj):
        obj_pk = obj.pk
        text_qs = PostText.objects.filter(post=obj_pk)
        text = PostTextSerializer(text_qs,many=True).data
        return text

    def get_photo(self,obj):
        obj_pk = obj.pk
        photo_qs = PostText.objects.filter(post=obj_pk)
        photo = PostTextSerializer(photo_qs,many=True).data
        return photo
    def get_path(self,obj):
        obj_pk = obj.pk
        path_qs = PostText.objects.filter(post=obj_pk)
        path = PostTextSerializer(path_qs,many=True).data
        return path

