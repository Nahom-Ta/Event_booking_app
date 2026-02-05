import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapDetailController extends GetxController {
  late double lat;
  late double lng;
  late String eventTitle;

  var markers = <Marker>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Get coordinates passed from Event Details
    // Use default values if args are missing or null
    final args = Get.arguments;
    if (args != null && args is Map) {
      lat = (args['lat'] is num) ? (args['lat'] as num).toDouble() : 0.0;
      lng = (args['lng'] is num) ? (args['lng'] as num).toDouble() : 0.0;
      eventTitle = args['title']?.toString() ?? 'Event Location';
    } else {
      lat = 0.0;
      lng = 0.0;
      eventTitle = 'Event Location';
    }

    // Set the pin (marker) on the map
    markers.add(
      Marker(
        markerId: const MarkerId('event_pin'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: eventTitle),
      ),
    );
  }
}
