from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status

from django.contrib.auth import get_user_model

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