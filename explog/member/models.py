from django.contrib.auth.models import AbstractUser
from django.db import models





# settings.AUTH_USER_MODEL
class User(AbstractUser):

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
    REQUIRED_FIELDS = ['username']
