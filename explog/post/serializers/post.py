import datetime
from rest_framework import serializers
from rest_framework import status
from rest_framework.exceptions import _get_error_details, APIException

from member.serializers import UserSerializer
from post.models import Post

class ValidationError(APIException):
    status_code = status.HTTP_400_BAD_REQUEST
    default_detail = ('Invalid input.')
    default_code = 'invalid'

    def __init__(self, detail=None, code=None):
        if detail is None:
            detail = self.default_detail
        if code is None:
            code = self.default_code

        # For validation failures, we may collect many errors together,
        # so the details should always be coerced to a list if not already.
        if not isinstance(detail, dict) and not isinstance(detail, list):
            detail = detail

        self.detail = _get_error_details(detail, code)


class PostSerializer(serializers.ModelSerializer):
    # User 정보를 author에 표현하기 위해 멤버 모델 완성 후 바꿔줘야함


    class Meta:
        model = Post
        fields = (
            'pk',

            'title',
            'start_date',
            'end_date',
            'img',
            'continent',

        )

    def validate(self, data):
        start_date = data['start_date']
        end_date = data['end_date']
        if start_date-end_date > datetime.timedelta(days=0):
            raise ValidationError('여행 시작날짜보다 끝나는 날짜가 더 이전입니다.')
        return data

class PostUpateSerializer(serializers.ModelSerializer):
    # User 정보를 author에 표현하기 위해 멤버 모델 완성 후 바꿔줘야함


    class Meta:
        model = Post
        fields = (
            'pk',
            'author',
            'title',
            'start_date',
            'end_date',
            'img',
            'continent',

        )


class PostListSerializer(serializers.ModelSerializer):
    # User 정보를 author에 표현하기 위해 멤버 모델 완성 후 바꿔줘야함
    author = UserSerializer()

    # PostList뷰에서 Post의 첫 사진을 커버로 이용하기 위한 필드
    # method필드가 아니라 릴레이션필드를 사용해야함.

    class Meta:
        model = Post
        fields = (
            'pk',
            'author',
            'title',
            'start_date',
            'end_date',
            'img',
            'continent',
            'liked',
            'num_liked',

        )


class PostDetailSerializer(serializers.ModelSerializer):
    # User 정보를 author에 표현하기 위해 멤버 모델 완성 후 바꿔줘야함
    author = UserSerializer()
    content = serializers.StringRelatedField(many=True)
    reply = serializers.StringRelatedField(many=True)
    like = serializers.StringRelatedField(many=True)

    class Meta:
        model = Post
        fields = (
            'pk',
            'author',
            'title',
            'start_date',
            'end_date',
            'img',
            'content',
            'reply',
            'like',
        )

        # 역참조 postreply.set relationfield


# 검색어를 받는 시리얼라이저 초안

class PostSearchSerializer(serializers.Serializer):
    word = serializers.CharField()
