import 'package:get/get.dart';
import 'package:event_booking/app/modules/notification/controllers/notification_controller.dart';

class NotificationBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut<NotificationController>(
      ()=>NotificationController(),
    );
  }
}