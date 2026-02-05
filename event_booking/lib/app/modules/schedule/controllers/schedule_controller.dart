import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../../../data/api_constants.dart';
import '../../../data/models/event_model.dart';

class ScheduleController extends GetxController {
  final storage = GetStorage();
  var selectedDay = DateTime.now().obs;
  var focusedDay = DateTime.now().obs;

  var bookedEvents = <Event>[].obs;
  var isLoading = false.obs;
  Event? _pendingEvent;
  static const _localScheduleKey = 'scheduled_events';
  final List<Event> _localEvents = [];

  @override
  void onInit() {
    super.onInit();
    _loadLocalEvents();
    // Check for arguments passed from navigation
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args.containsKey('initialDate')) {
        try {
          String dateStr = args['initialDate'];
          DateTime initialDate = DateTime.parse(dateStr);
          selectedDay.value = initialDate;
          focusedDay.value = initialDate;
        } catch (e) {
          print("Error parsing initial date: $e");
        }
      }
      if (args.containsKey('event') && args['event'] is Map) {
        _pendingEvent = _eventFromArgs(args['event'] as Map);
        _mergePendingEvent();
      }
    }
    fetchUserSchedule();
  }

  Future<void> fetchUserSchedule() async {
    try {
      isLoading.value = true;
      String? token = storage.read('access_token');

      if (token == null) {
        print("No token found");
        _mergeAll();
        return;
      }

      final response = await http.get(
        Uri.parse(Apiconstants.userScheduleUrl),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        // Mapping simple JSON to Event model with defaults for missing fields
        final serverEvents = data
            .map(
              (json) => Event(
                id: json['id'] is int
                    ? json['id']
                    : int.tryParse(json['id'].toString()) ?? 0,
                title: json['title'] ?? "Event",
                description: "", // Default
                date: json['date'] ?? DateTime.now().toIso8601String(),
                time: json['time']?.toString() ?? "", // Default empty
                locationName: json['location'] ?? "Unknown",
                imageUrl: _normalizeImageUrl(
                  json['image_url']?.toString() ?? "",
                ),
                organizer: "", // Default
              ),
            )
            .toList();
        _mergeAll(serverEvents: serverEvents);
      } else {
        print("Failed to load schedule: ${response.statusCode}");
        _mergeAll();
      }
    } catch (e) {
      print("Schedule Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Event _eventFromArgs(Map json) {
    final rawImage =
        json['image_url']?.toString() ?? json['imageUrl']?.toString() ?? "";
    return Event(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title']?.toString() ?? "Event",
      description: "",
      date: json['date']?.toString() ?? DateTime.now().toIso8601String(),
      time: json['time']?.toString() ?? "",
      locationName: json['location']?.toString() ?? "Unknown",
      imageUrl: _normalizeImageUrl(rawImage),
      organizer: "",
    );
  }

  void _mergePendingEvent() {
    if (_pendingEvent == null) return;
    final pendingKey = _eventKey(_pendingEvent!);
    final exists = bookedEvents.any((e) => _eventKey(e) == pendingKey);
    if (!exists) {
      bookedEvents.insert(0, _pendingEvent!);
    }
    _addLocalEvent(_pendingEvent!);
    _saveLocalEvents();
  }

  void _loadLocalEvents() {
    final raw = storage.read(_localScheduleKey);
    if (raw is List) {
      _localEvents
        ..clear()
        ..addAll(
          raw.whereType<Map>().map((json) => _eventFromArgs(json)).toList(),
        );
      if (_localEvents.isNotEmpty) {
        bookedEvents.value = List<Event>.from(_localEvents);
      }
    }
  }

  void _saveLocalEvents() {
    final list = bookedEvents.map(_eventToMap).toList();
    storage.write(_localScheduleKey, list);
  }

  Map<String, dynamic> _eventToMap(Event event) {
    return {
      'id': event.id,
      'title': event.title,
      'date': event.date,
      'time': event.time,
      'location': event.locationName,
      'image_url': event.imageUrl,
    };
  }

  String _eventKey(Event event) {
    if (event.id > 0) return event.id.toString();
    return '${event.title}|${event.date}|${event.time}';
  }

  List<Event> _mergeByKey(List<Event> primary, List<Event> secondary) {
    final map = <String, Event>{};
    for (final e in primary) {
      map[_eventKey(e)] = e;
    }
    for (final e in secondary) {
      map.putIfAbsent(_eventKey(e), () => e);
    }
    return map.values.toList();
  }

  void _addLocalEvent(Event event) {
    final key = _eventKey(event);
    final exists = _localEvents.any((e) => _eventKey(e) == key);
    if (!exists) {
      _localEvents.insert(0, event);
    }
  }

  void _mergeAll({List<Event>? serverEvents}) {
    final merged = _mergeByKey(_localEvents, serverEvents ?? bookedEvents);
    _localEvents
      ..clear()
      ..addAll(merged);
    bookedEvents.value = merged;
    if (_pendingEvent != null) {
      _mergePendingEvent();
    }
    _saveLocalEvents();
  }

  String _normalizeImageUrl(String rawPath) {
    if (rawPath.isEmpty) return "";
    return rawPath.startsWith('http')
        ? rawPath
        : Apiconstants.baseUrl + rawPath;
  }

  List<Event> getEventsForDay(DateTime day) {
    return bookedEvents.where((event) {
      DateTime? eventDate;
      try {
        eventDate = DateTime.parse(event.date);
      } catch (e) {
        return false;
      }

      return eventDate.year == day.year &&
          eventDate.month == day.month &&
          eventDate.day == day.day;
    }).toList();
  }
}
