from django.contrib import admin
from .models import Booking


@admin.register(Booking)
class BookingAdmin(admin.ModelAdmin):
	list_display = (
		"event",
		"user",
		"full_name",
		"email",
		"is_paid",
		"booking_date",
	)
	list_filter = ("is_paid", "booking_date")
	search_fields = ("full_name", "email", "event__title", "user__email")
	ordering = ("-booking_date",)
