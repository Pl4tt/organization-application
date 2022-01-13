from django.urls import path

from .views import (
    CreateTeamView,
    TeamView,
    TeamOverview
)


app_name = "teams"
urlpatterns = [
    path("", TeamOverview.as_view(), name="team-overview"),
    path("create", CreateTeamView.as_view(), name="create"),
    path("<int:team_id>", TeamView.as_view(), name="team-view"),
]