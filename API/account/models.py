from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.conf import settings
from rest_framework.authtoken.models import Token


class AccountManager(BaseUserManager):
    def create_user(self, email, username, first_name, last_name, password):
        if not email:
            raise ValueError("Please enter an email address")
        if not username:
            raise ValueError("Please enter a username")
        if not first_name:
            raise ValueError("Please enter a first name")
        if not last_name:
            raise ValueError("Please enter a last name")
        if not password:
            raise ValueError("Please enter a first password")
        
        user = self.model(email=self.normalize_email(email), username=username, first_name=first_name, last_name=last_name)
        user.set_password(password)
        user.save(using=self._db)

        return user

    def create_staffuser(self, email, username, first_name, last_name, password):
        user = self.create_user(email, username, first_name, last_name, password)
        user.is_staff = True
        user.save(using=self._db)

        return user

    def create_superuser(self, email, username, first_name, last_name, password):
        user = self.create_user(email, username, first_name, last_name, password)
        user.is_admin = True
        user.is_staff = True
        user.is_superuser = True
        user.save(using=self._db)

        return user


class Account(AbstractBaseUser):
    email = models.EmailField(max_length=60, unique=True)
    username = models.CharField(max_length=25, unique=True)
    first_name = models.CharField(max_length=25)
    last_name = models.CharField(max_length=25)
    biography = models.CharField(max_length=255, default="I'm just boring :/")
    date_created = models.DateTimeField(auto_now_add=True)
    last_login = models.DateTimeField(auto_now=True)
    hide_email = models.BooleanField(default=True)
    hide_name = models.BooleanField(default=True)
    # TODO: implement profile picture

    is_active = models.BooleanField(default=True)
    is_admin = models.BooleanField(default=False)
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = ["username", "first_name", "last_name"]

    objects = AccountManager()

    def __str__(self):
        return self.first_name + self.last_name

    def has_perm(self, perm, obj=None):
        return self.is_admin

    def has_module_perms(self, app_label):
        return True

    def get_full_name(self):
        return f"{self.first_name} {self.last_name}"
    

@receiver(post_save, sender=settings.AUTH_USER_MODEL)
def create_auth_token(sender, instance=None, created=False, **kwargs):
    if created:
        Token.objects.create(user=instance)