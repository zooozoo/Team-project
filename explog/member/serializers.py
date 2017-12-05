from django.core.validators import RegexValidator
from rest_framework import serializers
from rest_framework.authtoken.models import Token

from member.models import User, Relation


# 유저정보를 가지고 오기 위한 serializer, test create 할 때 필요해서 만들었음
class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = (
            'pk',
            'email',
            'img_profile',
            'username')


class LoginSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = (
            'pk',
            'email',
            'img_profile',
            'username',
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
        return self.Meta.model.objects.create_user(
            username=validated_data['username'],
            password=validated_data['password'],
            img_profile=validated_data['img_profile'],
            email=validated_data['email'],
        )

    def get_token(self, obj):
        return Token.objects.get_or_create(user=obj)[0].key


class FollwingSerializer(serializers.Serializer):
    from_user = serializers.IntegerField()
    to_user = serializers.IntegerField()

    # 필드에서 발생하는 에러메시지를 커스터마이징

    def create(self, validated_data):
        to_user = User.objects.get(pk=validated_data['to_user'])
        from_user = User.objects.get(pk=validated_data['from_user'])
        return Relation.objects.create(
            from_user=from_user,
            to_user=to_user,
        )

    def validate(self, data):
        if data['from_user'] == data['to_user']:
            raise serializers.ValidationError('자기 자신을 follow할 수 없습니다.')
        return data

    def validate_to_user(self, data):
        if User.objects.filter(pk=self.context['request'].user.pk).exists():
            request_user = User.objects.get(pk=self.context['request'].user.pk)
            if User.objects.filter(pk=data).exists():
                if request_user.following_users.filter(pk=data).exists():
                    raise serializers.ValidationError('이미 follow하고 있습니다.')
                return data
            raise serializers.ValidationError('존재하지 않는 user')
        raise serializers.ValidationError('로그인상태 아님')
