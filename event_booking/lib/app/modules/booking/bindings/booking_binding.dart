import 'package:get/get.dart';
import '../controller/booking_controller.dart';

class BookingBinding extends Bindings {
  @override
  void dependencies() {
    // lazyPut means the controller is only created when the page is actually opened
    Get.lazyPut<BookingController>(() => BookingController());
  }
}
