from django.urls import path
from .views import BookingCreateView, ConfirmPaymentView, UserScheduleView

urlpatterns = [
    path('create/', BookingCreateView.as_view(), name='create-booking'),
    path('confirm/', ConfirmPaymentView.as_view(), name='confirm-payment'),
    path('my-schedule/', UserScheduleView.as_view(), name='user-schedule'),
]