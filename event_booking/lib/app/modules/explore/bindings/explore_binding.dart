import 'package:event_booking/app/modules/explore/controllers/explore_controller.dart';
import 'package:get/get.dart';

class ExploreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExploreController>(() => ExploreController());
  }
}
