from django.contrib import admin

from .models import Chat, Message


@admin.register(Chat)
class ChatAdmin(admin.ModelAdmin):
    list_display = ("id", "creator", "member", "date_created")
    list_display_links = ("id", "creator", "member")
    search_fields = ("id", "creator", "member")
    readonly_fields = ("id", "creator", "member", "date_created")

@admin.register(Message)
class MessageAdmin(admin.ModelAdmin):
    list_display = ("id", "chat", "author", "date_created", "last_update")
    list_display_links = ("id", "chat", "author")
    search_fields = ("id", "chat", "author")
    readonly_fields = ("id", "chat", "author", "content", "date_created", "last_update")
    list_filter = ("chat", "author")