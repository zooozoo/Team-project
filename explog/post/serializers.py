from rest_framework import serializers
from rest_framework.fields import CurrentUserDefault
from rest_framework.relations import PrimaryKeyRelatedField

from member.serializers import UserSerializer
from .models import (
    Post,
    SubPost,
    PostPhoto,
)


class PostSerializer(serializers.ModelSerializer):
    # User 정보를 author에 표현하기 위해 멤버 모델 완성 후 바꿔줘야함
    # author = UserSerializer()
    author = serializers.SerializerMethodField(read_only=True)

    class Meta:
        model = Post
        fields = (
            'pk',
            'author',
            'title',
            'start_date',
            'end_date',
            'created_at',
        )

    def get_author(self, obj):
        return obj.author.username


#
#
# PostList 뷰에서 Post의 첫 번째 사진을 보여주기위한 시리얼라이저
class PostListSerializer(serializers.ModelSerializer):
    # User 정보를 author에 표현하기 위해 멤버 모델 완성 후 바꿔줘야함
    # author = UserSerializer()

    # PostList뷰에서 Post의 첫 사진을 커버로 이용하기 위한 필드
    # photo = serializers.SerializerMethodField()
    author = serializers.SerializerMethodField()

    class Meta:
        model = Post
        fields = (
            'pk',
            'author',
            'title',
            'start_date',
            'end_date',
            'created_at',
            # 'photo',
            # 'subpost',
        )

    # 메소드필드에 필요한 데이터를 넣는 법
    # get_필드이름
    # def get_photo(self, obj):
    #     # post의 pk를 받음
    #     obj_pk = obj.pk
    #     # post에 올려진 가장 첫번째 사진을 가져오기
    #     post
    #     # post의 pk를 이용하여 필요한 객체를 얻음
    #     photo_qs = PostPhoto.objects.filter(post=obj_pk).first()
    #     # photo 데이터 직렬화 - 한 개의 데이터는 many=False
    #     photo = PostPhotoSerializer(photo_qs, many=False).data
    #     return photo

    def get_author(self, obj):
        return obj.author.username

class CreateSubPostSerializer(serializers.ModelSerializer):
    author = serializers.SerializerMethodField()

    class Meta:
        model = SubPost
        fields = (
            'pk',
            'post',
            'author',
            'content',
            'created_at',
            # 'photo',
        )

    def get_author(self, obj):
        return obj.author.username

#
# class PostReplySerializer(serializers.ModelSerializer):
#     # User 정보를 author에 표현하기 위해 멤버 모델 완성 후 바꿔줘야함
#     # author = UserSerializer()
#
#     author = serializers.SerializerMethodField()
#
#     class Meta:
#         model = PostReply
#         fields = (
#             'pk',
#             'post',
#             'author',
#             'content',
#             'created_at',
#         )
#
#     def get_author(self, obj):
#         return obj.author.username
#
#

# class PostPhotoSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = PostPhoto
#         fields = (
#             'pk',
#             'photo',
#             'created_at',
#             'content_group',
#             'author',
#         )
#
#
# class PostItemSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = PostItem
#         fields = (
#             'pk',
#             'post',
#
#         )
#
#
# # PostPhoto 객체를 여러 개 받기 위한 시리얼라이저
# # 강사님께 트러블슈팅 요망
# class PhotoListSerializer(serializers.Serializer):
#     photo = serializers.ListField(
#         # PostPhoto를 Image필드로 주었는데 여기서 Image필드인지 File필드인지 확인 필요
#         child=serializers.FileField(max_length=100000,
#                                     allow_empty_file=False,
#                                     use_url=False)
#     )
#
#     def create(self, validated_data):
#         content_group = PostItem.objects.latest('created_at')
#         photo = validated_data.pop('photo')
#         for img in photo:
#             photo = PostPhoto.objects.create(photo=img, content_group=content_group, **validated_data)
#         return photo
#
#
# class PostPathSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = PostPath
#         fields = (
#             'pk',
#             'lat',
#             'lng',
#             'post',
#
#         )
#
#
# class PostDetailSerializer(serializers.ModelSerializer):
#     # User 정보를 author에 표현하기 위해 멤버 모델 완성 후 바꿔줘야함
#     # author = UserSerializer()
#
#     # post detail에서 관련 내용들을 전부 가져오기 위한 메서드필드
#     text = serializers.SerializerMethodField()
#     photo = serializers.SerializerMethodField()
#     path = serializers.SerializerMethodField()
#     reply = serializers.SerializerMethodField()
#     author = serializers.SerializerMethodField()
#
#     class Meta:
#         model = Post
#         fields = (
#             'pk',
#             'author',
#             'title',
#             'start_date',
#             'end_date',
#             'created_at',
#             'text',
#             'photo',
#             'path',
#             'reply',
#         )
#
#     # get_필드이름 으로 메서드를 만들어줌
#     def get_text(self, obj):
#         # post의 pk
#         obj_pk = obj.pk
#         # post의 pk를 이용하여 필요한 객체를 가져옴
#         text_qs = PostText.objects.filter(post=obj_pk)
#         # 가져온 객체로 직렬화 - 여러 객체이므로 many=True
#         text = PostTextSerializer(text_qs, many=True).data
#         return text
#
#     def get_photo(self, obj):
#         obj_pk = obj.pk
#         photo_qs = PostText.objects.filter(post=obj_pk)
#         photo = PostTextSerializer(photo_qs, many=True).data
#         return photo
#
#     def get_path(self, obj):
#         obj_pk = obj.pk
#         path_qs = PostText.objects.filter(post=obj_pk)
#         path = PostTextSerializer(path_qs, many=True).data
#         return path
#
#     def get_reply(self, obj):
#         obj_pk = obj.pk
#         reply_qs = PostReply.objects.filter(post=obj_pk)
#         reply = PostReplySerializer(reply_qs, many=True).data
#         return reply
#
#     def get_author(self, obj):
#         return obj.author.username
