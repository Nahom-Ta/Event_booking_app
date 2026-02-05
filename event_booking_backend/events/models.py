from django.db import models
from django.conf import settings


class Event(models.Model):
    title = models.CharField(max_length=200)
    description = models.TextField()

    # FIXED: data ➜ date
    date = models.DateField()
    time = models.TimeField()

    location_name = models.CharField(max_length=100)

    image = models.ImageField(
        upload_to='event_images/',
        null=True,
        blank=True
    )

    CATEGORY_CHOICES = [
        ('Sports', 'Sports'),
        ('Music', 'Music'),
        ('Food', 'Food'),
        ('Art', 'Art'),
        ('Movies', 'Movies'),
        ('Other', 'Other'),
    ]

    category = models.CharField(
        max_length=50,
        choices=CATEGORY_CHOICES,
        default='Other'
    )

    custom_category = models.CharField(
        max_length=100,
        blank=True,
        null=True,
        help_text="Specify category if 'Other' is selected"
    )

    price = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    
    # --- MODIFICATION IS HERE ---
    # We are changing this from CharField to a ForeignKey.
    # This links an event to a specific user who created it.

    # Link event to the user who created it
    organizer = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        null=True,        # IMPORTANT for migrations
        blank=True
    )

    latitude = models.FloatField(null=True, blank=True)
    longitude = models.FloatField(null=True, blank=True)

    def __str__(self):
        return self.title


class Bookmark(models.Model):
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='bookmarks'
    )
    event = models.ForeignKey(
        Event,
        on_delete=models.CASCADE,
        related_name='bookmarked_by'
    )
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('user', 'event')

    def __str__(self):
        return f"{self.user.email} bookmarked {self.event.title}"

