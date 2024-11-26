import 'package:flutter/material.dart';
import 'package:municipality/views/sidebarx_feat/pages/resident_pages/announcements_management.dart';
import 'package:municipality/views/sidebarx_feat/pages/staff_pages/dashboard.dart';
import 'package:municipality/views/sidebarx_feat/pages/staff_pages/edit_profile_screen.dart';
import 'package:municipality/views/sidebarx_feat/pages/staff_pages/revenue_management.dart';
import 'package:municipality/views/sidebarx_feat/pages/staff_pages/service_requests.dart';
import 'package:municipality/views/sidebarx_feat/pages/staff_pages/manage_residents.dart';
import 'package:municipality/views/sidebarx_feat/pages/staff_pages/manage_users.dart';
import 'package:sidebarx/sidebarx.dart';

class AdminTabScreensContainer extends StatelessWidget {
  const AdminTabScreensContainer({
    super.key,
    required this.controller,
  });

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        switch (controller.selectedIndex) {
          case 0:
            return const StaffDashboard();
          case 1:
            return const ManageResidentsScreen();
          case 2:
            return const ManageStaffScreen();
          case 3:
            return const StaffManageServiceRequestsScreen();
          case 4:
            return const AnnouncementManagementScreen();
          case 5:
            return const RevenueManagementScreen();
          case 6:
            return const StaffProfileScreen();
          default:
            return Text(
              'Not Found',
              style: theme.textTheme.headlineSmall,
            );
        }
      },
    );
  }
}
