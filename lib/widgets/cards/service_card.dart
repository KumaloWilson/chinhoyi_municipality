import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:municipality/models/resident.dart';
import 'package:municipality/models/service_request.dart';
import '../../core/constants/color_constants.dart';
import '../../core/utils/routes.dart';

class ServiceCard extends StatelessWidget {
  final ServiceRequest serviceRequest;
  const ServiceCard({super.key, required this.serviceRequest});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RoutesHelper.residentDetailsScreen, arguments: serviceRequest);
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
                    "${serviceRequest.category}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    serviceRequest.residentAddress,
                    style:const TextStyle(fontSize: 12),
                  ),
                  Text(
                    serviceRequest.description,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              subtitle: Text(
                serviceRequest.category,
                style: const TextStyle(fontSize: 12),
              ),
              trailing: PopupMenuButton<int>(
                itemBuilder: (BuildContext context) => [
                  buildPopUpOption(
                    title: 'View Residence',
                    icon: Icons.remove_red_eye_outlined,
                    value: 0,
                    onTap: () {

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
    required int value,
    required void Function() onTap,
  }) {
    return PopupMenuItem<int>(
      onTap: onTap,
      value: value,
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
