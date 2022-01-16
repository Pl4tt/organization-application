from django.urls import path
from .views import (
    CreateChatView
)


app_name = "chat"

urlpatterns = [
    path("create", CreateChatView.as_view(), name="create-chat")
]