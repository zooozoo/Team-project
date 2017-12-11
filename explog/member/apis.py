from django.contrib.auth import get_user_model
from rest_framework import status, generics
from rest_framework.authtoken.models import Token
from rest_framework.compat import authenticate
from rest_framework.mixins import UpdateModelMixin
from rest_framework.permissions import IsAuthenticatedOrReadOnly, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from member.models import Relation
from .serializers import (
    LoginSerializer,
    SignupSerializer,
    FollwingSerializer,
    UserProfileUpdateSerializer,
    UserPasswordUpdateSerializer,
    UserProfileSerializer)

User = get_user_model()


class LoginView(APIView):
    def post(self, request, *args, **kwargs):
        email = request.data['email']
        password = request.data['password']
        user = authenticate(
            email=email,
            password=password,
        )
        if user:
            token, token_created = Token.objects.get_or_create(user=user)
            data = {
                'pk': LoginSerializer(user).data['pk'],
                'username': LoginSerializer(user).data['username'],
                'email': LoginSerializer(user).data['email'],
                'img_profile': LoginSerializer(user).data['img_profile'],
                'token': token.key,
            }
            return Response(data, status=status.HTTP_200_OK)
        data = {

            'message': 'Invalid credentials'
        }
        return Response(data, status=status.HTTP_401_UNAUTHORIZED)


class Signup(APIView):
    def post(self, request, *args, **kwargs):
        serializer = SignupSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        key = list(serializer.errors.keys())[0]
        value = list(serializer.errors.values())[0][0]
        error = {key: value}
        return Response(error, status=status.HTTP_400_BAD_REQUEST)


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
                    'unfollowing': str(serializer.validated_data['to_user'])
                }
                return Response(data, status=status.HTTP_200_OK)
            # from_user가 to_user를 follow하고 있지 않은 경우 관계 생성
            Relation.objects.create(from_user=from_user, to_user=to_user, )
            return Response(data, status=status.HTTP_200_OK)
        # validation error가 발생 했을 경우 에러 메시지 가공
        er_messege = list(serializer.errors.values())[0][0]
        data = {
            'error': er_messege
        }
        return Response(data, status=status.HTTP_400_BAD_REQUEST)


class UserProfile(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request, *args, **kwargs):
        user = request.user
        serializer = UserProfileSerializer(
            user,
            context={'request': request}
        )
        return Response(serializer.data)


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
            return Response(serializer.data, status=status.HTTP_200_OK)
        er_messege = list(serializer.errors.values())[0][0]
        data = {
            'error': er_messege
        }
        return Response(data, status=status.HTTP_400_BAD_REQUEST)


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
        er_messege = list(serializer.errors.values())[0][0]
        data = {
            'error': er_messege
        }
        return Response(data, status=status.HTTP_400_BAD_REQUEST)
