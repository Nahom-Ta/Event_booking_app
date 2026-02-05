import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:timeago/timeago.dart' as timeago;
import 'package:event_booking/app/modules/notification/controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Obx(() {
        // if (controller.isLoading.value) {
        //   return const Center(child: CircularProgressIndicator());
        // }
        // if (controller.notificationList.isEmpty) {
        //   return const Center(
        //     child: Text(
        //       'You have no notifications.',
        //       style: TextStyle(fontSize: 16,color: Colors.grey),
        //     ),
        //   );
        // }
        return RefreshIndicator(
          onRefresh: () => controller.fetchNotifications(),
          child: ListView.builder(
            itemCount: controller.notificationList.length,
            itemBuilder: (context, index) {
              final notification = controller.notificationList[index];
              final isUnread = !notification.isRead;
              return Material(
                color: isUnread
                    ? Get.theme.primaryColor.withOpacity(0.08)
                    : Colors.transparent,
                child: ListTile(
                  onTap: () => controller.markAsRead(notification),
                  leading: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const CircleAvatar(
                          backgroundColor: Color(0xFF5669FF),
                          child: Icon(Icons.notifications, color: Colors.white)),
                      if (isUnread)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Text(
                    notification.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(notification.message),
                  trailing: Text(
                    'trying',
                    //timeago.format(notification.createdAt),
                    style: Get.textTheme.bodySmall,
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
