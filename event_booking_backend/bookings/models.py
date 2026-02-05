import uuid
from django.db import models
from django.conf import settings
from events.models import Event

class Booking(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='bookings')
    event = models.ForeignKey(Event, on_delete=models.CASCADE, related_name='event_bookings')
    
    # Contact Information (From Image 1)
    full_name = models.CharField(max_length=255, null=True, blank=True)
    nickname = models.CharField(max_length=255, blank=True, null=True)
    email = models.EmailField()
    phone = models.CharField(max_length=20, null=True, blank=True)
    gender = models.CharField(max_length=10, null=True, blank=True)
    dob = models.DateField(null=True, blank=True)
    country = models.CharField(max_length=100, null=True, blank=True)

    # Payment & Ticket Logic
    is_paid = models.BooleanField(default=False)
    stripe_payment_intent_id = models.CharField(max_length=255, blank=True, null=True)
    ticket_id = models.UUIDField(default=uuid.uuid4, editable=False, unique=True)
    booking_date = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('user', 'event')  # Prevents double booking

    def __str__(self):
        return f'{self.full_name} - {self.event.title} ({"Paid" if self.is_paid else "Pending"})'