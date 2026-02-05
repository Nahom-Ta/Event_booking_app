import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:event_booking/app/data/api_constants.dart';

class BookingController extends GetxController {
  final storage = GetStorage();
  final bookingFormKey = GlobalKey<FormState>();

  // 📝 Form Fields (KEPT)
  final fullNameController = TextEditingController();
  final nicknameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();

  var selectedGender = 'Male'.obs;
  var selectedCountry = 'United States'.obs;
  var isTermsAccepted = false.obs;
  var isLoading = false.obs;

  late int eventId;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args is Map && args['eventId'] != null) {
      eventId = args['eventId'];
    } else {
      eventId = 0;
      Get.snackbar("Error", "Event ID is missing for booking.");
    }

    emailController.text = storage.read('remembered_email') ?? '';
  }

  // 🚀 UPDATED BOOKING + STRIPE FLOW
  Future<void> startBookingProcess() async {
    if (!bookingFormKey.currentState!.validate()) return;

    if (!isTermsAccepted.value) {
      Get.snackbar("Error", "Please accept the Terms");
      return;
    }

    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));

      Get.toNamed(
        '/e-ticket',
        arguments: {
          'full_name': fullNameController.text,
          'nickname': nicknameController.text,
          'gender': selectedGender.value,
          'event_id': eventId,
          'email': emailController.text,
          'phone': phoneController.text,
        },
      );

      Get.snackbar("Success", "Payment Successful (Mock Mode)");
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  // 📅 Date Picker (UNCHANGED)
  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dobController.text = "${picked.year}-${picked.month}-${picked.day}";
    }
  }
}
