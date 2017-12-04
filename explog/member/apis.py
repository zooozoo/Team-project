from rest_framework import status, generics
from rest_framework.authtoken.models import Token
from rest_framework.compat import authenticate
from rest_framework.response import Response
from rest_framework.views import APIView

from .serializers import LoginSerializer, SignupSerializer, UserSerializer

from member.models import User


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

