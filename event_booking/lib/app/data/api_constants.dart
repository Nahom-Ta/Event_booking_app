// class Apiconstants{
//   static const String baseUrl='http://10.0.2.2:8000/api'; //for android emulator
//   static const String registerUrl='$baseUrl/auth/register/';
//   static const String loginUrl='${baseUrl}token/';
//   static const String eventsBaseUrl='$baseUrl/api/events/';
// }

import 'package:flutter/foundation.dart';

class Apiconstants {
  static const String baseUrl = kIsWeb
      ? 'http://localhost:8000'
      : 'http://10.0.2.2:8000';
  static const String authBaseUrl = '$baseUrl/api/auth/';
  static const String eventsBaseUrl = '$baseUrl/api/events/'; // New

  static const String registerUrl = '${authBaseUrl}register/';
  static const String loginUrl = '${authBaseUrl}token/';
  static const String eventsUrl = eventsBaseUrl; // New
  static const String profileurl = '${authBaseUrl}me/';
  // new function to generate the booking url for a specfic event
  static String bookEventUrl(int eventId) => '$eventsBaseUrl$eventId/book/';

  static const String passwordResetRequestUrl =
      '${authBaseUrl}password-reset/request/';
  static const String passwordResetConfirmUrl =
      '${authBaseUrl}password-reset/confirm/';
  static const String notificationsUrl = '$baseUrl/api/notifications/';
  static String markNotificationAsReadUrl(int id) =>
      '$notificationsUrl$id/mark-as-read/';
  // Add these to your existing Apiconstants class
static const String bookingsBaseUrl = '$baseUrl/api/bookings/';
static const String createBookingUrl = '${bookingsBaseUrl}create/';
static const String confirmPaymentUrl = '${bookingsBaseUrl}confirm/';
static const String userScheduleUrl = '${bookingsBaseUrl}my-schedule/';
}
