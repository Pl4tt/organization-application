from django.contrib import admin

from .models import Team


@admin.register(Team)
class TeamAdmin(admin.ModelAdmin):
    list_display = ("id", "name", "owner")
    list_display_links = ("id", "name", "owner")
    search_fields = ("id", "name")
    readonly_fields = ("id", "date_created", "last_update")
