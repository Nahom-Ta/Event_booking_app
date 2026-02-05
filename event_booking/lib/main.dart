import 'package:event_booking/app/modules/booking/view/e_ticket_view.dart';
import 'package:event_booking/app/modules/event_details/bindings/event_details_binding.dart';
import 'package:event_booking/app/modules/event_details/views/event_details_view.dart';
import 'package:event_booking/app/modules/events/bindings/events_binding.dart';
import 'package:event_booking/app/modules/events/views/events_view.dart';
import 'package:event_booking/app/modules/events_list/bindings/events_list_binding.dart';
import 'package:event_booking/app/modules/events_list/views/events_list_view.dart';
import 'package:event_booking/app/modules/explore/bindings/explore_binding.dart';
import 'package:event_booking/app/modules/explore/views/explore_view.dart';
import 'package:event_booking/app/modules/booking/bindings/booking_binding.dart';
import 'package:event_booking/app/modules/booking/view/booking_view.dart';
import 'package:event_booking/app/modules/notification/views/notification_view.dart';
import 'package:event_booking/app/modules/profile/bindings/profile_binding.dart';
import 'package:event_booking/app/modules/profile/views/profile_view.dart';
import 'package:event_booking/app/modules/reset_password/bindings/reset_password_binding.dart';
import 'package:event_booking/app/modules/reset_password/views/reset_password_view.dart';
import 'package:event_booking/app/modules/reset_password_confirm/bindings/reset_password_confirm_binding.dart';
import 'package:event_booking/app/modules/reset_password_confirm/views/reset_password_confirm_view.dart';
import 'package:event_booking/app/modules/sign_in/views/sign_in_view.dart';
import 'package:event_booking/app/modules/sign_up/bindings/sign_up_binding.dart';
import 'package:event_booking/app/modules/sign_up/views/sign_up_view.dart';
import 'package:event_booking/app/modules/sign_in/bindings/sign_in_binding.dart';
import 'package:event_booking/app/modules/notification/bindings/notification_binding.dart';
import 'package:event_booking/app/modules/bookmarks/bindings/bookmarks_binding.dart';
import 'package:event_booking/app/modules/bookmarks/views/bookmarks_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:event_booking/app/modules/event_map/controllers/event_map_controller.dart';
import 'package:event_booking/app/modules/event_map/views/event_map_view.dart';
import 'package:event_booking/app/modules/schedule/views/schedule_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/signup',
      getPages: [
        GetPage(
          name: '/signup',
          page: () => const SignUpView(),
          binding: SignUpBinding(),
        ),
        GetPage(
          name: '/singin',
          page: () => SignInView(),
          binding: SignInBinding(),
        ),
        GetPage(
          name: '/explore',
          page: () => ExploreView(),
          binding: ExploreBinding(),
        ),
        GetPage(
          name: '/event_detail',
          page: () => EventDetailsView(),
          binding: EventDetailsBinding(),
        ),
        GetPage(
          name: '/booking',
          page: () => const BookingView(),
          binding: BookingBinding(),
        ),
        GetPage(
          name: '/profile',
          page: () => ProfileView(),
          binding: ProfileBinding(),
        ),
        GetPage(
          name: '/reset_password',
          page: () => const ResetPasswordView(),
          binding: ResetPasswordBinding(),
        ),
        GetPage(
          name: '/reset_password_confirm',
          page: () => const ResetPasswordConfirmView(),
          binding: ResetPasswordConfirmBinding(),
        ),
        GetPage(
          name: '/notification',
          page: () => const NotificationView(),
          binding: NotificationBinding(),
        ),
        GetPage(
          name: '/event',
          page: () => const EventsView(),
          binding: EventsBinding(),
        ),
        GetPage(
          name: '/events_list',
          page: () => const EventsListView(),
          binding: EventsListBinding(),
        ),
        GetPage(
          name: '/bookmarks',
          page: () => const BookmarksView(),
          binding: BookmarksBinding(),
        ),
        GetPage(name: '/e-ticket', page: () => const ETicketView()),
        GetPage(
          name: '/event-map',
          page: () => const EventMapView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<EventMapController>(() => EventMapController());
          }),
        ),
        GetPage(name: '/schedule', page: () => const ScheduleView()),
      ],
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}
