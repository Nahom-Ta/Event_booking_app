import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:event_booking/app/data/api_constants.dart';


class SignInController extends GetxController {
  final signInFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final storage = GetStorage();

  var isObscure = true.obs;
  var rememberMe = true.obs;
  var isLoading = false.obs;

  Future<void> loginUser() async {
    if (!signInFormKey.currentState!.validate()) {
      return;
    }
    isLoading.value = true;
    var body = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    try {
      var response = await http.post(
        Uri.parse(Apiconstants.loginUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Store tokens
        await storage.write('access_token', data['access']);
        await storage.write('refresh_token', data['refresh']);
        
        // Store email if remember me is checked
        if (rememberMe.value) {
          await storage.write('remembered_email', emailController.text);
        } else {
          await storage.remove('remembered_email');
        }
        
        // Show success message
        Get.snackbar(
          'Success',
          'Login successful!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Navigate to events page
        Get.offAllNamed('explore');
      } else {
        Get.snackbar(
          'Error',
          'Invalid credentials. Please try again',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error', 
        'Something went wrong. Please try again',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Load remembered email if exists
    final rememberedEmail = storage.read('remembered_email');
    if (rememberedEmail != null) {
      emailController.text = rememberedEmail;
      rememberMe.value = true;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
