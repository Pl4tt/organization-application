from django.urls import path
from .views import (
    ChatOverview,
    CreateChatView,
    RetrievePastMessageView,
    MessageView,
)


app_name = "chat"

urlpatterns = [
    path("", ChatOverview.as_view(), name="chat-overview"),
    path("create", CreateChatView.as_view(), name="create-chat"),
    path("retrieve-messages/<int:chat_id>", RetrievePastMessageView.as_view(), name="retrieve-messages"),
    path("message/<int:message_id>", MessageView.as_view(), name="message"),
]