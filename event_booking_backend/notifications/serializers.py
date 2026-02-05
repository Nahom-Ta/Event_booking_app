from rest_framework import serializers
from .models import Notification

class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model=Notification
        feilds=['id','title','message','is_read','created_at']