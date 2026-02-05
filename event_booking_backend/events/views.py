from django.utils import timezone
from django.db.models import Q
from rest_framework import status, generics
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from .models import Event, Bookmark
from .serializers import EventSerializer

class EventListView(generics.ListAPIView):
    serializer_class = EventSerializer

    def get_queryset(self):
        queryset = Event.objects.all()
        
        status_param = self.request.query_params.get('status', None)
        today = timezone.now().date()

        if status_param == 'upcoming':
            queryset = queryset.filter(date__gte=today)
        elif status_param == 'past':
            queryset = queryset.filter(date__lt=today)

        search_query = self.request.query_params.get('search', None)
        if search_query:
            queryset = queryset.filter(
                Q(title__icontains=search_query) |
                Q(description__icontains=search_query) |
                Q(location_name__icontains=search_query)
            )

        category = self.request.query_params.get('category', None)
        if category:
            queryset = queryset.filter(
                Q(category__iexact=category) |
                Q(custom_category__icontains=category)
            )

        return queryset.order_by('-date')


class EventDetailView(generics.RetrieveAPIView):
    queryset = Event.objects.all()
    serializer_class = EventSerializer


class BookmarkToggleView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, event_id):
        try:
            event = Event.objects.get(id=event_id)
        except Event.DoesNotExist:
            return Response({"error": "Event not found"}, status=status.HTTP_404_NOT_FOUND)

        bookmark, created = Bookmark.objects.get_or_create(user=request.user, event=event)

        if not created:
            bookmark.delete()
            return Response({"is_bookmarked": False, "message": "Bookmark removed"}, status=status.HTTP_200_OK)

        return Response({"is_bookmarked": True, "message": "Bookmark added"}, status=status.HTTP_201_CREATED)


class BookmarkedEventsListView(generics.ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = EventSerializer

    def get_queryset(self):
        return Event.objects.filter(bookmarked_by__user=self.request.user).order_by('-bookmarked_by__created_at')
