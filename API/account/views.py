from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from django.contrib.auth import authenticate, get_user_model, login, logout
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

    def post(self, request, format=None):
        if not request.user.is_authenticated:
            return Response({"error": "Error while trying to log out."}, status=status.HTTP_400_BAD_REQUEST)

        logout(request)
        return Response({"success": "Logged out successfully."}, status=status.HTTP_200_OK)

class UserView(APIView):

    permission_classes = (IsAuthenticated,)

    def get(self, request, format=None):
        try:
            user_id = int(request.query_params.get("user-id"))
            user = get_user_model().objects.get(pk=user_id)
        except Exception:
            return Response({"error": "No user given."}, status=status.HTTP_404_NOT_FOUND)
        
        data = {
            "id": user.pk,
            "email": user.email if not user.hide_email else "******",
            "username": user.username,
            "first_name": user.first_name if not user.hide_name else "******",
            "last_name": user.last_name if not user.hide_name else "******",
            "biography": user.biography,
            "date_created": naturalday(str(user.date_created)),
            "hide_email": user.hide_email,
        }

        return Response(data, status=status.HTTP_200_OK)

    def post(self, request, format=None):
        """used to get critical information about the request user"""
        user = request.user
        
        if not user.is_authenticated:
            return Response({"error": "No user given."}, status=status.HTTP_404_NOT_FOUND)
        
        data = {
            "id": user.pk,
            "email": user.email,
            "username": user.username,
            "first_name": user.first_name,
            "last_name": user.last_name,
            "biography": user.biography,
            "date_created": naturalday(str(user.date_created)),
            "hide_email": user.hide_email,
            "hide_name": user.hide_name
        }
        
        return Response(data, status=status.HTTP_200_OK)

class SearchView(APIView):

    def get(self, request, format=None):
        search_query = request.query_params.get("search-query")
        accounts = get_user_model().objects.filter(username__icontains=search_query).distinct()
        search_result = []

        for account in accounts:
            data = {
                "id": account.pk,
                "email": account.email if not account.hide_email else "******",
                "username": account.username,
                "first_name": account.first_name if not account.hide_name else "******",
                "last_name": account.last_name if not account.hide_name else "******",
                "biography": account.biography,
                "date_created": naturalday(str(account.date_created)),
                "hide_email": account.hide_email,
            }
            search_result.append(data)
        
        return Response(search_result, status=status.HTTP_200_OK)
