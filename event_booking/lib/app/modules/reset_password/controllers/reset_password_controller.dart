import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:event_booking/app/data/api_constants.dart';

class ResetPasswordController extends GetxController {
  final resetPasswordFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  var isLoading = false.obs;

  Future<void> requestPasswordReset() async {
    if (!resetPasswordFormKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse(Apiconstants.passwordResetRequestUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': emailController}),
      );
      final responseBody = json.decode(response.body);
      Get.snackbar(
        'Info',
        responseBody['message'],
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occured.');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
