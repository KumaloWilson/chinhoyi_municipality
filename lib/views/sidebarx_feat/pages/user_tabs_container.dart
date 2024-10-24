import 'package:flutter/material.dart';
import 'package:municipality/views/sidebarx_feat/pages/resident_pages/resident_service_requests.dart';
import 'package:municipality/views/sidebarx_feat/pages/staff_pages/service_requests.dart';
import 'package:sidebarx/sidebarx.dart';

class UserTabScreensContainer extends StatelessWidget {
  const UserTabScreensContainer({
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
            return const Center(child: Text('Home Screen 1'),);
          case 1:
            return const Center(child: Text('Home Screen 2'),);
          case 2:
            return const Center(child: Text('Home Screen 3'),);
          case 3:
            return const ResidentManageServiceRequestsScreen();
          case 4:
            return const Center(child: Text('Home Screen 5'),);
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
