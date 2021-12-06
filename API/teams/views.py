"""
{
    create_team: {
        url: /teams/create,
        method: POST,
        body: {
            name: name,
            owner_id: owner_id
        }
    },
    specific_team:{
        url: /teams/{id},
        team_overview: {
            method: GET
        },
        delete_team: {
            method: DELETE
        },
    },
}

"""


from django.contrib.auth import get_user_model
from rest_framework.views import APIView
from rest_framework import status
from rest_framework.response import Response

from .models import Team


class CreateTeamView(APIView):
    def post(self, request, format=None):
        data = request.data
        
        owner = get_user_model().objects.filter(pk=data.get("owner_id")).first()

        if not owner:
            return Response({"status": 400}, status=status.HTTP_400_BAD_REQUEST)

        team = Team.objects.create(name=data.get("name"), owner=owner)
        team.set_owner(owner)

        return Response({"status": 200}, status=status.HTTP_200_OK)