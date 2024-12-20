import 'package:flutter/material.dart';
import 'package:municipality/views/sidebarx_feat/pages/resident_pages/announcements_management.dart';
import 'package:municipality/views/sidebarx_feat/pages/resident_pages/customer_payments_history.dart';
import 'package:municipality/views/sidebarx_feat/pages/resident_pages/dashboard.dart';
import 'package:municipality/views/sidebarx_feat/pages/resident_pages/home_page.dart';
import 'package:municipality/views/sidebarx_feat/pages/resident_pages/my_residence_management.dart';
import 'package:municipality/views/sidebarx_feat/pages/resident_pages/profile_screen.dart';
import 'package:municipality/views/sidebarx_feat/pages/resident_pages/resident_service_requests.dart';
import 'package:municipality/views/sidebarx_feat/pages/staff_pages/service_requests.dart';
import 'package:sidebarx/sidebarx.dart';

class CustomerTabScreensContainer extends StatelessWidget {
  const CustomerTabScreensContainer({
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
            return const ChinhoyiMunicipalityScreen();
          case 1:
            return const CustomerDashBoard();
          case 2:
            return const ResidentManageServiceRequestsScreen();
          case 3:
            return const AnnouncementManagementScreen();
          case 4:
            return const CustomerPaymentsHistory();
          case 5:
            return const ResidentProfileScreen();
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
