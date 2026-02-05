import 'package:event_booking/app/data/models/event_model.dart';
import 'package:event_booking/app/modules/events/controllers/events_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For date formatting

class EventsView extends GetView<EventsController> {
  const EventsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Obx(() => Text(controller.pageTitle.value))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          searchEvent(),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.eventList.isEmpty) {
                return const Center(
                  child: Text(
                    "No events found.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }
              return ListView.builder(
                itemCount: controller.eventList.length,
                itemBuilder: (context, index) {
                  final event = controller.eventList[index];
                  return eventCard(event);
                },
              );
            }),
          ),
          const SizedBox(height: 12),
        ],
      ),
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
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 75),
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
                            style: Get.theme.textTheme.titleMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.toggleBookmark(event.id),
                          child: Icon(
                            event.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                            color: event.isBookmarked ? Colors.red : Colors.grey,
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
                            style: Get.theme.textTheme.labelMedium,
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

  Widget searchEvent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {
                    Get.bottomSheet(
                      filters(),
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.filter_list),
                ),
              ),
              onSubmitted: (value) => controller.performSearch(value),
            ),
          ),
        ],
      ),
    );
  }

  Widget filters() {
    return Container(
      height: Get.height / 1.2,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filter",
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
          const Spacer(),
          filterCategories(),
          const Spacer(),
          filterDateAndTime(),
          const Spacer(),
          filterLocation(),
          const Spacer(),
          filterPriceRange(),
          const Spacer(),
          filterActionsButton(),
        ],
      ),
    );
  }

  Widget filterCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  minimumSize: const Size(60, 60),
                ),
                child: const Icon(Icons.sports_basketball_outlined),
              ),
              const SizedBox(height: 12),
              const Text('Sports'),
            ],
          ),
          const SizedBox(width: 24),
          Column(
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: const CircleBorder(),
                  minimumSize: const Size(60, 60),
                ),
                child: const Icon(
                  Icons.music_note_outlined,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              const Text('Music'),
            ],
          ),
          const SizedBox(width: 24),
          Column(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  minimumSize: const Size(60, 60),
                ),
                child: const Icon(Icons.brush),
              ),
              const SizedBox(height: 12),
              const Text('Art'),
            ],
          ),
          const SizedBox(width: 24),
          Column(
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: const CircleBorder(),
                  minimumSize: const Size(60, 60),
                ),
                child: const Icon(
                  Icons.restaurant_menu_outlined,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              const Text('Foods'),
            ],
          ),
          const SizedBox(width: 24),
          Column(
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: const CircleBorder(),
                  minimumSize: const Size(60, 60),
                ),
                child: const Icon(Icons.movie, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              const Text('Movies'),
            ],
          ),
        ],
      ),
    );
  }

  Widget filterDateAndTime() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Time & Date"),
        const SizedBox(height: 12),
        Row(
          children: [
            OutlinedButton(onPressed: () {}, child: const Text("Today")),
            const SizedBox(width: 12),
            ElevatedButton(onPressed: () {}, child: const Text("Tomorrow")),
            const SizedBox(width: 12),
            OutlinedButton(onPressed: () {}, child: const Text("This week")),
          ],
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.calendar_month),
              SizedBox(width: 8),
              Text("Choose from calendar"),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios, size: 15),
            ],
          ),
        ),
      ],
    );
  }

  Widget filterLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Location"),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {},
          child: Row(
            children: const [
              Icon(Icons.map),
              SizedBox(width: 8),
              Expanded(child: Text("Philippines")),
              Icon(Icons.arrow_forward_ios, size: 15),
            ],
          ),
        ),
      ],
    );
  }

  Widget filterActionsButton() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("Reset"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(onPressed: () {}, child: const Text("Apply")),
        ),
      ],
    );
  }

  Widget filterPriceRange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Price range"),
        const SizedBox(height: 12),
        RangeSlider(
          max: 100,
          divisions: 10,
          values: const RangeValues(0, 100),
          onChanged: (RangeValues values) {},
        ),
      ],
    );
  }
}
