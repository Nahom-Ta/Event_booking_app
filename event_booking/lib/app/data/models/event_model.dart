// import 'package:event_booking/app/data/api_constants.dart';

// class Event {
//   final int id;
//   final String title;
//   final String description;
//   final String date;
//   final String time;
//   final String locationName;
//   final String imageUrl;
//   final String organizer;

//   Event({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.date,
//     required this.time,
//     required this.locationName,
//     required this.imageUrl,
//     required this.organizer,
//   });
//   /*A factory constructor is a special kind
//    of constructor that can have logic inside
//     and must return an instance of the class.*/
//   factory Event.fromJson(Map<String, dynamic> json) {
//     //to handel the full URL for the image
//     /*the factory constructor creates the full image URL,
//     then passes it as the value for imageUrl
//     field when returning the Event object.*/
//     String imageUrl = Apiconstants.baseUrl + json['image'];
//     return Event(
//       id: json['id'],
//       title: json['title'],
//       description: json['description'],
//       date: json['date'],
//       time: json['time'],
//       locationName: json['location_name'],
//       imageUrl: imageUrl,
//       organizer: json['organizer'],
//     );
//   }
// }
import 'package:event_booking/app/data/api_constants.dart';

class Event {
  final int id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String locationName;
  final String imageUrl;
  final String organizer;
  final String? category;
  final String? customCategory;
  final double? latitude;
  final double? longitude;
  final bool isBookmarked;
  final double price;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.locationName,
    required this.imageUrl,
    required this.organizer,
    this.category,
    this.customCategory,
    this.latitude,
    this.longitude,
    this.isBookmarked = false,
    this.price = 0.0,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    String rawPath = json['image']?.toString() ?? "";

    // Prefix the image with baseUrl if it's not a full URL
    String fullImageUrl = rawPath.startsWith('http')
        ? rawPath
        : Apiconstants.baseUrl + rawPath;

    return Event(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title']?.toString() ?? "No Title",
      description: json['description']?.toString() ?? "",
      date: json['date']?.toString() ?? "",
      time: json['time']?.toString() ?? "",
      locationName: json['location_name']?.toString() ?? "Unknown Location",
      imageUrl: fullImageUrl,
      organizer: json['organizer']?.toString() ?? "Anonymous",
      category: json['category']?.toString(),
      customCategory: json['custom_category']?.toString(),
      isBookmarked: json['is_bookmarked'] ?? false,
      // Safely parse Latitude and Longitude back into the model
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      price: json['price'] != null
          ? double.tryParse(json['price'].toString()) ?? 0.0
          : 0.0,
    );
  }
}
