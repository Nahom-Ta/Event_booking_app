import stripe
from django.conf import settings
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated

from .models import Booking
from events.models import Event

#  Use environment variable (VERY IMPORTANT for deployment)
stripe.api_key = settings.STRIPE_SECRET_KEY


class BookingCreateView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        event_id = request.data.get('event_id')
        if not event_id:
            return Response({"error": "Event ID is required."}, status=status.HTTP_400_BAD_REQUEST)
        # 1️⃣ Get event
        try:
            event = Event.objects.get(id=event_id)
        except Event.DoesNotExist:
            return Response(
                {"error": "Event not found."},
                status=status.HTTP_404_NOT_FOUND
            )

        # 2️⃣ Prevent duplicate booking
        if Booking.objects.filter(user=request.user, event=event).exists():
            return Response(
                {"error": "You have already booked this event."},
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            # 3️⃣ Create Stripe PaymentIntent
            intent = stripe.PaymentIntent.create(
                amount=int(event.price * 100),  # cents
                currency="usd",
                metadata={
                    "user_id": request.user.id,
                    "event_id": event.id,
                }
            )

            # 4️⃣ Create booking (Pending)
            booking = Booking.objects.create(
                user=request.user,
                event=event,
                status="Pending",
                payment_intent_id=intent.id
            )

            # 5️⃣ Return client_secret to frontend
            return Response(
                {
                    "message": "Payment intent created",
                    "client_secret": intent.client_secret,
                    "booking_id": booking.id,
                    "price": event.price,
                },
                status=status.HTTP_201_CREATED
            )

        except stripe.error.StripeError as e:
            return Response(
                {"error": str(e)},
                status=status.HTTP_400_BAD_REQUEST
            )


class ConfirmPaymentView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        booking_id = request.data.get('booking_id')
        if not booking_id:
            return Response({"error": "Booking ID is required."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            booking = Booking.objects.get(id=booking_id, user=request.user)
        except Booking.DoesNotExist:
            return Response({"error": "Booking not found."}, status=status.HTTP_404_NOT_FOUND)

        booking.status = "Paid"
        booking.save(update_fields=["status"])

        return Response({"message": "Payment confirmed", "booking_id": booking.id}, status=status.HTTP_200_OK)


class UserScheduleView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        # Fetch all bookings for the current user
        bookings = Booking.objects.filter(user=request.user).select_related('event')
        
        data = []
        for b in bookings:
            data.append({
                "id": b.event.id,
                "title": b.event.title,
                # Make sure your Event model has a 'date' field
                "date": b.event.date.isoformat() if b.event.date else "2026-03-15T10:00:00",
                "image_url": b.event.image.url if b.event.image else "",
                "location": b.event.location_name,
            })
        return Response(data)
