from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status

from django.contrib.auth import get_user_model
from django.contrib.humanize.templatetags.humanize import naturalday

from .models import Chat


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
