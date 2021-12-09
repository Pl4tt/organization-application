from django.urls import path

from .views import (
    CreateTeamView,
    TeamView,
)


app_name = "teams"
urlpatterns = [
    path("create", CreateTeamView.as_view(), name="create"),
    path("<int:team_id>", TeamView.as_view(), name="team-view"),
]