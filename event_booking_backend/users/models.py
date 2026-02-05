from django.db import models

from django.contrib.auth.models import AbstractBaseUser, BaseUserManager,PermissionsMixin
from django.conf import settings
import random
import string


class UserManager(BaseUserManager):
   """ custom user model manager where email is the unique identifier 
    for authentication instead of username"""
   def create_user(self,email,full_name,password=None,**extra_feilds):
      if not email:
         raise ValueError('The Email must be set')
      email=self.normalize_email(email)
      user=self.model(email=email,full_name=full_name,**extra_feilds)
      user.set_password(password)
      user.save(using=self._db)
      return user
   def create_superuser(self,email,full_name,password,**extra_feild):
      extra_feild.setdefault('is_staff',True)
      extra_feild.setdefault('is_superuser',True)
      extra_feild.setdefault('is_active',True)

      if extra_feild.get('is_staff') is not True:
         raise ValueError('Superuser must have is_staff=True.')
      if extra_feild.get('is_superuser') is not True:
         raise ValueError('Superuser must have is_superuser=True.')
      return self.create_user(email,full_name,password,**extra_feild)
class User(AbstractBaseUser,PermissionsMixin):
   email=models.EmailField(unique=True)
   full_name=models.CharField(max_length=255)
   profile_picture = models.ImageField(upload_to='profile_pics/', null=True, blank=True)
   bio = models.TextField(max_length=500, blank=True)
   is_staff=models.BooleanField(default=False)
   is_active=models.BooleanField(default=True)
   date_joined=models.DateTimeField(auto_now_add=True)

   USERNAME_FIELD='email'
   REQUIRED_FIELDS=['full_name']
   objects=UserManager()

   def __str__(self):
      return self.email
   
class PasswordResetCode(models.Model):
   user=models.ForeignKey(settings.AUTH_USER_MODEL,on_delete=models.CASCADE)
   code=models.CharField(max_length=6)
   created_at=models.DateTimeField(auto_now_add=True)

   def __str__(self):
      return f'Reset code for {self.user.email}'
   
   @staticmethod
   def generate_code():
      return ''.join(random.choices(string.digits, k=6))
