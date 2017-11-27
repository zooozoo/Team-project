from django.db import models

# Create your models here.

class Post(models.Model):
    user=models.ForeignKey()
    title = models.CharField(max_length=255)
    startdate=models.DateTimeField()
    enddate=models.DateTimeField(blank=True,null=True)
    created_at=models.DateTimeField(auto_now_add=True)
    updated_at=models.DateTimeField(auto_now=True)

class PostReply(models.Model):
    post = models.ForeignKey()
    user = models.ForeignKey()
    content = models.CharField(max_length=100)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)


class PostText(models.Model):
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)


class PostPhoto(models.Model):
    photo = models.ImageField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class PostItem(models.Model):
    post = models.ForeignKey()
    # order = ?
    type = models.SmallIntegerField()
class PostPath(models.Model):
    post = models.ForeignKey()
    # order = ?
    lat = models.FloatField()
    lng = models.FloatField()
