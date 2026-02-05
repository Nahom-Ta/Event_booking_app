import 'dart:convert';
import 'package:event_booking/app/data/api_constants.dart';
import 'package:event_booking/app/data/models/event_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class BookmarksController extends GetxController {
  final storage = GetStorage();
  var isLoading = true.obs;
  var bookmarkedEvents = <Event>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookmarkedEvents();
  }

  Future<void> fetchBookmarkedEvents() async {
    try {
      isLoading.value = true;
      String? token = storage.read('access_token');

      if (token == null) {
        Get.snackbar('Error', 'Token not found');
        return;
      }

      final response = await http.get(
        Uri.parse('${Apiconstants.baseUrl}/api/events/bookmarks/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        bookmarkedEvents.value = data.map((e) => Event.fromJson(e)).toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch bookmarks');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleBookmark(int eventId) async {
    try {
      String? token = storage.read('access_token');
      if (token == null) return;

      final response = await http.post(
        Uri.parse('${Apiconstants.baseUrl}/api/events/$eventId/bookmark/toggle/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh the list after toggle
        fetchBookmarkedEvents();
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not update bookmark');
    }
  }
}
