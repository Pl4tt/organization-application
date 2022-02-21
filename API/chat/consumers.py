import json
from channels.generic.websocket import AsyncWebsocketConsumer
from asgiref.sync import sync_to_async
from rest_framework.authtoken.models import Token
from django.contrib.auth import get_user_model
from django.contrib.humanize.templatetags.humanize import naturalday

from .constants import CMD_SEND_MSG
from .models import Chat, Message


class ChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.chat_id = self.scope["url_route"]["kwargs"]["chat_id"]

        token = dict(self.scope["headers"])[b"authorization"].decode().split()[1]
        
        try:
            token = await sync_to_async(Token.objects.get, thread_sensitive=True)(key=token)
            self.user = await sync_to_async(get_user_model().objects.get, thread_sensitive=True)(auth_token=token)
        except Token.DoesNotExist:
            await self.close()
            return
            
        try:
            self.chat = await sync_to_async(Chat.objects.get, thread_sensitive=True)(pk=self.chat_id)
            self.room_name = self.chat.pk
            self.room_group_name = f"chat_{self.room_name}"
        except Chat.DoesNotExist:
            await self.close()
            return
            
        if not self.user.is_authenticated:
            await self.close()
            return
            
        if not await sync_to_async(self.chat.is_member, thread_sensitive=True)(self.user):
            await self.close()
            return
            
        await self.channel_layer.group_add(
            self.room_group_name,
            self.channel_name
        )
        
        await self.accept()
    
    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(
            self.room_group_name,
            self.channel_name
        )

    async def receive(self, text_data):
        text_data_json = json.loads(text_data)
        message = text_data_json.get("message")

        if message:
            message_model = Message(
                chat=self.chat,
                author=self.user,
                content=message,
            )
            await sync_to_async(message_model.save, thread_sensitive=True)()
        
        await self.channel_layer.group_send(
            self.room_group_name,
            {
                "type": "chatroom_message",
                "command": CMD_SEND_MSG,
                "message": message,
                "id": message.pk,
                "username": self.user.username,
                "date_created": naturalday(message_model.date_created),
            }
        )
    
    async def chatroom_message(self, event):
        command = event.get("command")
        message = event.get("message")
        msg_id = event.get("id")
        username = event.get("username")
        date_created = event.get("date_created")
        
        await self.send(json.dumps({
            "command": command,
            "message": message,
            "id": msg_id,
            "username": username,
            "date_created": date_created
        }))
