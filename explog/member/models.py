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

