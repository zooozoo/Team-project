from rest_framework import serializers

from member.models import User


class LoginSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = (
            'pk',
            'username',
            'img_profile',
        )
