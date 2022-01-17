from django.urls import path
from .views import (
    ChatOverview,
    CreateChatView
)


app_name = "chat"

urlpatterns = [
    path("", ChatOverview.as_view(), name="chat-overview"),
    path("create", CreateChatView.as_view(), name="create-chat")
]