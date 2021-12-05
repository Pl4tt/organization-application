from django import forms
from django.contrib.auth import authenticate
from django.contrib.auth.forms import UserCreationForm

from .models import Account


class RegistrationForm(UserCreationForm):
    email = forms.EmailField(max_length="60", help_text="Email is required. Please enter a valid email address.")

    class Meta:
        model = Account
        fields = ("email", "username", "first_name", "last_name", "password1", "password2")
    
    def clean_email(self):
        email = self.cleaned_data.get("email").lower()

        try:
            Account.objects.get(email=email)
        except Exception:
            return email
        
        raise forms.ValidationError(f"Email '{email}' is already in use.")
    
    def clean_username(self):
        username = self.cleaned_data.get("username")

        try:
            Account.objects.get(username=username)
        except Exception:
            return username
        
        raise forms.ValidationError(f"Username '{username}' is already in use.")


class AccountAuthenticationForm(forms.ModelForm):
    class Meta:
        model = Account
        fields = ("email", "password")
    
    def clean(self):
        if self.is_valid():
            email = self.cleaned_data.get("email").lower()
            password = self.cleaned_data["password"]
            if not authenticate(email=email, password=password):
                raise forms.ValidationError("Invalid email or password.")