from django.urls import path
from rest_framework.authtoken.views import obtain_auth_token

from .views import (
    RegistrationView,
    LoginView,
    LogoutView,
)


app_name = "account"
urlpatterns = [
    path("register", RegistrationView.as_view(), name="register"),
    path("login", LoginView.as_view(), name="login"),
    path("logout", LogoutView.as_view(), name="logout"),
    path("get-token", obtain_auth_token, name="get_token")
]