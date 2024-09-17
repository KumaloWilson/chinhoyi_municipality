import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../core/constants/color_constants.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({
    super.key,
    required SidebarXController controller,
  }) : _controller = controller;

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: Theme.of(context).primaryColor,
        textStyle: TextStyle(color: Pallete.primaryColor),
        selectedTextStyle: TextStyle(color: Pallete.primaryColor),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Pallete.primaryColor, width: 4),
        ),
        iconTheme: IconThemeData(
          color: Pallete.primaryColor,
          size: 20,
        ),
        selectedIconTheme: IconThemeData(
          color: Pallete.primaryColor,
          size: 20,
        ),
      ),
      extendedTheme: SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
        ),
      ),
      footerDivider: Divider(),
      headerBuilder: (context, extended) {
        return SizedBox(
          height: 100,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.account_circle,
                size: 50, color: Pallete.primaryColor),
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.home,
          label: 'Home',
          onTap: () {
            debugPrint('Home');
          },
        ),
        const SidebarXItem(
          icon: Icons.edit_note,
          label: 'Add User',
        ),
        const SidebarXItem(
          icon: Icons.analytics,
          label: 'Staff statistics',
        ),
      ],
    );
  }
}
