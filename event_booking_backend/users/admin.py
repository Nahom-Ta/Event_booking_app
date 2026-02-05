from django.contrib import admin
from .models import User, PasswordResetCode


@admin.register(User)
class UserAdmin(admin.ModelAdmin):
	list_display = ("email", "full_name", "is_staff", "is_active", "date_joined")
	list_filter = ("is_staff", "is_active", "date_joined")
	search_fields = ("email", "full_name")
	ordering = ("-date_joined",)
	readonly_fields = ("date_joined",)


@admin.register(PasswordResetCode)
class PasswordResetCodeAdmin(admin.ModelAdmin):
	list_display = ("user", "code", "created_at")
	list_filter = ("created_at",)
	search_fields = ("user__email", "code")
	ordering = ("-created_at",)
