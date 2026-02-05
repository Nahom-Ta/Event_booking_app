import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:event_booking/app/data/api_constants.dart';
import 'package:event_booking/app/data/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EventsController extends GetxController {
  final storage = GetStorage();
  final isLoading = true.obs;
  final eventList = <Event>[].obs;
  final pageTitle = 'Events'.obs;
  final searchController = TextEditingController();

  List<Event> _allEvents = [];
  String? _initialSearch;
  String? _initialCategory;

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is Map) {
      _initialSearch = args['search']?.toString();
      _initialCategory = args['category']?.toString();
    }
    fetchEvents();
    super.onInit();
  }

  Future<void> fetchEvents() async {
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
        final List jsonResponse = json.decode(response.body);
        _allEvents = jsonResponse
            .map((event) => Event.fromJson(event))
            .toList();
        eventList.assignAll(_allEvents);

        if ((_initialSearch ?? '').isNotEmpty) {
          performSearch(_initialSearch!);
        } else if ((_initialCategory ?? '').isNotEmpty) {
          performSearch(_initialCategory!);
        }
      } else {
        Get.snackbar('Error', 'Failed to load events');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  void performSearch(String query) {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      pageTitle.value = 'Events';
      eventList.assignAll(_allEvents);
      return;
    }

    pageTitle.value = 'Results for "$trimmedQuery"';
    final lower = trimmedQuery.toLowerCase();
    final filtered = _allEvents.where((event) {
      return event.title.toLowerCase().contains(lower) ||
          event.description.toLowerCase().contains(lower) ||
          event.locationName.toLowerCase().contains(lower) ||
          event.organizer.toLowerCase().contains(lower) ||
          (event.category?.toLowerCase() == lower) ||
          (event.customCategory?.toLowerCase().contains(lower) ?? false);
    }).toList();
    eventList.assignAll(filtered);
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
        // Find and toggle in both lists
        void toggleInList(List<Event> list) {
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

        toggleInList(_allEvents);
        toggleInList(eventList);
        eventList.refresh();
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
