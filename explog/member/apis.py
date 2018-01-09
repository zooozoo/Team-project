from django.contrib.auth import get_user_model
from django.db import IntegrityError
from push_notifications.models import APNSDevice
from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.compat import authenticate
from rest_framework.permissions import IsAuthenticatedOrReadOnly, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from member.models import Relation
from .serializers import (
    SignupSerializer,
    FollwingSerializer,
    UserProfileUpdateSerializer,
    UserPasswordUpdateSerializer,
    UserProfileSerializer,
    UserSerializer,
    TokenSerializer,
)

User = get_user_model()


class LoginView(APIView):
    def post(self, request, *args, **kwargs):
        try:
            email = request.data['email']
            password = request.data['password']
        except:
            data = {
                'key error': '\'email\'key and \'password\'key must be set'
            }
            return Response(data, status=status.HTTP_400_BAD_REQUEST)
        user = authenticate(
            email=email,
            password=password,
        )
        if user:
            serializer = UserSerializer(user)
            if request.data.__contains__('device-token'):
                try:
                    APNSDevice.objects.update_or_create(
                        user=user,
                        defaults={
                            "registration_id": request.data['device-token']
                        }
                    )
                except:
                    error = {
                        "device-token": "중복된 토큰값"
                    }
                    return Response(error, status=status.HTTP_400_BAD_REQUEST)
            return Response(serializer.data, status=status.HTTP_200_OK)
        data = {
            'message': 'Invalid credentials'
        }
        return Response(data, status=status.HTTP_401_UNAUTHORIZED)


class Signup(APIView):
    def post(self, request, *args, **kwargs):
        serializer = SignupSerializer(data=request.data)
        if serializer.is_valid():
            user = User.objects.get(pk=serializer.data['pk'])
            if request.data.__contains__('device-token'):
                try:
                    APNSDevice.objects.update_or_create(
                        user=user,
                        defaults={
                            "registration_id": request.data['device-token']
                        }
                    )
                except:
                    error = {
                        "device-token": "중복된 토큰값"
                    }
                    return Response(error, status=status.HTTP_400_BAD_REQUEST)
            serializer.save()
            # 반환되는 데이터는 img_profile의 url을 표현해주기 위하여
            # Userserializer를 활용한다
            user_serializer = UserSerializer(user)
            return Response(user_serializer.data)
        key = list(serializer.errors.keys())[0]
        value = list(serializer.errors.values())[0][0]
        error = {key: value}
        return Response(error, status=status.HTTP_400_BAD_REQUEST)


class CheckTokenExists(APIView):
    def post(self, request, *args, **kwargs):
        try:
            data = request.data['token']
        except:
            data = {
                'Key': 'Invalid Key'
            }
            return Response(data, status=status.HTTP_400_BAD_REQUEST)
        if Token.objects.filter(key=data).exists():
            token = Token.objects.get(key=data)
            serializer = TokenSerializer(token)
            return Response(serializer.data)
        else:
            data = {
                'token': 'token does not exist'
            }
            return Response(data, status=status.HTTP_400_BAD_REQUEST)


class Follwing(APIView):
    permission_classes = (IsAuthenticatedOrReadOnly,)

    def post(self, request, *args, **kwargs):
        data = {
            'from_user': str(self.request.user.pk),
            'to_user': request.data['to_user']
        }
        serializer = FollwingSerializer(
            data=data,
            context={'request': request}
        )
        if serializer.is_valid():
            # validated_data를 통해 해당 user 객체 생성
            from_user = User.objects.get(pk=serializer.validated_data['from_user'])
            to_user = User.objects.get(pk=serializer.validated_data['to_user'])
            # from_user가 이미 to_user를 follow 하고 있을 경우 follow취소
            if from_user.following_users.filter(pk=to_user.pk).exists():
                from_user.following_relations.get(to_user=to_user).delete()
                data = {
                    'unfollowing': serializer.validated_data['to_user']
                }
                return Response(data, status=status.HTTP_200_OK)
            # from_user가 to_user를 follow하고 있지 않은 경우 관계 생성
            Relation.objects.create(from_user=from_user, to_user=to_user, )
            return Response(serializer.data, status=status.HTTP_200_OK)
        # validation error가 발생 했을 경우 에러 메시지 가공
        key = list(serializer.errors.keys())[0]
        value = list(serializer.errors.values())[0][0]
        error = {key: value}
        return Response(error, status=status.HTTP_400_BAD_REQUEST)


class MyProfile(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request, *args, **kwargs):
        user = request.user
        serializer = UserProfileSerializer(
            user,
            context={'user': user}
        )
        return Response(serializer.data, status=status.HTTP_200_OK)


class UserProfile(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request, user_pk, *args, **kwargs):
        if User.objects.filter(pk=user_pk).exists():
            user = User.objects.get(pk=user_pk)
            serializer = UserProfileSerializer(
                user,
                context={'user': user}
            )
            return Response(serializer.data, status=status.HTTP_200_OK)
        error = {
            'user_pk': '존재하지 않는 user'
        }
        return Response(error, status=status.HTTP_400_BAD_REQUEST)


class UserProfileUpdate(APIView):
    permission_classes = (IsAuthenticated,)

    def patch(self, request, *args, **kwargs):
        user = request.user
        serializer = UserProfileUpdateSerializer(
            user,
            data=request.data,
            partial=True,
            context={'request': request}
        )
        if serializer.is_valid():
            serializer.update(user, validated_data=serializer.validated_data)
            serializer = UserSerializer(user)
            data = {
                'username': serializer.data['username'],
                'img_profile': serializer.data['img_profile']
            }
            return Response(data, status=status.HTTP_200_OK)
        key = list(serializer.errors.keys())[0]
        value = list(serializer.errors.values())[0][0]
        error = {key: value}
        return Response(error, status=status.HTTP_400_BAD_REQUEST)


class UserPasswordUpdate(APIView):
    permission_classes = (IsAuthenticated,)

    def patch(self, request, *args, **kwargs):
        serializer = UserPasswordUpdateSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.update(request.user, validated_data=serializer.validated_data)
            data = {
                'success': 'password가 변경되었습니다.'
            }
            return Response(data, status=status.HTTP_200_OK)
        key = list(serializer.errors.keys())[0]
        value = list(serializer.errors.values())[0][0]
        error = {key: value}
        return Response(error, status=status.HTTP_400_BAD_REQUEST)
