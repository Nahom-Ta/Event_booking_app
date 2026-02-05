import 'package:get/get.dart';
import 'package:event_booking/app/modules/event_details/controllers/event_details_controller.dart';

class EventDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventDetailsController>(() => EventDetailsController());
  }
}
