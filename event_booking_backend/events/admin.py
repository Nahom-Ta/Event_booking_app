from django.contrib import admin
from django.utils.html import format_html
from .models import Event


@admin.register(Event)
class EventAdmin(admin.ModelAdmin):

    # Fields shown in the list page
    list_display = ('title', 'date', 'price', 'category', 'custom_category', 'location_name', 'organizer')

    # Search bar
    search_fields = ('title', 'location_name', 'category', 'custom_category', 'organizer__email')

    # Right sidebar filters
    list_filter = ('date', 'category', 'organizer')

    # Editable directly from list view
    list_editable = ('category', 'location_name', 'price',)

    # Default ordering
    ordering = ('date',)

    # Read-only computed field
    readonly_fields = ('image_preview',)

    def image_preview(self, obj):
        if obj.image:
            return format_html(
                '<img src="{}" width="150" height="150" />',
                obj.image.url
            )
        return "No Image"

    image_preview.short_description = 'Image Preview'

    def save_model(self, request, obj, form, change):
        # Set organizer automatically on creation only
        if not change and not obj.organizer:
            obj.organizer = request.user
        super().save_model(request, obj, form, change)


# Admin branding
admin.site.site_header = "Event Booking Administration"
admin.site.site_title = "Event Booking Admin Portal"
admin.site.index_title = "Welcome to Event Booking Admin Portal"
