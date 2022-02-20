from django.urls import path
from .views import (
    ChatOverview,
    CreateChatView,
    RetrievePastMessages
)


app_name = "chat"

urlpatterns = [
    path("", ChatOverview.as_view(), name="chat-overview"),
    path("create", CreateChatView.as_view(), name="create-chat"),
    path("retrieve-messages/<int:chat_id>", RetrievePastMessages.as_view(), name="retrieve-messages")
]