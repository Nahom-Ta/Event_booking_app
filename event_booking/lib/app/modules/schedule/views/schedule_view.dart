import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../../data/models/event_model.dart';
import '../controllers/schedule_controller.dart';

class ScheduleView extends GetView<ScheduleController> {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized if not already
    // Ideally this should be in a Binding, but putting it here as per instruction
    // or relying on route binding. Since we are adding route later, we can assume binding.
    // However, user asked to put `Get.put` here.
    if (!Get.isRegistered<ScheduleController>()) {
      Get.put(ScheduleController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Schedule",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // 1. CALENDAR SECTION
          Obx(
            () => TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: controller.focusedDay.value,
              selectedDayPredicate: (day) =>
                  isSameDay(controller.selectedDay.value, day),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              onDaySelected: (selectedDay, focusedDay) {
                controller.selectedDay.value = selectedDay;
                controller.focusedDay.value = focusedDay;
              },
              calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Color(0xff5669FF),
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
          const Divider(),

          // 2. EVENTS LIST SECTION
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value)
                return const Center(child: CircularProgressIndicator());

              final allEvents = controller.bookedEvents.toList();
              final grouped = _groupEventsByDate(allEvents);
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  ...grouped.isEmpty
                      ? [
                          const Center(
                            child: Text(
                              "Nothing planned yet",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ]
                      : _buildGroupedEventWidgets(grouped),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(DateTime date) {
    return Row(
      children: [
        // Date Badge NOT MONTH
        // Image shows "Mar 15" in a small badge?
        // Or "Mar" above "15"? The image has "Mar" small, "15" big inside a square/circle?
        // Let's assume a rounded square badge: Month short, Day bold.
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F4FF), // Light blue background
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                DateFormat('MMM').format(date),
                style: const TextStyle(
                  color: Color(0xFF5669FF),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                DateFormat('d').format(date),
                style: const TextStyle(
                  color: Color(0xFF5669FF),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Date Text
        Expanded(
          child: Text(
            DateFormat('EEEE, d MMM, yyyy').format(date).toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF120D26),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleCard({
    required String title,
    required String dateLabel,
    required Color color,
    required String imageUrl,
    required String location,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Small Circular Image
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: ClipFullOval(imageUrl: imageUrl, size: 45),
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Date
                Text(
                  dateLabel,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 6),
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Location (optional, based on space)
                if (location.isNotEmpty)
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white.withOpacity(0.8),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Optional: Status icon or similar on the far right logic
          // Container(
          //   padding: const EdgeInsets.all(6),
          //   decoration: BoxDecoration(
          //     color: Colors.white.withOpacity(0.2),
          //     shape: BoxShape.circle,
          //   ),
          //   child: const Icon(Icons.check, color: Colors.white, size: 16),
          // ),
        ],
      ),
    );
  }

  String _formatEventDateLabel(String date, String time) {
    try {
      final eventDate = DateTime.parse(date);
      final base = DateFormat(
        'EEE, d MMM, yyyy',
      ).format(eventDate).toUpperCase();
      if (time.isEmpty) return base;
      try {
        final timeObj = DateFormat('HH:mm:ss').parse(time);
        final timeLabel = DateFormat('h:mm a').format(timeObj);
        return '$base • $timeLabel';
      } catch (_) {
        return '$base • $time';
      }
    } catch (_) {
      return 'DATE TBD';
    }
  }

  Color _colorForEvent(dynamic event, int index) {
    final colors = [
      const Color(0xffFF8D5D),
      const Color(0xff8D5DFF),
      const Color(0xff5D8DFF),
      const Color(0xff5DFFB1),
    ];
    final id = event?.id;
    if (id is int && id > 0) {
      return colors[id % colors.length];
    }
    return colors[index % colors.length];
  }

  Map<DateTime, List<Event>> _groupEventsByDate(List<Event> events) {
    final Map<DateTime, List<Event>> grouped = {};
    for (final event in events) {
      final date = _safeDate(event.date);
      final day = DateTime(date.year, date.month, date.day);
      grouped.putIfAbsent(day, () => []).add(event);
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) => a.compareTo(b));
    final Map<DateTime, List<Event>> sorted = {};
    for (final key in sortedKeys) {
      final list = grouped[key] ?? [];
      list.sort((a, b) => _safeDate(a.date).compareTo(_safeDate(b.date)));
      sorted[key] = list;
    }
    return sorted;
  }

  DateTime _safeDate(String date) {
    try {
      return DateTime.parse(date);
    } catch (_) {
      return DateTime.now();
    }
  }

  List<Widget> _buildGroupedEventWidgets(Map<DateTime, List<Event>> grouped) {
    final List<Widget> widgets = [];
    grouped.forEach((date, events) {
      widgets.add(_buildDateHeader(date));
      widgets.add(const SizedBox(height: 15));
      for (int i = 0; i < events.length; i++) {
        final event = events[i];
        final dateLabel = _formatEventDateLabel(event.date, event.time);
        widgets.add(
          _buildScheduleCard(
            title: event.title,
            dateLabel: dateLabel,
            color: _colorForEvent(event, i),
            imageUrl: event.imageUrl,
            location: event.locationName,
          ),
        );
      }
      widgets.add(const SizedBox(height: 6));
    });
    return widgets;
  }
}

class ClipFullOval extends StatelessWidget {
  final String imageUrl;
  final double size;
  const ClipFullOval({super.key, required this.imageUrl, required this.size});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, st) => Container(
                  color: Colors.white24,
                  child: const Icon(Icons.broken_image, color: Colors.white),
                ),
              )
            : Container(
                color: Colors.white24,
                child: const Icon(Icons.event, color: Colors.white),
              ),
      ),
    );
  }
}
