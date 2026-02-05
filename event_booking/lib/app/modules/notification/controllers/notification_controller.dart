import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:event_booking/app/data/api_constants.dart';
import 'package:event_booking/app/data/models/notification_model.dart';

class NotificationController extends GetxController{
  final storage=const FlutterSecureStorage();
  var isLoading=true.obs;
  var notificationList=<NotificationModel>[].obs;

  @override
  void  onInit(){
    super.onInit();
    //fetchNotifications();
  }
  Future<void> fetchNotifications()async{
    try {
      isLoading(true);
      String? token=await storage.read(key:'access_token' );
      if (token==null)return;

      final response=await http.get(
        Uri.parse(Apiconstants.notificationsUrl),
        headers:{'Authorization':'Bearer $token'},
      );
      
      if (response.statusCode==200) {
        final List data=json.decode(response.body);
         notificationList.value=data.map((item)=>
         NotificationModel.fromJson(item)).toList();
      }else{
        Get.snackbar('Error', 'Failed to fetch notifications.');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occured.');
    }finally{
      isLoading(false);
    }
  }
Future<void> markAsRead(NotificationModel notification) async{
  if(notification.isRead)return; //do not make api call if already read
  try {
    String? token=await storage.read(key: 'access_token');
    if(token==null)return;

    final response=await http.post(
      Uri.parse(Apiconstants.markNotificationAsReadUrl(notification.id)),
      headers: {'Authorization':'Bearer $token'},
    );
    
    if (response.statusCode==200) {
      //update the local list to reflect the change immediately
      //Check if its id matches the id of the notification we clicked and n is one of the notificationList
      int index=notificationList.indexWhere((n)=>n.id==notification.id);
      if(index!=-1){
        notificationList[index].isRead=true;
        
      }
    }
  } catch (e) {
    
  }

}

}