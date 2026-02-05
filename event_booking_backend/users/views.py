from django.shortcuts import render
from rest_framework.response import Response
from rest_framework import status
from .serializers import UserRegistrationSerializer, UserProfileSerializer
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny,IsAuthenticated
from .models import  PasswordResetCode, User
from django.core.mail import send_mail

# Create your views here.
class UserRegistrationView(APIView):
    def post(self, request,format=None):
        serializer=UserRegistrationSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            user=serializer.save()
            return Response({'msg':'Registration Successful'}, status=status.HTTP_201_CREATED),
        return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)
    
class UserProfileView(APIView):
    permission_classes=[IsAuthenticated]

    def get(self,request,*args,**kwargs):
         # The user is available via request.user cuz of  to the JWT token
        serializer=UserProfileSerializer(request.user)
        return Response(serializer.data,status=status.HTTP_200_OK)
     # --- ADD THIS METHOD TO UPDATE PROFILE ---
    def patch(self, request, *args, **kwargs):
        # partial=True allows us to update only the bio or only the picture
        serializer = UserProfileSerializer(request.user, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class PasswordResetRequestView(APIView):
    permission_classes=[AllowAny]

    def post(self,request,*args,**kwargs):
        email=request.data.get('email')
        try:
            user=User.objects.get(email=email)
        except User.DoesNotExist:
            #still return a sucess message to prevent user enumeration
            return Response({"message":"If an account with this email, exists, a reset code has been sent."},status=status.HTTP_200_OK)
        
        #Invalidate old codes
        PasswordResetCode.objects.filter(user=user).delete()


        code=PasswordResetCode.generate_code()
        PasswordResetCode.objects.create(user=user,code=code)

        #send email(will print to consule)
        send_mail(
             'Your Password Reset Code',
            f'Your password reset code is: {code}',
            'from@example.com',
            [user.email],
            fail_silently=False,
        )
        return Response({"message":"If an account with this email exist, a reset code has been sent."},status=status.HTTP_200_OK)
    

class PasswordResetConfirmView(APIView):
    permission_classes=[AllowAny]

    def post(self,request, *args,**kwargs):
        email=request.data.get('email')
        code=request.data.get('code')
        password=request.data.get('password')

        if not all([email,code,password]):
            return Response({"error":"Email,code, and passowrd are required"},status=status.HTTP_400_BAD_REQUEST)
        
        try: 
            user=User.objects.get(email=email)
            reset_instance=PasswordResetCode.objects.get(user=user,code=code)

            #here you might add a check for a code expiry
            user.set_password(password)
            user.save()

            #Delete the code after successful use

            reset_instance.delete()
            return Response({"message": "Password has been reset successfully."},status=status.HTTP_400_BAD_REQUEST)
        except(User.DoesNotExist,reset_instance.DoesNotExist):
            return Response ({"error":"Invalid code or email"}, status=status.HTTP_400_BAD_REQUEST)
            





