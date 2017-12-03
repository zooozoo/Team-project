from django.core.validators import RegexValidator
from rest_framework import serializers
from rest_framework.authtoken.models import Token

from member.models import User


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
