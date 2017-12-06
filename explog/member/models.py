from django.contrib.auth.models import AbstractUser
from django.db import models


class User(AbstractUser):
    username = models.CharField(
        max_length=11,
        blank=False,
        unique=True,
    )

    img_profile = models.ImageField(
        upload_to='user',
        blank=True,
        null=True,
    )
    email = models.EmailField(
        unique=True,
        blank=False,
    )
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


class Relation(models.Model):
    # 내가 팔로우 하는 사람
    from_user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='following_user_relations',
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
