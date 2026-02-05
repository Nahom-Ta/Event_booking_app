import 'dart:convert';
import 'package:event_booking/app/data/api_constants.dart';
//  import 'package:event_booking/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignUpController extends GetxController {
  //Form KEY
  final signUpFormKey = GlobalKey<FormState>();

  //Text editing controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //State Management
  var isLoading = false.obs;
  var isObscurePassword = true.obs;
  var isObscureConfirmPassword = true.obs;

  @override
  void onClose() {
    //Dispose controllers to free up resources
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // The core registration logic
  Future<void> registerUser() async {
    //validate the form
    if (!signUpFormKey.currentState!.validate()) {
      return;
    }

    try {
      //set loading state to true
      isLoading.value = true;

      // prepare the request body
      var body = {
        "full_name": fullNameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "password2": confirmPasswordController.text,
      };

      //make the api call
      var response = await http.post(
        Uri.parse(Apiconstants.registerUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );
      //Handle the response
      if (response.statusCode == 201) {
        //success
        Get.snackbar(
          'Success',
          'Registration successfull. Please sign in.',
          snackPosition: SnackPosition.BOTTOM,
        );
        // Get.offNamed(Routes.SIGN_IN); // Navigate to sign in screen
      } else {
        //Error
        final errorData = json.decode(response.body);
        //Display the first error message from the backend
        String errorMessage = errorData.entries.first.value[0];
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      //Exception
      Get.snackbar(
        'Error',
        'Something went wrong.Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      //set loading state to false
      isLoading.value = false;
    }
  }
}
