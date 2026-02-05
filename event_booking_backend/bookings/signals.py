from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import Booking
from notifications.models import Notification

@receiver(post_save,sender=Booking)
def create_booking_notification(sender, instance, created,**kwarg):
    if created:
        Notification.objects.create(
            user=instance.user,
            title='Booking Confirmed',
            message=f"You have successfully booked a ticket for {instance.event.title}"
        )