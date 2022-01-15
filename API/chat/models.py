from django.db import models
from django.conf import settings


class Chat(models.Model):
    creator = models.ForeignKey(settings.AUTH_USER_MODEL, related_name="created_chats")
    member = models.ForeignKey(settings.AUTH_USER_MODEL, related_name="joined_chats")
    date_created = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"chat {self.creator}, {self.member}"


class Message(models.Model):
    chat = models.ForeignKey(Chat, related_name="messages")
    author = models.ForeignKey(settings.AUTH_USER_MODEL, related_name="messages")
    content = models.CharField(max_length=500)
    date_created = models.DateTimeField(auto_now_add=True)
    last_update = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"msg {self.author}, {self.chat}"
