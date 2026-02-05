import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
//import 'package:event_booking/app/routes/app_pages.dart';
import 'package:event_booking/app/data/api_constants.dart';

class ResetPasswordConfirmController extends GetxController {
  final confirmFormKey = GlobalKey<FormState>();
  late final String email;

  final codeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isLoading = false.obs;
  var isObscurePass = true.obs;
  var isObscureConfirm = true.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      email = Get.arguments;
    } else {
      isLoading.value = false;
      Get.snackbar('Error', 'Email is missing. Cannot load details.');
    }
  }

  Future<void> confirmPasswordReset() async {
    if (!confirmFormKey.currentState!.validate()) return;
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(Apiconstants.passwordResetConfirmUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'code': codeController.text,
          'password': passwordController.text,
        }),
      );
      final responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          responseBody['message'],
          backgroundColor: Colors.green,
        );
        //Get.offAllNamed(Routes.SIGN_IN);
      } else {
        Get.snackbar(
          'error',
          responseBody['error'] ?? 'An error occured.',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occured');
    } finally {
      isLoading.value = false;
    }
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  void onClose() {
    codeController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
