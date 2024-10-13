import 'package:flutter/material.dart';
import 'package:municipality/views/sidebarx_feat/pages/staff_pages/manage_residents.dart';
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
            return const Center(child: Text('Screen 1'),);
          case 1:
            return const ManageResidentsScreen();
          case 2:
            return const Center(child: Text('Screen 3'),);
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
