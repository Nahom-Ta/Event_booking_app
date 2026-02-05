from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .models import Notification
from .serializers import NotificationSerializer
from rest_framework import generics,status

class NotificationListView(generics.ListAPIView):
    serializer_class=NotificationSerializer
    permission_classes=[IsAuthenticated]
    def get_queryset(self):
        return Notification.objects.filter(user=self.request.user)



class NotificationMarkAsReadView(APIView):
    permission_classes=[IsAuthenticated]

    def post(self,request,pk,*args,**kwargs):
        try:
            notification=Notification.objects.get(pk=pk,user=request.user)
            notification.is_read=True
            notification.save()
            return Response(status=status.HTTP_200_OK)
        except Notification.DoesNotExist:
            return Response({"error":"Notification not found"},status=status.HTTP_404_NOT_FOUND)
        