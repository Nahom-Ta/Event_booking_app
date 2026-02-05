//import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

import 'package:event_booking/app/modules/reset_password_confirm/controllers/reset_password_confirm_controller.dart';
import 'package:get/get.dart';

class ResetPasswordConfirmBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordConfirmController>(
      () => ResetPasswordConfirmController(),
    );
  }
}
