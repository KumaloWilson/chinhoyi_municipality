import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:municipality/models/family_member.dart';
import '../../core/utils/routes.dart';

class FamilyMemberCard extends StatelessWidget {
  final FamilyMember familyMember;
  const FamilyMemberCard({super.key, required this.familyMember});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${familyMember.lastName} ${familyMember.firstName}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  familyMember.dateOfBirth.toString(),
                  style:const TextStyle(fontSize: 12),
                ),
              ],
            ),
            subtitle: Text(
              familyMember.relationship,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
