from django.contrib.auth import get_user_model

from django.contrib.auth import get_user_model
from django.core.exceptions import ValidationError
from django.db import models

# 유저 모델 및 뷰 수정 요망
User = get_user_model()


# Post 모델 - 여행기 한 개
class Post(models.Model):
    author = models.ForeignKey(User)
    title = models.CharField(max_length=30)
    # 여행 시작 날짜
    start_date = models.DateTimeField()
    # 여행 끝나는 날짜
    end_date = models.DateTimeField(blank=True, null=True)
    # 여행기 작성 시점
    created_at = models.DateTimeField(auto_now_add=True)
    # 여행기 수정 시점
    updated_at = models.DateTimeField(auto_now=True)


# 글 하나 테이블
class SubPost(models.Model):
    post = models.ForeignKey(Post)
    author = models.ForeignKey(User)
    content = models.TextField()
    # 작성시점
    created_at = models.DateTimeField(auto_now_add=True)
    # 수정시점
    updated_at = models.DateTimeField(auto_now=True)


# 사진 하나 테이블 - PostItem필드와 다대일 관계 만들어 사진 여러개를 한꺼번에 보여줄 수 있음
class PostPhoto(models.Model):
    post = models.ForeignKey(Post)
    subpost = models.ForeignKey(SubPost)
    author = models.ForeignKey(User)
    photo = models.ImageField()
    # 작성시점
    created_at = models.DateTimeField(auto_now_add=True)
    # 수정시점
    updated_at = models.DateTimeField(auto_now=True)
    # PostItem필드를 외래키로 가짐


class PostReply(models.Model):
    # 여행기 하나마다 댓글 - 글 하나마다 쓰는 것이 아님
    post = models.ForeignKey(Post)
    author = models.ForeignKey(User)
    content = models.CharField(max_length=100)
    # 작성시점
    created_at = models.DateTimeField(auto_now_add=True)
    # 수정시점
    updated_at = models.DateTimeField(auto_now=True)


# 경로 테이블
class PostPath(models.Model):
    post = models.ForeignKey(Post)
    # 위도경도 - 데이터 타입이 실수
    lat = models.FloatField()
    lng = models.FloatField()
