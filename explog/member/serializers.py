from django.core.validators import RegexValidator
from push_notifications.models import APNSDevice
from rest_framework import serializers
from rest_framework.authtoken.models import Token
from member.models import User
from post.models import Post


class APNsSerializer(serializers.ModelSerializer):
    class Meta:
        model = APNSDevice
        fields = (
            'registration_id',
        )

class UserSerializer(serializers.ModelSerializer):
    img_profile = serializers.SerializerMethodField()
    token = serializers.SerializerMethodField()

    apnsdevice_set = APNsSerializer(many=True)

    class Meta:
        model = User
        fields = (
            'pk',
            'username',
            'email',
            'img_profile',
            'token',
            'apnsdevice_set',
        )

    def get_img_profile(self, obj):
        s = obj.img_profile.url
        return s.split('?')[0]

    def get_token(self, obj):
        return Token.objects.get_or_create(user=obj)[0].key


class TokenSerializer(serializers.ModelSerializer):
    class Meta:
        model = Token
        fields = (
            'key',
        )


class SignupSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    email = serializers.EmailField(allow_blank=True)
    token = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = (
            'pk',
            'username',
            'email',
            'img_profile',
            'password',
            'token',
        )

    def validate_username(self, data):
        username_validater = RegexValidator("[a-zA-Z가-힣0-9]$")
        if 2 <= len(data) < 12:
            try:
                username_validater(data)
                return data
            except:
                raise serializers.ValidationError()
        else:
            raise serializers.ValidationError()

    def validate_email(self, data):
        if data:
            if User.objects.filter(email=data).exists():
                raise serializers.ValidationError()
            else:
                return data
        raise serializers.ValidationError()

    def create(self, validated_data):
        if validated_data.get('img_profile', None):
            return self.Meta.model.objects.create_user(
                username=validated_data['username'],
                password=validated_data['password'],
                img_profile=validated_data['img_profile'],
                email=validated_data['email'],
            )
        return self.Meta.model.objects.create_user(
            username=validated_data['username'],
            password=validated_data['password'],
            email=validated_data['email'],
        )

    def get_token(self, obj):
        return Token.objects.get_or_create(user=obj)[0].key


class FollwingSerializer(serializers.Serializer):
    from_user = serializers.IntegerField()
    to_user = serializers.IntegerField()

    def validate(self, data):
        if data['from_user'] == data['to_user']:
            raise serializers.ValidationError('자기 자신을 follow할 수 없습니다.')
        return data

    def validate_to_user(self, data):
        if User.objects.filter(pk=data).exists():
            return data
        raise serializers.ValidationError('존재하지 않는 user')


class UserProfileUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = (
            'username',
            'img_profile',
        )

    def update(self, instance, validated_data):
        self.instance.username = validated_data.get('username', instance.username)
        self.instance.img_profile = validated_data.get('img_profile', instance.img_profile)
        instance.save()
        return instance


class UserPasswordUpdateSerializer(serializers.Serializer):
    old_password = serializers.CharField(write_only=True)
    new_password = serializers.CharField(write_only=True)

    def validate_old_password(self, data):
        user = self.context['request'].user
        if user.check_password(data):
            return data
        raise serializers.ValidationError('잘못된 비밀번호 입니다.')

    def update(self, instance, validated_data):
        instance.set_password(validated_data['new_password'])
        instance.save()
        return instance


# psot list ordering을 위한 serializer
class PostListSerializer(serializers.ListSerializer):
    def to_representation(self, data):
        data = data.order_by('-pk', )
        return super(PostListSerializer, self).to_representation(data)


class PostSerializer(serializers.ModelSerializer):
    img = serializers.SerializerMethodField()

    class Meta:
        model = Post
        list_serializer_class = PostListSerializer
        fields = (
            'pk',
            'author',
            'title',
            'start_date',
            'end_date',
            'img',
            'continent',
            'liked',
            'num_liked',
        )

    def get_img(self, obj):
        s = obj.img.url
        return s.split('?')[0]


class UserProfileSerializer(serializers.ModelSerializer):
    following_users = UserSerializer(many=True, read_only=True)
    followers = UserSerializer(many=True, read_only=True)
    following_number = serializers.SerializerMethodField()
    follower_number = serializers.SerializerMethodField()
    posts = PostSerializer(many=True, read_only=True)
    liked_posts = PostSerializer(many=True, read_only=True)
    img_profile = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = (
            'pk',
            'username',
            'email',
            'img_profile',
            'following_number',
            'follower_number',
            'following_users',
            'followers',
            'posts',
            'liked_posts',
        )

    def get_following_number(self, obj):
        user = self.context['user']
        return user.following_relations.count()

    def get_follower_number(self, obj):
        user = self.context['user']
        return user.follower_relations.count()

    def get_img_profile(self, obj):
        s = obj.img_profile.url
        return s.split('?')[0]
