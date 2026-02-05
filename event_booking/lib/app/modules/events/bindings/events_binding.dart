import 'package:event_booking/app/modules/events/controllers/events_controller.dart';
import 'package:get/get.dart';


class EventsBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut<EventsController>(
      ()=>EventsController(),
    );
  }
}