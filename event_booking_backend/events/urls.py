from django.urls import path 
from .views import EventListView, EventDetailView, BookmarkToggleView, BookmarkedEventsListView
from django.conf.urls.static import static
from django.conf import settings
from bookings.views import BookingCreateView 

urlpatterns = [
    path('', EventListView.as_view(), name='event-list'),
    path('<int:pk>/', EventDetailView.as_view(), name='event_detail'),
    path('<int:event_id>/book/', BookingCreateView.as_view(), name='event_book'),
    path('bookmarks/', BookmarkedEventsListView.as_view(), name='bookmarked-events'),
    path('<int:event_id>/bookmark/toggle/', BookmarkToggleView.as_view(), name='toggle-bookmark'),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)