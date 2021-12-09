from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from django.contrib.auth import authenticate, login, logout
from django.contrib.humanize.templatetags.humanize import naturalday

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

                return Response({"success": "Account created successfully!"}, status=status.HTTP_200_OK)
    
        return Response({"error": "Registration data is not valid."}, status=status.HTTP_400_BAD_REQUEST)

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
                    return Response({"success": "Logged in successfully!"}, status=status.HTTP_200_OK)
        
        return Response({"error": "Login data is not valid."}, status=status.HTTP_400_BAD_REQUEST)

class LogoutView(APIView):
    
    permission_classes = (IsAuthenticated,)

    def get(self, request, format=None):
        if not request.user.is_authenticated:
            return Response({"success": "Error while trying to log out."}, status=status.HTTP_400_BAD_REQUEST)

        logout(request)
        return Response({"success": "Logged out successfully."}, status=status.HTTP_200_OK)

class UserView(APIView):

    permission_classes = (IsAuthenticated,)

    def get(self, request, format=None):
        user = request.user
        print(user.pk)
        if not user.is_authenticated:
            return Response({"error": "No user given."}, status=status.HTTP_404_NOT_FOUND)
        
        data = {
            "id": user.pk,
            "email": user.email if not user.hide_email else "******",
            "username": user.username,
            "first_name": user.first_name,
            "last_name": user.last_name if not user.hide_name else "******",
            "biography": user.biography if not user.hide_name else "******",
            "date_created": naturalday(str(user.date_created)),
            "hide_email": user.hide_email,
        }

        return Response(data, status=status.HTTP_200_OK)

        
        