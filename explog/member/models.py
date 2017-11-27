from django.contrib.auth.models import AbstractUser
from django.db import models

# Create your models here.

# 임의로 만든 유저 모델 - 나중에 직접 수정해주세요

class User(AbstractUser):
    # state = ?
    img_profile = models.ImageField(upload_to='media')
    like_posts = models.ManyToManyField(
        'post.Post',
        related_name='like_users',
        blank=True,
        verbose_name='좋아요 누른 포스트 목록'
    )
    following_users = models.ManyToManyField(
        'self',
        symmetrical=False,
        through='Relation',
        related_name='followers',
    )

    def follow_toggle(self, user):
        # 1. 주어진 user가 User객체인지 확인
        #    아니면 raise ValueError()
        # 2. 주어진 user를 follow하고 있으면 해제
        #    안 하고 있으면 follow함
        if not isinstance(user, User):
            raise ValueError('"user" argument must be User instance!')

        relation, relation_created = self.following_user_relations.get_or_create(to_user=user)
        if relation_created:
            return True
        relation.delete()
        return False

class Relation(models.Model):
    # User의 follow목록을 가질 수 있도록
    # MTM에 대한 중개모델을 구성
    # from_user, to_user, created_at으로 3개의 필드를 사용
    from_user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='following_user_relations',
    )
    to_user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='follower_relations',
    )
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f'Relation (' \
               f'from: {self.from_user.username}, ' \
               f'to: {self.to_user.username})'

# 임의로 만든 유저 개인 세계여행 마커 - 나중에 수정 바람
class UserMarker(models.Model):
    user = models.ForeignKey(User)
    lat = models.FloatField()
    lng = models.FloatField()

    class Meta:
        pass
        # ordering = []
