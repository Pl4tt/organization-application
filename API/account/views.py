from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import authenticate, login

from .forms import RegistrationForm, AccountAuthenticationForm


class RegistrationView(APIView):
    def post(self, request, format=None):
        data = request.data

        if data:
            form = RegistrationForm(data)

            if form.is_valid():
                form.save()
                email = data.get("email").lower()
                password = data.get("password1")

                account = authenticate(email=email, password=password)
                login(request, account)

                return Response({"status": 200}, status=status.HTTP_200_OK)
    
        return Response({"status": 400}, status=status.HTTP_400_BAD_REQUEST)

class LoginView(APIView):
    def post(self, request, format=None):
        data = request.data

        if data:
            form = AccountAuthenticationForm(data)

            if form.is_valid():
                email = data.get("email").lower()
                password = data.get("password")
                account = authenticate(email=email, password=password)

                if account:
                    login(request, account)
                    return Response({"status": 200}, status=status.HTTP_200_OK)
        
        return Response({"status": 400}, status=status.HTTP_400_BAD_REQUEST)