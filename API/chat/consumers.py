from channels.generic.websocket import AsyncWebsocketConsumer
from asgiref.sync import sync_to_async

from .models import Chat


class ChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.chat_id = self.scope["url_route"]["kwargs"]["chat_id"]
        self.user = self.scope["user"] # TODO: use token autentication
        
        print(self.user)
        
        try:
            chat = await sync_to_async(Chat.objects.get, thread_sensitive=True)(pk=self.chat_id)
            self.room_name = chat.name
            self.room_group_name = f"chat_{self.room_group_name}"
        except Chat.DoesNotExist:
            await self.close()
