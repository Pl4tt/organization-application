from channels.generic.websocket import AsyncWebsocketConsumer
from asgiref.sync import sync_to_async
from rest_framework.authtoken.models import Token
from django.contrib.auth import get_user_model

from .models import Chat


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
            chat = await sync_to_async(Chat.objects.get, thread_sensitive=True)(pk=self.chat_id)
            self.room_name = chat.pk
            self.room_group_name = f"chat_{self.room_name}"
        except Chat.DoesNotExist:
            await self.close()
            return
            
        if not self.user.is_authenticated:
            await self.close()
            return
            
        if not await sync_to_async(chat.is_member, thread_sensitive=True)(self.user):
            await self.close()
            return
            
        await self.accept()
    
    async def disconnect(self, close_code):
        pass
