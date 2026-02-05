import 'dart:convert';
//sth missing
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:event_booking/app/data/api_constants.dart';
import 'package:event_booking/app/data/models/event_model.dart';

import 'package:get_storage/get_storage.dart';

class ExploreController extends GetxController {
  final storage = GetStorage();
  var selectedIndex = 0.obs;
  var isLoading = true.obs;
  var eventList = <Event>[].obs;

  final searchController = TextEditingController();

  /*When the object/controller is created and initialized, 
it automatically calls fetchEvents() to load event data.
also very similar idea to java instance method*/
  @override
  void onInit() {
    fetchUpcomingEvents(); //fetchEvents(); renamed for clarity
    super.onInit();
  }

  Future<void> fetchUpcomingEvents() async {
    try {
      isLoading(true);
      String? token = storage.read('access_token');
      final response = await http.get(
        Uri.parse(Apiconstants.eventsUrl),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        eventList.value = jsonResponse
            .map((event) => Event.fromJson(event))
            .toList();
      } else {
        Get.snackbar('Error', 'Failed to load events');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  void navigateToEventsPageWithSearch(String query) {
    if (query.isNotEmpty) {
      Get.toNamed('/event', arguments: {'search': query});
    }
  }

  void navigateToEventsPageWithCategory(String category) {
    if (category.isNotEmpty) {
      Get.toNamed('/event', arguments: {'category': category});
    }
  }

  Future<void> toggleBookmark(int eventId) async {
    try {
      String? token = storage.read('access_token');
      if (token == null) {
        Get.snackbar('Auth', 'Please log in to bookmark events');
        return;
      }

      final response = await http.post(
        Uri.parse('${Apiconstants.baseUrl}/api/events/$eventId/bookmark/toggle/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Find the event in the local list and toggle its status to show immediate feedback
        int index = eventList.indexWhere((e) => e.id == eventId);
        if (index != -1) {
          final event = eventList[index];
          // We need to create a new Event object because it's final
          eventList[index] = Event(
            id: event.id,
            title: event.title,
            description: event.description,
            date: event.date,
            time: event.time,
            locationName: event.locationName,
            imageUrl: event.imageUrl,
            organizer: event.organizer,
            category: event.category,
            customCategory: event.customCategory,
            latitude: event.latitude,
            longitude: event.longitude,
            isBookmarked: !event.isBookmarked,
            price: event.price,
          );
          eventList.refresh();
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }
}
