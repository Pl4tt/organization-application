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
        update_team: {
            method: PATCH,
            body: {
                name: new_name / name,
                administrators: new_administrators / administrators,
                members: new_members / members
            }
        },
    },
}

"""


from django.contrib.auth import get_user_model
from rest_framework.views import APIView
from rest_framework import status
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

from .models import Team
from .serializers import TeamSerializer


class CreateTeamView(APIView):
    
    permission_classes = (IsAuthenticated,)

    def post(self, request, format=None):
        data = request.data
        
        owner = get_user_model().objects.filter(pk=data.get("owner_id")).first()

        if not owner:
            return Response({"error": "The given owner does not exist."}, status=status.HTTP_404_NOT_FOUND)

        team = Team.objects.create(name=data.get("name"), owner=owner)
        team.set_owner(owner)

        return Response({"success": "Team created successfully."}, status=status.HTTP_200_OK)


class TeamView(APIView):

    permission_classes = (IsAuthenticated,)

    def get(self, request, team_id, format=None):
        team = Team.objects.filter(pk=team_id).first()

        if not team:
            return Response({"error": "This team doesn't exists."}, status=status.HTTP_404_NOT_FOUND)

        if not team.check_member(request.user):
            return Response({"error": "You are not authorized to access this team."}, status=status.HTTP_401_UNAUTHORIZED)
        
        team_data = {
            "id": team.pk,
            "name": team.name,
            "owner": team.owner.pk,
            "administrators": list(map(lambda admin: admin.pk, team.administrators.all())),
            "members": list(map(lambda member: member.pk, team.members.all())),
            "date_created": team.date_created,
            "last_update": team.last_update,
        }
        serializer = TeamSerializer(team, data=team_data)
        
        if serializer.is_valid():
            serializer.save()

        return Response(serializer.data, status=status.HTTP_200_OK)
    
    def delete(self, request, team_id, format=None):
        team = Team.objects.filter(pk=team_id).first()

        if not team:
            return Response({"error": "You cannot delete this team."}, status=status.HTTP_404_NOT_FOUND)
        
        if not team.check_admin(request.user) and not request.user == team.owner:
            return Response({"error": "You are not authorized to delete this team."}, status=status.HTTP_401_UNAUTHORIZED)
        
        team.delete()

        return Response({"success": "Team deleted successfully"}, status=status.HTTP_200_OK)

    def patch(self, request, team_id, format=None):
        team = Team.objects.filter(pk=team_id).first()

        if not team:
            return Response({"error": "You cannot update a non existing team."}, status=status.HTTP_404_NOT_FOUND)

        if not team.check_admin(request.user) and not request.user == team.owner:
            return Response({"error": "You are not authorized to update this team."}, status=status.HTTP_401_UNAUTHORIZED)

        new_name = request.data.get("name")
        new_admins = request.data.get("administrators")
        new_members = request.data.get("members")

        if new_name is not None:
            team.name = new_name
        
        if new_admins is not None:
            new_admins = list(filter(lambda id: get_user_model().objects.filter(pk=id).first() is not None, new_admins))
            team.administrators.set(list(map(lambda id: get_user_model().objects.get(pk=id), new_admins)))
        
        if new_members is not None:
            new_members = list(filter(lambda id: get_user_model().objects.filter(pk=id).first() is not None, new_members))
            team.members.set(list(map(lambda id: get_user_model().objects.get(pk=id), new_members)))

        team.save(update_fields=["name"])

        return Response({"success": "Team updated successfully!"}, status=status.HTTP_200_OK)