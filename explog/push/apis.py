from rest_framework import status, generics
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from post.models import PostLike
from push.pagination import PushListPagination
from push.serializers import PushListSerializer


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


class PushList(generics.ListAPIView):
    serializer_class = PushListSerializer
    pagination_class = PushListPagination
    permission_classes = (IsAuthenticated,)

    def get_queryset(self):
        request_user_posts = self.request.user.posts.all()
        return PostLike.objects.filter(post_id__in=request_user_posts)
