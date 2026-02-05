from rest_framework import serializers
from .models import Event, Bookmark

class EventSerializer(serializers.ModelSerializer):
    # This forces Django to send the "full_name" string instead of the ID integer
    organizer = serializers.ReadOnlyField(source='organizer.full_name')
    is_bookmarked = serializers.SerializerMethodField()

    class Meta:
        model = Event
        fields = '__all__'

    def get_is_bookmarked(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return Bookmark.objects.filter(user=request.user, event=obj).exists()
        return False

    def validate(self, data):
        """
        Check that custom_category is provided if category is 'Other'.
        Otherwise, clear custom_category.
        """
        category = data.get('category')
        custom_category = data.get('custom_category')

        if category == 'Other':
            if not custom_category:
                raise serializers.ValidationError({"custom_category": "Please specify the category when 'Other' is selected."})
        else:
            # If category is NOT 'Other', force custom_category to be empty
            if 'custom_category' in data:
                data['custom_category'] = None
        
        return data