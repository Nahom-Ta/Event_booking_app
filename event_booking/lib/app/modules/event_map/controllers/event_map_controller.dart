import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../../../data/api_constants.dart';
import '../../../data/models/event_model.dart';

class EventMapController extends GetxController {
  final storage = GetStorage();
  var markers = <Marker>{}.obs;
  var isLoading = true.obs;

  Rx<LatLng?> initialTarget = Rx<LatLng?>(null);

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map && args['lat'] != null && args['lng'] != null) {
      initialTarget.value = LatLng(
        (args['lat'] as num).toDouble(),
        (args['lng'] as num).toDouble(),
      );
    }
    fetchAllEvents();
  }

  Future<void> fetchAllEvents() async {
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
        List<Event> events = jsonResponse
            .map((event) => Event.fromJson(event))
            .toList();

        // Convert events to markers
        for (var event in events) {
          if (event.latitude != null && event.longitude != null) {
            markers.add(
              Marker(
                markerId: MarkerId(event.id.toString()),
                position: LatLng(event.latitude!, event.longitude!),
                infoWindow: InfoWindow(
                  title: event.title,
                  snippet: event.locationName,
                  onTap: () {
                    Get.toNamed('/event_detail', arguments: event.id);
                  },
                ),
              ),
            );
          }
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load events on map: $e');
    } finally {
      isLoading(false);
    }
  }
}
