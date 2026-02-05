import 'package:event_booking/app/data/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/events_list_controller.dart';

class EventsListView extends GetView<EventsListController> {
  const EventsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FE), // Soft neutral background for cards to pop
        appBar: AppBar(
          backgroundColor: const Color(0xFFF8F9FE),
          elevation: 0,
          title: const Text(
            'My Events',
            style: TextStyle(
              color: Color(0xFF120D26),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white, // White tab bar container against darker bg
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
              ),
              child: TabBar(
                onTap: controller.onTabChanged,
                indicator: BoxDecoration(
                  color: const Color(0xFF5669FF), // Active tab is now primary color
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF5669FF).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white, // Active text is white
                unselectedLabelColor: const Color(0xFF747688),
                labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                tabs: const [
                  Tab(text: 'upcoming'),
                  Tab(text: 'past events'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // Upcoming Events
            Obx(() {
              if (controller.isLoadingUpcoming.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5669FF)),
                  ),
                );
              }
              if (controller.upcomingEvents.isEmpty) {
                return const Center(
                  child: Text("No upcoming events",
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                );
              }
              return _buildEventGrid(controller.upcomingEvents);
            }),
            // Past Events
            Obx(() {
              if (controller.isLoadingPast.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5669FF)),
                  ),
                );
              }
              if (controller.pastEvents.isEmpty) {
                return const Center(
                  child: Text("No past events",
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                );
              }
              return _buildEventGrid(controller.pastEvents);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildEventGrid(List<Event> events) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85, 
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return GridEventCard(event: events[index]);
      },
    );
  }
}

class GridEventCard extends StatelessWidget {
  final Event event;
  const GridEventCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format Date & Time
    final DateTime dateObj = DateTime.parse(event.date);
    final String dateString = DateFormat('d MMM').format(dateObj).toUpperCase(); // e.g. 18 DEC
    
    String timeString = "";
    try {
      final DateTime timeObj = DateFormat('HH:mm:ss').parse(event.time);
      timeString = DateFormat('h:mm a').format(timeObj); // e.g. 6:00 PM
    } catch (_) {
      timeString = event.time;
    }

    return GestureDetector(
      onTap: () => Get.toNamed('/event_detail', arguments: event.id),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD3D1D8).withOpacity(0.25), // Softer, colored shadow
              blurRadius: 15,
              offset: const Offset(0, 5),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      event.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, st) => Container(
                         color: Colors.grey.shade100,
                         child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => Get.find<EventsListController>().toggleBookmark(event.id),
                        child: Icon(
                          event.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          size: 20,
                          color: event.isBookmarked ? Colors.red : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Content
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14, // Slightly smaller for grid
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF120D26),
                      ),
                    ),
                    
                    // Date & Time
                    Text(
                      "$dateString • $timeString",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5669FF),
                      ),
                    ),

                    // Location
                    Row(
                      children: [
                         const Icon(
                          Icons.location_on_rounded,
                          size: 14,
                          color: Color(0xFF747688),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.locationName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF747688),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
