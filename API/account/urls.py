from django.urls import path
from rest_framework.authtoken.views import obtain_auth_token

from .views import (
    RegistrationView,
    LoginView,
    LogoutView,
    SearchView,
    UserView,
)


app_name = "account"
urlpatterns = [
    path("register", RegistrationView.as_view(), name="register"),
    path("login", LoginView.as_view(), name="login"),
    path("logout", LogoutView.as_view(), name="logout"),
    path("user", UserView.as_view(), name="secret-user-data"),
    path("search", SearchView.as_view(), name="search"),
    path("obtain-token", obtain_auth_token, name="obtain-token"),
]