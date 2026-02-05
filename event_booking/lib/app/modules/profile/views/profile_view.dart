import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:event_booking/app/modules/profile/controllers/profile_controller.dart';
import 'package:event_booking/app/data/api_constants.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF120D26)),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Color(0xFF120D26),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Color(0xFF120D26)),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5669FF)),
            ),
          );
        }

        if (controller.userProfile.value == null) {
          return const Center(
            child: Text("Could not load profile. Check your connection."),
          );
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                // Profile Header
                _buildProfileHeader(),
                const SizedBox(height: 24),
                
                // Stats Row
                _buildStatsRow(),
                const SizedBox(height: 32),
                
                // Divider
                Divider(color: Colors.grey.withOpacity(0.1), height: 1),
                const SizedBox(height: 32),
                
                // About Me
                _buildSectionTitle("About Me"),
                const SizedBox(height: 12),
                _buildBioInput(),
                const SizedBox(height: 32),
                
                // Interests
                _buildSectionTitle("Interests"),
                const SizedBox(height: 16),
                _buildInterestsWrap(),
                
                const SizedBox(height: 40),
                
                // Update Button (Replaces the header Save button for better UX)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Obx(() => ElevatedButton(
                    onPressed: controller.isUpdating.value 
                        ? null 
                        : () => controller.updateProfile(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5669FF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: controller.isUpdating.value
                        ? const SizedBox(
                            width: 24, 
                            height: 24, 
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          )
                        : const Text(
                            "UPDATE PROFILE",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                  )),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader() {
    final profile = controller.userProfile.value!;
    
    return Column(
      children: [
        Stack(
          children: [
            Obx(() {
              ImageProvider provider;
              if (controller.selectedImage.value != null) {
                provider = FileImage(controller.selectedImage.value!);
              } else if (profile.profilePicture != null &&
                  profile.profilePicture!.isNotEmpty) {
                String imageUrl = profile.profilePicture!.startsWith('http')
                    ? profile.profilePicture!
                    : "${Apiconstants.baseUrl}${profile.profilePicture}";
                provider = NetworkImage(imageUrl);
              } else {
                provider = const AssetImage('images/profile.jpg');
              }

              return Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4), // Optional border
                  boxShadow: [
                     BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                       blurRadius: 20,
                       offset: const Offset(0, 10),
                     ),
                  ],
                  image: DecorationImage(
                    image: provider,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }),
            Positioned(
              bottom: 0,
              right: 0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => controller.pickImage(),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5669FF),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          profile.fullname,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF120D26),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          profile.email, // Using email as subtitle or ID
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF747688),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatItem("Following", "350"),
        Container(
          height: 30,
          width: 1,
          color: Colors.grey.withOpacity(0.2),
          margin: const EdgeInsets.symmetric(horizontal: 30),
        ),
        _buildStatItem("Followers", "346"),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF120D26),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF747688),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return  Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF120D26),
        ),
      ),
    );
  }

  Widget _buildBioInput() {
    return TextField(
      controller: controller.bioController,
      maxLines: 5,
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF3C3E56), // Slightly lighter than pure black for text body
        height: 1.6,
      ),
      decoration: InputDecoration(
        hintText: "Write something about yourself...",
        hintStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: const Color(0xFFF9F9F9), // Very light grey
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildInterestsWrap() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _buildInterestChip("Games Online", const Color(0xFF6B7AED)),
          _buildInterestChip("Concert", const Color(0xFFEE544A)),
          _buildInterestChip("Music", const Color(0xFF29D697)),
          _buildInterestChip("Art", const Color(0xFF39C3F2)),
          _buildInterestChip("Movie", const Color(0xFFF58848)), // Orange
          _buildInterestChip("Others", const Color(0xFF9399D1)), // Purple greyish
        ],
      ),
    );
  }

  Widget _buildInterestChip(String label, Color color) {
    // Professional approach: 
    // Option 1: Light background with colored text (Pill style)
    // Option 2: Clean outline
    // We'll go with Option 1 for a modern app feel but keep it subtle.
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), // Very light background of the color
        borderRadius: BorderRadius.circular(20),
        // border: Border.all(color: color.withOpacity(0.2)), // Optional border
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Optional small dot
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(1.0), // Full color text
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
