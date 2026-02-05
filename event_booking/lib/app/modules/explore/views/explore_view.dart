import 'package:event_booking/app/data/models/event_model.dart';
import 'package:event_booking/app/modules/explore/controllers/explore_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:event_booking/app/modules/chatbot/views/chatbot_view.dart'; // Import Chatbot

class ExploreView extends GetView<ExploreController> {
  const ExploreView({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ... (existing App Bar params, no changes here just context)
        backgroundColor: Get.theme.colorScheme.primary,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Column(
          children: const [
            Text("Current Location", style: TextStyle(fontSize: 12)),
            SizedBox(height: 6),
            Text(
              "Addiss Abeba, ETH",
              style: TextStyle(
                color: Color(0xfff4f4fe),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed('/notification'),
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      drawer: sidebar(),
      body: Stack( // Wrap in Stack
        children: [
          // 1. Existing Content
          Column(
            children: [
              appBarExtension(),
              const SizedBox(height: 25),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => controller.fetchUpcomingEvents(),
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(12),
                    children: [
                      upcomingEvents(),
                      invitationCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // 2. Chatbot Overlay
          const ChatbotView(),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: "Explore",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: "Events",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "map"),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Profile",
            ),
          ],
          currentIndex: controller.selectedIndex.value,
          selectedItemColor: Get.theme.colorScheme.primary,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            controller.selectedIndex.value = value;
            switch (value) {
              case 1:
                Get.toNamed('/events_list');
                break;
              case 2:
                Get.toNamed('/event-map');
                break;
              case 3:
                Get.toNamed('/profile');
                break;
              default:
                Get.toNamed('/explore');
                break;
            }
          },
        ),
      ),
    );
  }

  Widget sidebar() {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(backgroundImage: AssetImage('images/profile.jpg')),
                SizedBox(height: 12),
                Text(
                  "Selam Tesfaye",
                  style: TextStyle(
                    color: Color(0xff110c26),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            minVerticalPadding: 0,
            minLeadingWidth: 0,
            leading: Image.asset("images/icon_person.png"),
            title: const Text("My Profile"),
            onTap: () {
              Get.back();
              Get.toNamed('/profile');
            },
          ),
          ListTile(
            minVerticalPadding: 0,
            minLeadingWidth: 0,
            leading: Image.asset('images/icon_message.png'),
            title: const Text("Message"),
            onTap: () {},
          ),
          ListTile(
            minVerticalPadding: 0,
            minLeadingWidth: 0,
            leading: Image.asset('images/icon_calendar.png'),
            title: const Text("Calendar"),
            onTap: () {
              Get.back();
              Get.toNamed('/schedule');
            },
          ),
          ListTile(
            minVerticalPadding: 0,
            minLeadingWidth: 0,
            leading: Image.asset('images/icon_bookmark.png'),
            title: const Text("Bookmark"),
            onTap: () {
              Get.back(); // Close drawer
              Get.toNamed('/bookmarks');
            },
          ),
          ListTile(
            minVerticalPadding: 0,
            minLeadingWidth: 0,
            leading: Image.asset('images/icon_email.png'),
            title: const Text("Contact us"),
            onTap: () {},
          ),
          ListTile(
            minVerticalPadding: 0,
            minLeadingWidth: 0,
            leading: Image.asset('images/icon_settings.png'),
            title: const Text("Settings"),
            onTap: () {},
          ),
          ListTile(
            minVerticalPadding: 0,
            minLeadingWidth: 0,
            leading: Image.asset('images/icon_help.png'),
            title: const Text("Help & FAQs"),
            onTap: () {},
          ),
          ListTile(
            minVerticalPadding: 0,
            minLeadingWidth: 0,
            leading: Image.asset('images/icon_logout.png'),
            title: const Text("Sign out"),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget appBarExtension() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 90,
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
        ),
        TextField(
          controller: controller.searchController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search",
            hintStyle: const TextStyle(color: Colors.white70),
            prefixIcon: IconButton(
              onPressed: () {
                controller.navigateToEventsPageWithSearch(controller.searchController.text);
              },
              icon: const Icon(Icons.search, color: Colors.white),
            ),
            suffixIcon: IconButton(
              onPressed: () {},
              icon: Icon(Icons.filter_list, color: Colors.white),
            ),
          ),
          onTap: () {
            // Remove Get.toNamed from onTap to avoid navigating on just clicking the field
            // Or use it to go to event page but without query? 
            // User said: "bring you to the event page and give you with the specfied resuled searched ones"
          },
          onSubmitted: (value) =>
              controller.navigateToEventsPageWithSearch(value),
        ),
        Positioned(
          top: 60,
          child: Container(
            color: Colors.transparent,
            width: Get.width,
            height: 60,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  SizedBox(width: 18),
                  category(
                    title: "Sports",
                    icon: const Icon(Icons.sports_basketball),
                    color: Colors.red,
                    onPressed: () =>
                        controller.navigateToEventsPageWithCategory("Sports"),
                  ),
                  const SizedBox(width: 8),
                  category(
                    title: "Music",
                    icon: const Icon(Icons.library_music),
                    color: Colors.orange,
                    onPressed: () =>
                        controller.navigateToEventsPageWithCategory("Music"),
                  ),
                  const SizedBox(width: 8),
                  category(
                    title: "Foods",
                    icon: const Icon(Icons.food_bank),
                    color: Colors.green,
                    onPressed: () =>
                        controller.navigateToEventsPageWithCategory("Foods"),
                  ),
                  const SizedBox(width: 8),
                  category(
                    title: "Movies",
                    icon: const Icon(Icons.movie),
                    color: Colors.cyan,
                    onPressed: () =>
                        controller.navigateToEventsPageWithCategory("Movies"),
                  ),
                  const SizedBox(width: 18),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget category({
    required String title,
    required Icon icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(40, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: onPressed,
      icon: icon,
      label: Text(title),
    );
  }

  // Updated upcomingEvents widget
  Widget upcomingEvents() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Upcoming Events", style: Get.textTheme.titleLarge),
            const Spacer(),
            TextButton(
              onPressed: () => Get.toNamed('/events_list'),
              child: Row(
                children: [
                  Text("See All", style: Get.theme.textTheme.labelMedium),
                  const Icon(Icons.arrow_right, color: Color(0xff747688)),
                ],
              ),
            ),
          ],
        ),
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          // --- DYNAMIC DATA IS NOW ACTIVE ---
          if (controller.eventList.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(child: Text("No upcoming events found")),
            );
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: controller.eventList.map((event) {
                return eventCard(event: event); // Pass the event object
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  // Updated dynamic eventCard widget
  Widget eventCard({required Event event}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(right: 12),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
          Get.toNamed('/event_detail', arguments: event.id);
        },
        child: Container(
          width: 250,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Image.network(
                      event.imageUrl,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 50),
                        );
                      },
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => controller.toggleBookmark(event.id),
                        child: Icon(
                          event.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          size: 22,
                          color: event.isBookmarked ? Colors.red : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                event.title,
                style: Get.textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Color(0xFF716E90),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      event.locationName,
                      style: Get.theme.textTheme.labelSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget invitationCard() {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.cyan.shade100,
          image: const DecorationImage(
            image: AssetImage("images/invitation_card.png"),
            fit: BoxFit.contain,
            alignment: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Invite your friends", style: Get.textTheme.titleLarge),
            const SizedBox(height: 20),
            const Text(
              "Get \$20 for ticket",
              style: TextStyle(color: Color(0xff484d70), fontSize: 13),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Get.bottomSheet(
                  listOfFriends(),
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                );
              },
              child: const Text("Invite"),
            ),
          ],
        ),
      ),
    );
  }

  Widget listOfFriends() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(12),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text("Invite Freiend", style: Get.textTheme.titleLarge),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage('images/profile.jpg'),
                      ),
                      title: const Text("Selam Tesfaye"),
                      subtitle: const Text("3.4k Follower"),
                      trailing: Checkbox(
                        value: false,
                        onChanged: (value) {},
                        shape: const CircleBorder(),
                      ),
                    ),
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage("images/profile.jpg"),
                      ),
                      title: const Text("Meron Tulu"),
                      subtitle: const Text("2K Followers"),
                      trailing: Checkbox(
                        value: false,
                        onChanged: (value) {},
                        shape: const CircleBorder(),
                      ),
                    ),
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage("images/profile.jpg"),
                      ),
                      title: const Text("Chaltu Tulu"),
                      subtitle: const Text("2K Followers"),
                      trailing: Checkbox(
                        value: false,
                        onChanged: (value) {},
                        shape: const CircleBorder(),
                      ),
                    ),
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage("images/profile.jpg"),
                      ),
                      title: const Text("Chaltu Tulu"),
                      subtitle: const Text("2K Followers"),
                      trailing: Checkbox(
                        value: false,
                        onChanged: (value) {},
                        shape: const CircleBorder(),
                      ),
                    ),
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage("images/profile.jpg"),
                      ),
                      title: const Text("Betty Tesfaye"),
                      subtitle: const Text("2K Followers"),
                      trailing: Checkbox(
                        value: false,
                        onChanged: (value) {},
                        shape: const CircleBorder(),
                      ),
                    ),
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage("images/profile.jpg"),
                      ),
                      title: const Text("Jennie Kim"),
                      subtitle: const Text("2K Followers"),
                      trailing: Checkbox(
                        value: false,
                        onChanged: (value) {},
                        shape: const CircleBorder(),
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(48, 12, 48, 12),
              child: ElevatedButton(
                onPressed: () {}, // () => Get.back(),
                child: Row(
                  children: const [
                    Spacer(),
                    Text("INVITE"),
                    Spacer(),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
