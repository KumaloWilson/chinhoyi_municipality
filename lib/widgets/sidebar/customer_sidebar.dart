import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:municipality/core/utils/logs.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/color_constants.dart';
import '../../core/utils/providers.dart';
import '../../core/utils/shared_pref.dart';
import '../../services/auth_service.dart';

class CustomerSidebar extends ConsumerWidget {
  const CustomerSidebar({
    super.key,
    required SidebarXController controller,
  }) : _controller = controller;

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(ProviderUtils.userRoleProvider);

    DevLogs.logWarning(userRole.toString());

    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade800, Colors.blueGrey.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        hoverColor: Colors.blueGrey.withOpacity(0.4),
        textStyle: TextStyle(
            color: Pallete.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500),
        selectedTextStyle: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        itemTextPadding: const EdgeInsets.only(left: 20),
        selectedItemTextPadding: const EdgeInsets.only(left: 20),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.transparent,
          border: Border.all(color: Colors.transparent),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Pallete.primaryColor.withOpacity(0.2),
          border: Border.all(color: Pallete.primaryColor, width: 3),
        ),
        iconTheme: IconThemeData(
          color: Pallete.primaryColor,
          size: 22,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 22,
        ),
      ),
      extendedTheme: SidebarXTheme(
        width: 220,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade800, Colors.blueGrey.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      footerDivider: const Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey,
      ),
      headerBuilder: (context, extended) {
        return SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Icon(
                Icons.account_circle,
                size: 60,
                color: Pallete.primaryColor,
              ),
            ),
          ),
        );
      },
      items: [
        const SidebarXItem(
          icon: Icons.dashboard,
          label: 'Home',
        ),
        const SidebarXItem(
          icon: FontAwesomeIcons.house,
          label: 'Dashboard',
        ),
        const SidebarXItem(
          icon: FontAwesomeIcons.users,
          label: 'Manage Staff',
        ),
        const SidebarXItem(
          icon: Icons.dashboard,
          label: 'Service Requests',
        ),
        const SidebarXItem(
          icon: Icons.notifications_active,
          label: 'Announcements',
        ),

        const SidebarXItem(
          icon: Icons.dashboard,
          label: 'Profile',
        ),
        SidebarXItem(
          icon: Icons.logout,
          label: 'Sign Out',
          onTap: () async {
            await CacheUtils.clearUserRoleFromCache().then((_) async {
              await AuthServices.signOut();
            });
          },
        ),
      ],
    );
  }
}
