import 'package:flutter/material.dart';
import 'package:municipality/models/resident.dart';

import '../../../../../widgets/cards/residents_card.dart';

class ResidentTab extends StatefulWidget {
  final String searchTerm;
  final List<Resident> users;
  const ResidentTab({
    super.key,
    required this.users,
    required this.searchTerm,
  });

  @override
  State<ResidentTab> createState() => _ResidentTabState();
}

class _ResidentTabState extends State<ResidentTab> {
  @override
  Widget build(BuildContext context) {
    if (widget.users.isEmpty) {
      return const Center(child: Text('No Residents found'));
    }

    final filteredUsers = widget.users.where((resident) {
      final nameMatch = resident.firstName.toLowerCase().contains(widget.searchTerm.toLowerCase());
      final lastNameMatch = resident.lastName.toLowerCase().contains(widget.searchTerm.toLowerCase());
      final emailMatch = resident.email.toLowerCase().contains(widget.searchTerm.toLowerCase());
      return nameMatch || emailMatch || lastNameMatch;
    }).toList();

    if (filteredUsers.isEmpty) {
      return const Center(child: Text('No matching resident found.'));
    }

    return ListView.builder(
      itemCount: filteredUsers.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final user = filteredUsers[index];
        return ResidentCard(resident: user);
      },
    );
  }
}
