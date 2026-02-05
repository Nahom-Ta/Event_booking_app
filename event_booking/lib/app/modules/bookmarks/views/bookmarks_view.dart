import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/bookmarks_controller.dart';
import 'package:event_booking/app/data/models/event_model.dart';

class BookmarksView extends GetView<BookmarksController> {
  const BookmarksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text(
          'Bookmarks',
          style: TextStyle(
            color: Color(0xFF120D26),
            fontSize: 24,
            fontWeight: FontWeight.w500, // Medium weight for a cleaner look
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false, // Move close to return icon
        titleSpacing: 0, // Minimize space between back button and title
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF120D26)),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.bookmarkedEvents.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                const Text(
                  'No bookmarks found',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchBookmarkedEvents,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: controller.bookmarkedEvents.length,
            itemBuilder: (context, index) {
              final event = controller.bookmarkedEvents[index];
              return eventCard(event);
            },
          ),
        );
      }),
    );
  }

  Widget eventCard(Event event) {
    final date = DateTime.parse(event.date);
    final time = DateFormat('HH:mm:ss').parse(event.time);
    final formattedDateTime =
        '${DateFormat('E, MMM d').format(date)} • ${DateFormat('h:mm a').format(time)}';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Get.toNamed('/event_detail', arguments: event.id);
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  event.imageUrl,
                  width: 75,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 75,
                    height: 100,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, size: 30),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedDateTime,
                      style: const TextStyle(
                        color: Color(0xff5668ff),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF120D26),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.toggleBookmark(event.id),
                          child: const Icon(
                            Icons.bookmark,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 15,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.locationName,
                            style: const TextStyle(
                              color: Color(0xFF747688),
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
