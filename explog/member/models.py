from django.contrib.auth.models import AbstractUser
from django.db import models

from utils.custom_image_filed import DefaultStaticImageField


class User(AbstractUser):
    username = models.CharField(
        max_length=11,
        blank=False,
        unique=True,
    )
    img_profile = DefaultStaticImageField(
        upload_to='user',
        blank=True,
        default_image_path='default.jpg',
    )
    email = models.EmailField(
        unique=True,
        blank=False,
    )
    # 총 좋아요 수
    total_liked = models.IntegerField(default=0)
    badge = models.IntegerField(default=0)

    USERNAME_FIELD = 'email'
    # createsuperuser 명령을 할 때 'username'을 물어보지 않아
    # 발생했던 오류를 잡기위해 'username'추가함
    REQUIRED_FIELDS = ['username']

    # 정방향이 내가 팔로우 하는 사람
    # 역방향이 나를 팔로우 하는사람
    following_users = models.ManyToManyField(
        'self',
        symmetrical=False,
        through='Relation',
        related_name='followers',
    )

    # 유저의 모든 포스트들이 받은 좋아요 갯수를 총합하여 total_liked 필드에 저장
    def save_total_liked(self, *args, **kwargs):
        posts = self.posts.all()
        total_liked = sum([i.num_liked for i in posts])
        self.total_liked = total_liked
        self.save(*args, **kwargs)

    def add_badge_count(self):
        self.badge += 1

    def reset_badge_count(self):
        self.badge = 0


class Relation(models.Model):
    # 내가 팔로우 하는 사람
    from_user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='following_relations',
    )

    # 나를 팔로우 하는 사람
    to_user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='follower_relations',
    )

    def __str__(self):
        return f'Relation (' \
               f'from: {self.from_user.username}, ' \
               f'to: {self.to_user.username})'
