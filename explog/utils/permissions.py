from rest_framework import permissions

class IsAuthorOrReadOnly(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        if request.method in permissions.SAFE_METHODS:
            return True
<<<<<<< HEAD
        return obj.post.author == request.user
=======
        return obj.post.author == request.user
>>>>>>> 97d27a04b2de33fee4c64e90f18973d58a5cb955
