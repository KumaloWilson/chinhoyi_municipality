import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:municipality/models/resident.dart';
import '../../core/utils/routes.dart';

class ResidentCard extends StatelessWidget {
  final Resident residence;
  const ResidentCard({super.key, required this.residence});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RoutesHelper.residentDetailsScreen, arguments: residence);
      },
      child: Container(
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
                    "${residence.lastName} ${residence.firstName}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${residence.property.houseNumber} ${residence.property.suburb}",
                    style:const TextStyle(fontSize: 12),
                  ),
                  Text(
                    residence.phoneNumber,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              subtitle: Text(
                residence.accountStatus,
                style: const TextStyle(fontSize: 12),
              ),
              trailing: PopupMenuButton<int>(
                itemBuilder: (BuildContext context) => [
                  buildPopUpOption(
                    title: 'View Residence',
                    icon: Icons.remove_red_eye_outlined,
                    onTap: () {
                      Get.toNamed(RoutesHelper.residentDetailsScreen, arguments: residence);
                    },
                  ),
                ],
                icon: const Icon(Icons.more_vert),
              ),
            ),
          ],
        ),
      ),
    );
  }

  dynamic buildPopUpOption({
    required String title,
    required IconData icon,
    required void Function() onTap,
  }) {
    return PopupMenuItem<int>(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
