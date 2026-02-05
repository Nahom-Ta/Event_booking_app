import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/event_map_controller.dart';

class EventMapView extends GetView<EventMapController> {
  const EventMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events Map"),
        centerTitle: true,
      ),
      body: Obx(() {
         if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
         }
         return GoogleMap(
          initialCameraPosition: CameraPosition(
            // Use passed target or default
            target: controller.initialTarget.value ?? const LatLng(9.005401, 38.763611), 
            zoom: controller.initialTarget.value != null ? 15 : 12,
          ),
          markers: controller.markers,
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        );
      }),
    );
  }
}
