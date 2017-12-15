from django.conf import settings
from django.contrib.auth import get_user_model
from django.db import models

User = get_user_model()

CONTINENT_CHOICES = (
    ("1", "Asia"),
    ("2", "Europe"),
    ("3", "North America"),
    ("4", "South America"),
    ("5", "Africa"),
    ("6", "Oceania"),
)


# Post 모델 - 여행기 한 개
class Post(models.Model):
    # 작성자 - Post모델과 외래키로 연결
    author = models.ForeignKey(User, on_delete=models.CASCADE, related_name='posts')
    # 여행기의 제목 - 여행기 내용 중 글에도 title이 존
    title = models.CharField(max_length=30)
    # 여행 시작 날짜

    start_date = models.DateTimeField(blank=True, null=True)

    # 여행 끝나는 날짜
    end_date = models.DateTimeField(blank=True, null=True)
    # 여행기 작성 시점
    # 여행기 수정 시점
    updated_at = models.DateTimeField(auto_now=True)
    # 포스트 기본 이미지 필드
    img = models.ImageField()
    # 여행기 대륙별 구분을 위한 필드
    continent = models.CharField(choices=CONTINENT_CHOICES, max_length=20)
    # 좋아요 갯수를 표현하기 위한 필드
    liked = models.ManyToManyField(
        settings.AUTH_USER_MODEL,
        through='PostLike',
        related_name='liked_posts'
    )
    num_liked = models.IntegerField(default=0)

    # 자신을 좋아요한 횟수를 num_liked 필드에 저장
    def save_num_liked(self):
        self.num_liked = self.liked.count()
        self.save()

    class meta:
        ordering = ['-pk', ]


CONTENT_CHOICES = (
    ("txt", "text"),
    ("img", "photo"),
    ("path", "path"),
)


# choice필드로 만듦
# 여행기 내에 들어가는 내용들을 구분하고 order를 주기 위한 클래스
class PostContent(models.Model):
    # 여행기를 외래키로 가짐
    post = models.ForeignKey(Post, related_name='content')
    # 내용의 형식을 구분하기 위한 필드
    content_type = models.CharField(max_length=4, choices=CONTENT_CHOICES)
    # 여행기 내용의 순서를 구분하기 위한 필드
    order = models.IntegerField(default=1)

    def __str__(self):
        return '{} ,{}, {}'.format(self.post, self.content_type, self.order)

    def __unicode__(self):
        return '{} ,{}, {}'.format(self.post, self.content_type, self.order)

    # 해당 클래스의 레코드 순서는 order 기준
    class Meta:
        ordering = ['order']


# 여행기 하나마다 댓글 - 글 하나마다 쓰는 것이 아님
class PostReply(models.Model):
    # 여행기 하나를 외래키로 가짐
    post = models.ForeignKey(Post, on_delete=models.CASCADE, related_name='reply')
    # 댓글 작성자 - User 모델을 외래키로 가짐
    author = models.ForeignKey(User, on_delete=models.CASCADE)

    # 댓글의 내용
    content = models.CharField(max_length=100)
    # 작성시점
    created_at = models.DateTimeField(auto_now_add=True)
    # 수정시점
    updated_at = models.DateTimeField(auto_now=True)

    # 댓글 순서는 작성된 시점을 기준으로
    class Meta:
        ordering = ['created_at']

    def __unicode__(self):
        return '{},{},{}'.format(self.author, self.content, self.created_at)


# 글 하나 테이블
class PostText(models.Model):
    # 글의 내용
    content = models.TextField()
    # 작성시점
    created_at = models.DateTimeField(blank=True, null=True)
    # 수정시점
    updated_at = models.DateTimeField(auto_now=True)
    # 여행기 내용 클래스를 외래키로 가짐
    post_content = models.ForeignKey(PostContent, on_delete=models.CASCADE, related_name='text')

    class Meta:
        ordering = ['created_at']

    def ___str__(self):
        return 'title:{} content:{} created_at:{}'.format(self.title, self.content, self.created_at)

    def __unicode__(self):
        return 'title:{} content:{} created_at:{}'.format(self.title, self.content,
                                                          self.created_at)  # class PostPhotoGroup(models.Model):


# order = models.IntegerField()
#     post_content = models.ForeignKey(PostContent)

# 사진 하나 테이블 - PostPhotoGroup필드와 다대일 관계 만들어 사진 여러개를 한꺼번에 보여주는 것 구현 - 계획 중
class PostPhoto(models.Model):
    # 사진 파일의 URL 필드
    photo = models.ImageField()
    # 작성시점
    created_at = models.DateTimeField(auto_now_add=True)
    # 수정시점
    updated_at = models.DateTimeField(auto_now=True)
    # PostPhotoGroup필드를 외래키로 가짐 - 계획
    # photo_group = models.ForeignKey(PostPhotoGroup)

    # 여행기 내용 클래스를 외래키로 가짐
    post_content = models.ForeignKey(PostContent, on_delete=models.CASCADE, related_name='photo')

    class Meta:
        ordering = ['created_at']

    def __unicode__(self):
        return 'photo:{}, created_at:{}'.format(self.photo, self.created_at)

    def __str__(self):
        return 'photo:{}, created_at:{}'.format(self.photo, self.created_at)


# 경로 테이블
class PostPath(models.Model):
    # 여행기 내용 클래스를 외래키로 가짐
    post_content = models.ForeignKey(PostContent, on_delete=models.CASCADE, related_name='path')
    # 위도경도 - 데이터 타입이 실수
    path_data = models.CharField(max_length=255)

    def __unicode__(self):
        return 'lat:{}, lng:{}'.format(self.lat, self.lng)

    def __str__(self):
        return 'lat:{}, lng:{}'.format(self.lat, self.lng)  # 여행기 하나에 좋아요 기능을 구현하고 좋아요 받는 숫자를 저장하기 위한 클래스


class PostLike(models.Model):
    # 좋아요를 누른 사용자를 저장하기 위한 외래키 관계
    author = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    # 좋아요를 받는 포스트를 표현하기 위한 외래키 관계
    post = models.ForeignKey(Post, on_delete=models.CASCADE, related_name='like')
    # 좋아요 한 날짜
    liked_date = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f'{self.author} liked {self.post}'

    class Meta:
        ordering = ['-liked_date']
