from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),

    path('api/auth/', include('users.urls')),  # users app URLs
    path('api/notification/', include('notifications.urls')),  # notifications URLs
    path('api/events/', include('events.urls')),  # events URLs

    # Optionally add a homepage or redirect here if you want
]
