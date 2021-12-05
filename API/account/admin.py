from django.contrib import admin

from .models import Account


@admin.register(Account)
class AccountAdmin(admin.ModelAdmin):
    list_display = ("id", "email", "username", "first_name", "last_name", "is_admin", "is_superuser", "is_staff", "is_active")
    list_display_links = ("id", "email", "username", "first_name", "last_name")
    list_filter = ("is_admin", "is_superuser", "is_staff", "is_active")
    search_fields = ("id", "email", "username", "first_name", "last_name")
    readonly_fields = ("id", "date_created", "last_login", "is_active")