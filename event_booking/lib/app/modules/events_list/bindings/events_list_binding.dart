import 'package:get/get.dart';
import '../controllers/events_list_controller.dart';

class EventsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventsListController>(
      () => EventsListController(),
    );
  }
}