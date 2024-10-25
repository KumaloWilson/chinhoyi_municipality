import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:municipality/views/sidebarx_feat/pages/user_tabs_container.dart';
import 'package:municipality/widgets/sidebar/customer_sidebar.dart';
import 'package:sidebarx/sidebarx.dart';
import '../../../core/constants/dimensions.dart';
import '../../../global/global.dart';
import '../../../widgets/sidebar/sidebar.dart';
import 'admin_tabs_container.dart';

class MainScreen extends StatelessWidget {
  final UserRole selectedRole;
  MainScreen({super.key, required this.selectedRole});
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          key: _key,
          body: Row(
            children: [
              selectedRole == UserRole.customer
                  ? CustomerSidebar(controller: _controller)
                  : StaffAdminSidebar(controller: _controller),
              Expanded(
                child: Center(
                  child: selectedRole == UserRole.admin
                    ? AdminTabScreensContainer(
                        controller: _controller,
                      )
                    : CustomerTabScreensContainer(
                        controller: _controller,
                      ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
