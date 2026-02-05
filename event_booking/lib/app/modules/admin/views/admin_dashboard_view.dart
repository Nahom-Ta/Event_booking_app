import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/admin_controller.dart';
import '../widgets/admin_side_nav.dart';
import '../widgets/admin_top_bar.dart';
import '../widgets/stat_card.dart';

class AdminDashboardView extends GetView<AdminController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminTopBar(title: 'Admin Dashboard'),
      body: Row(
        children: [
          Obx(
            () => AdminSideNav(
              selectedIndex: controller.selectedIndex.value,
              onSelected: (index) => controller.selectedIndex.value = index,
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: const [
                      StatCard(
                        label: 'Total Events',
                        value: '0',
                        icon: Icons.event,
                        color: Colors.indigo,
                      ),
                      StatCard(
                        label: 'Users',
                        value: '0',
                        icon: Icons.people,
                        color: Colors.green,
                      ),
                      StatCard(
                        label: 'Bookings',
                        value: '0',
                        icon: Icons.book,
                        color: Colors.orange,
                      ),
                      StatCard(
                        label: 'Revenue',
                        value: 'ETB 0',
                        icon: Icons.paid,
                        color: Colors.purple,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Recent Activity',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 0,
                    child: SizedBox(
                      height: 240,
                      child: Center(
                        child: Text(
                          'Connect API to show recent events/bookings.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
