from django.contrib.auth import get_user_model
from push_notifications.models import APNSDevice
from rest_framework import status, generics
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from member.serializers import UserSerializer
from post.models import PostLike
from push.pagination import PushListPagination
from push.serializers import PushListSerializer, SetBadgeCountSerializer, APNsDeviceTokenSerializer

User = get_user_model()


class ResetBadgeCount(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request, *args, **kwargs):
        user = request.user
        user.reset_badge_count()
        user.save()
        data = {
            "user": str(user),
            "badge": int(user.badge),
        }
        return Response(data, status=status.HTTP_200_OK)


class SetBadgeCount(generics.UpdateAPIView):
    serializer_class = SetBadgeCountSerializer
    permission_classes = (IsAuthenticated,)

    def get_object(self):
        return self.request.user


class PushList(generics.ListAPIView):
    serializer_class = PushListSerializer
    pagination_class = PushListPagination
    permission_classes = (IsAuthenticated,)

    def get_queryset(self):
        request_user_posts = self.request.user.posts.all()
        return PostLike.objects.filter(post_id__in=request_user_posts)


class SetAPNsDeviceToken(APIView):
    permission_classes = (IsAuthenticated,)

    def patch(self, request, *args, **kwargs):
        if request.data.__contains__('device-token'):
            device, created= APNSDevice.objects.update_or_create(
                user=request.user,
                defaults={
                    "registration_id": request.data['device-token']
                }
            )
            serializer = APNsDeviceTokenSerializer(device)
            return Response(serializer.data, status=status.HTTP_200_OK)
        error = {
            'key': 'invalid key'
        }
        return Response(error, status=status.HTTP_400_BAD_REQUEST)
