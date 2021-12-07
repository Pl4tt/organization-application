from django.db import models
from django.conf import settings


class Team(models.Model):
    name = models.CharField(max_length=30, unique=True)
    owner = models.ForeignKey(settings.AUTH_USER_MODEL, related_name="owning_teams", on_delete=models.CASCADE)
    administrators = models.ManyToManyField(settings.AUTH_USER_MODEL, related_name="administrating_teams")
    members = models.ManyToManyField(settings.AUTH_USER_MODEL, related_name="teams")
    date_created = models.DateTimeField(auto_now_add=True)
    last_update = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name
    
    def add_user(self, user):
        if not user in self.members.all():
            self.members.add(user)
            
            self.save()

    def remove_user(self, user):
        self.remove_administrator(user)

        if user in self.members.all():
            self.members.remove(user)

            self.save()
        
    def check_member(self, user):
        return user in self.members.all()

    def add_administrator(self, user):
        self.add_user(user)

        if not user in self.administrators.all():
            self.administrators.add(user)

            self.save()
    
    def remove_administrator(self, user):
        if user in self.administrators.all():
            self.administrators.remove(user)

            self.save()

    def check_admin(self, user):
        return user in self.administrators.all()

    def set_owner(self, user):
        self.add_user(user)
        self.add_administrator(user)
        self.owner = user
        self.save()