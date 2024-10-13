import 'package:flutter/material.dart';
import 'package:municipality/models/staff_profile.dart';

import '../../../../../widgets/cards/staff_card.dart';

class StaffTab extends StatefulWidget {
  final String searchTerm;
  final List<StaffProfile> users;
  const StaffTab({
    super.key,
    required this.users,
    required this.searchTerm,
  });

  @override
  State<StaffTab> createState() => _StaffTabState();
}

class _StaffTabState extends State<StaffTab> {
  @override
  Widget build(BuildContext context) {
    if (widget.users.isEmpty) {
      return const Center(child: Text('No staff found'));
    }

    final filteredUsers = widget.users.where((staff) {
      final nameMatch = staff.firstName.toLowerCase().contains(widget.searchTerm.toLowerCase());
      final surnameMatch = staff.lastName.toLowerCase().contains(widget.searchTerm.toLowerCase());
      final emailMatch = staff.email.toLowerCase().contains(widget.searchTerm.toLowerCase());
      return nameMatch || emailMatch || surnameMatch;
    }).toList();

    if (filteredUsers.isEmpty) {
      return const Center(child: Text('No matching staff found.'));
    }

    return ListView.builder(
      itemCount: filteredUsers.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final user = filteredUsers[index];
        return StaffCard(user: user);
      },
    );
  }
}
