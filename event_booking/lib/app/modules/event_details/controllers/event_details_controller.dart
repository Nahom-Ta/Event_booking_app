import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:event_booking/app/data/api_constants.dart';
import 'package:event_booking/app/data/models/event_model.dart';
import 'package:intl/intl.dart'; //Format dates/times to strings in a customized or localized way.
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class EventDetailsController extends GetxController {
  // Make eventId 'late' - we promise to initialize it before using it.
  late final int eventId;
  final storage = const FlutterSecureStorage();
  var isLoading = true.obs;
  var isBooking = false.obs;
  final Rx<Event?> event = Rx<Event?>(null);

  @override
  void onInit() {
    super.onInit();

    // THE FIX: Initialize eventId here, inside onInit.
    // This is safer because onInit runs after the controller is created
    // and arguments are properly available.
    if (Get.arguments != null) {
      eventId = Get.arguments;
      fetchEventDetails();
    } else {
      // Handle the case where no ID was passed
      isLoading.value = false;
      Get.snackbar('Error', 'Event ID is missing. Cannot load details.');
      // Optionally, navigate back
      // Get.back();
    }
  }

  Future<void> fetchEventDetails() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('${Apiconstants.eventsUrl}$eventId/'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        event.value = Event.fromJson(data);
      } else {
        Get.snackbar('Error', 'Failed to load event details.');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> bookTicket() async {
    try {
      isBooking.value = true;
      String? token = await storage.read(key: 'access_token');
      if (token == null) {
        Get.snackbar('Error', 'You must be logged in to book');
        return;
      }
      final response = await http.post(
        Uri.parse(Apiconstants.bookEventUrl(eventId)),
        headers: {'Authorization': 'Bearer $token'},
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode == 201) {
        Get.snackbar(
          'Success',
          responseBody['message'],
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          responseBody['message'],
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occured:$e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isBooking.value = false;
    }
  }

  // Helper methods remain the same
  String getFormattedDate() {
    if (event.value == null) return '';
    final date = DateTime.parse(event.value!.date);
    return DateFormat('d MMMM, yyyy').format(date);
  }

  String getFormattedTime() {
    if (event.value == null) return '';
    final time = DateFormat('HH:mm:ss').parse(event.value!.time);
    final day = DateTime.parse(event.value!.date);
    return '${DateFormat('EEEE').format(day)}, ${DateFormat('h:mm a').format(time)}';
  }
}
