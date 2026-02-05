import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:event_booking/app/data/models/user_profile_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:event_booking/app/data/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final storage = GetStorage();

  var isLoading = true.obs;
  var isUpdating = false.obs;

  final Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);

  // For editing
  final bioController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      String? token = storage.read('access_token');

      if (token == null) {
        Get.snackbar(
          'Error',
          'Authentication token not found. Please log in again',
        );
        return;
      }

      final response = await http.get(
        Uri.parse(Apiconstants.profileurl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final profile = UserProfile.fromJson(decoded);
        userProfile.value = profile;
        // Sync the controller text with the profile bio
        bioController.text = profile.bio ?? '';
      } else {
        Get.snackbar('Error', 'Failed to fetch profile.');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Pick image from gallery
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage.value = File(image.path);
      updateProfile();
    }
  }

  // Upload Bio and/or Image
  Future<void> updateProfile() async {
    try {
      isUpdating.value = true;
      String? token = storage.read('access_token');

      if (token == null) {
        Get.snackbar(
          'Error',
          'Authentication token not found. Please log in again',
        );
        return;
      }

      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse(Apiconstants.profileurl),
      );

      request.headers.addAll({'Authorization': 'Bearer $token'});

      // Add text fields
      request.fields['bio'] = bioController.text;
      request.fields['full_name'] = userProfile.value?.fullname ?? '';

      // Add image file if selected
      if (selectedImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_picture',
            selectedImage.value!.path,
          ),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final profile = UserProfile.fromJson(decoded);
        userProfile.value = profile;
        // Sync the controller text with the updated bio
        bioController.text = profile.bio ?? '';

        Get.snackbar(
          'Success',
          'Profile updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar('Error', 'Failed to update profile');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  @override
  void onClose() {
    bioController.dispose();
    super.onClose();
  }
}
