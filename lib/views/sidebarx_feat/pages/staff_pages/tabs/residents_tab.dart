import 'package:flutter/material.dart';
import 'package:municipality/models/resident.dart';

import '../../../../../widgets/cards/residents_card.dart';

class ResidentTab extends StatefulWidget {
  final String searchTerm;
  final List<Resident> residences;
  const ResidentTab({
    super.key,
    required this.residences,
    required this.searchTerm,
  });

  @override
  State<ResidentTab> createState() => _ResidentTabState();
}

class _ResidentTabState extends State<ResidentTab> {
  @override
  Widget build(BuildContext context) {
    if (widget.residences.isEmpty) {
      return const Center(child: Text('No Residences found'));
    }

    final filteredUsers = widget.residences.where((resident) {
      String fullName = "${resident.firstName} ${resident.lastName}";
      String reverseFullName = "${resident.lastName} ${resident.firstName}";
      String address = "${resident.property.houseNumber} ${resident.property.suburb}";
      String reverseAddress = "${resident.property.suburb} ${resident.property.houseNumber}";

      
      final nameMatch = fullName.toLowerCase().contains(widget.searchTerm.toLowerCase()) || reverseFullName.toLowerCase().contains(widget.searchTerm.toLowerCase());
      final addressMatch = address.toLowerCase().contains(widget.searchTerm.toLowerCase()) || reverseAddress.toLowerCase().contains(widget.searchTerm.toLowerCase());
      final emailMatch = resident.email.toLowerCase().contains(widget.searchTerm.toLowerCase());
      return nameMatch || emailMatch || addressMatch;
    }).toList();

    if (filteredUsers.isEmpty) {
      return const Center(child: Text('No matching residence found.'));
    }

    return ListView.builder(
      itemCount: filteredUsers.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final residence = filteredUsers[index];
        return ResidentCard(residence: residence);
      },
    );
  }
}
