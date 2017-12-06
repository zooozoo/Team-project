from django.contrib import admin
from django.contrib.auth.admin import UserAdmin

from member.models import User, Relation

admin.site.register(User, UserAdmin)
admin.site.register(Relation, UserAdmin)

# Register your models here.
