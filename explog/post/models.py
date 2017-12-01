from django.contrib.auth import get_user_model
from django.db import models
# 유저 모델 및 뷰 수정 요망
User = get_user_model()
# Create your models here.

# Post 모델 - 여행기 한 개
class Post(models.Model):
    author=models.ForeignKey(User)
    title = models.CharField(max_length=30)

    # 여행 시작 날짜
    start_date=models.DateTimeField()

    # 여행 끝나는 날짜
    end_date=models.DateTimeField(blank=True,null=True)
    # 여행기 작성 시점
    created_at=models.DateTimeField(auto_now_add=True)
    # 여행기 수정 시점
    updated_at=models.DateTimeField(auto_now=True)

# 사진만 여러개를 한 PostContent 객체의 pk를 공유해서 여러 객체를 한꺼번에 올리게 만들 것
class PostContent(models.Model):
    post = models.ForeignKey(Post)
    content_type = models.CharField(max_length=3,blank=True,null=True)
    #choice 설정

class PostReply(models.Model):
    # 여행기 하나마다 댓글 - 글 하나마다 쓰는 것이 아님
    post = models.ForeignKey(Post)

    author = models.ForeignKey(User)


    content = models.CharField(max_length=100)
    # 작성시점
    created_at = models.DateTimeField(auto_now_add=True)
    # 수정시점
    updated_at = models.DateTimeField(auto_now=True)

# 글 하나 테이블
class PostText(models.Model):

    title = models.CharField(max_length=255)
    content = models.TextField()
    # 작성시점
    created_at = models.DateTimeField(auto_now_add=True)
    # 수정시점
    updated_at = models.DateTimeField(auto_now=True)
    post_content = models.ForeignKey(PostContent)

class PostPhotoGroup(models.Model):
    order = models.IntegerField()
    post_content = models.ForeignKey(PostContent)

# 사진 하나 테이블 - PostItem필드와 다대일 관계 만들어 사진 여러개를 한꺼번에 보여줄 수 있음
class PostPhoto(models.Model):
    photo = models.ImageField()
    # 작성시점
    created_at = models.DateTimeField(auto_now_add=True)
    # 수정시점
    updated_at = models.DateTimeField(auto_now=True)
    # PostPhotoGroup필드를 외래키로 가짐
    photo_group = models.ForeignKey(PostPhotoGroup)

# 경로 테이블
class PostPath(models.Model):
    post_content = models.ForeignKey(PostContent)
    # 위도경도 - 데이터 타입이 실수
    lat = models.FloatField()
    lng = models.FloatField()
