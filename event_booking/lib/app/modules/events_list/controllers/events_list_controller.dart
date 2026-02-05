import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../data/api_constants.dart';
import '../../../data/models/event_model.dart';

import 'package:get_storage/get_storage.dart';

enum EventStatus { upcoming, past }

class EventsListController extends GetxController {
  final storage = GetStorage();
  var isLoadingUpcoming = true.obs;
  var isLoadingPast = false.obs; // Only load past events on demand

  var upcomingEvents = <Event>[].obs;
  var pastEvents = <Event>[].obs;

  // To track if we've already tried fetching past events
  var hasFetchedPastEvents = false;

  @override
  void onInit() {
    super.onInit();
    // Fetch upcoming events immediately when the page loads
    fetchEvents(EventStatus.upcoming);
  }

  Future<void> fetchEvents(EventStatus status) async {
    // Determine which loading indicator and list to update
    final isLoading = status == EventStatus.upcoming
        ? isLoadingUpcoming
        : isLoadingPast;
    final eventList = status == EventStatus.upcoming
        ? upcomingEvents
        : pastEvents;

    try {
      isLoading(true);
      String? token = storage.read('access_token');

      final uri = Uri.parse(Apiconstants.eventsUrl).replace(
        queryParameters: {'status': status.name}, // e.g., ?status=upcoming
      );

      final response = await http.get(
        uri,
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
        Get.snackbar('Error', 'Failed to load ${status.name} events.');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
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
        // Toggle in both lists
        void toggleInList(RxList<Event> list) {
          int index = list.indexWhere((e) => e.id == eventId);
          if (index != -1) {
            final event = list[index];
            list[index] = Event(
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
          }
        }

        toggleInList(upcomingEvents);
        toggleInList(pastEvents);
        upcomingEvents.refresh();
        pastEvents.refresh();
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  // This method is called by the view when the user switches to the "Past" tab
  void onTabChanged(int index) {
    // The "Past" tab is at index 1
    if (index == 1 && !hasFetchedPastEvents) {
      fetchEvents(EventStatus.past);
      hasFetchedPastEvents = true; // Ensure we only fetch it once
    }
  }
}
