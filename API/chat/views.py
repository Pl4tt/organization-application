from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status

from django.contrib.auth import get_user_model
from django.contrib.humanize.templatetags.humanize import naturalday

from .models import Chat, Message


class CreateChatView(APIView):

    permission_classes = (IsAuthenticated,)

    def post(self, request, format=None):
        member_email = request.data.get("member_email")
        member = get_user_model().objects.filter(email=member_email).first()

        if not member:
            return Response({"error": "No user given"}, status=status.HTTP_400_BAD_REQUEST)
        
        chat = Chat(creator=request.user, member=member)
        chat.save()

        return Response({"success": "Chat created successfully"}, status=status.HTTP_200_OK)

class ChatOverview(APIView):

    permission_classes = (IsAuthenticated,)

    def get(self, request, format=None):
        chats = Chat.objects.filter(creator=request.user)
        chats |= Chat.objects.filter(member=request.user)
        all_chats = []

        for chat in chats:
            _self = chat.creator.pk if request.user != chat.creator else chat.member.pk
            _chatting_person = chat.member.pk if request.user != chat.member else chat.creator.pk
            _chatting_person_username = chat.member.username if request.user != chat.member else chat.creator.username

            data = {
                "id": chat.pk,
                "self": _self,
                "chatting_person": _chatting_person,
                "date_created": naturalday(str(chat.date_created)),
                "chatting_person_username": _chatting_person_username,
            }
            
            all_chats.append(data)
        
        return Response(all_chats, status=status.HTTP_200_OK)

class RetrievePastMessageView(APIView):

    permission_classes = (IsAuthenticated,)

    def get(self, request, chat_id, format=None):
        chat = Chat.objects.filter(pk=chat_id).first()

        if not chat:
            return Response({"error": "Chat with given id not found"}, status=status.HTTP_400_BAD_REQUEST)

        if not chat.is_member(request.user):
            return Response({"error": "You are not authenticated to read this chat."}, status=status.HTTP_403_FORBIDDEN)
        
        messages = []

        for message in chat.messages.all():
            messages.append({
                "id": message.pk,
                "username": message.author.username,
                "message": message.content,
                "date_created": naturalday(message.date_created),
            })

        return Response(messages, status=status.HTTP_200_OK)

class MessageView(APIView):
    
    permission_classes = (IsAuthenticated,)

    def delete(self, request, message_id, format=None):
        message = Message.objects.filter(pk=message_id).first()

        if not message:
            return Response({"error": "message with given id doesn't exist."}, status=status.HTTP_400_BAD_REQUEST)

        message.delete(request.user)

        return Response({"success": "process ran successfully."}, status=status.HTTP_200_OK)