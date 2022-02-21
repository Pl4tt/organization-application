from django.db import models
from django.conf import settings


class Chat(models.Model):
    creator = models.ForeignKey(settings.AUTH_USER_MODEL, related_name="created_chats", on_delete=models.CASCADE)
    member = models.ForeignKey(settings.AUTH_USER_MODEL, related_name="joined_chats", on_delete=models.CASCADE)
    date_created = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"chat {self.creator}, {self.member}"
    
    def is_member(self, user):
        return user == self.member or user == self.creator


class Message(models.Model):
    chat = models.ForeignKey(Chat, related_name="messages", on_delete=models.CASCADE)
    author = models.ForeignKey(settings.AUTH_USER_MODEL, related_name="messages", on_delete=models.CASCADE)
    content = models.CharField(max_length=500)
    date_created = models.DateTimeField(auto_now_add=True)
    last_update = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"msg {self.author}, {self.chat}"

    def delete(self, extinguisher):
        if extinguisher == self.author:
            self.content = f"This message has been deleted by {extinguisher}."
            self.save()
