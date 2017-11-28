from django.contrib.auth.base_user import AbstractBaseUser
from django.db import models


class User(AbstractBaseUser):
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
    REQUIRED_FIELDS = []