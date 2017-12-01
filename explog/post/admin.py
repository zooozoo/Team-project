from django.contrib import admin

# Register your models here.
from .models import Post, PostContent, PostReply, PostText, PostPhoto, PostPath

admin.site.register(Post)
admin.site.register(PostContent)
admin.site.register(PostReply)
admin.site.register(PostText)
admin.site.register(PostPhoto)
admin.site.register(PostPath)