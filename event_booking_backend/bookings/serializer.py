from rest_framework import serializers
from .models import Booking
from events.models import Event

class BookingSerializer(serializers.ModelSerializer):
    event_title = serializers.ReadOnlyField(source='event.title')
    event_date = serializers.ReadOnlyField(source='event.date') # Ensure your Event model has 'date'
    event_location = serializers.ReadOnlyField(source='event.location')
    
    class Meta:
        model = Booking
        fields = [
            'id', 'event', 'event_title', 'event_date', 'event_location',
            'full_name', 'nickname', 'email', 'phone', 
            'gender', 'dob', 'country', 'is_paid', 'ticket_id'
        ]
        read_only_fields = ['is_paid', 'ticket_id']