import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:municipality/models/service_request.dart';
import 'package:municipality/repository/helpers/service_request_helpers.dart';
import '../../core/constants/color_constants.dart';
import '../../core/utils/routes.dart';

class ServiceCard extends StatelessWidget {
  final ServiceRequest serviceRequest;
  final WidgetRef ref;
  const ServiceCard({super.key, required this.serviceRequest, required this.ref});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Open':
        return Colors.orange;
      case 'In Progress':
        return Colors.blue;
      case 'Resolved':
        return Colors.green;
      case 'Closed':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Get.toNamed(RoutesHelper.serviceRequestDetailsScreen, arguments: serviceRequest);
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
                        serviceRequest.category,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        serviceRequest.residentAddress,
                        style: const TextStyle(fontSize: 12),
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
                        title: 'View Request',
                        icon: Icons.remove_red_eye_outlined,
                        onTap: () {},
                      ),

                      buildPopUpOption(
                        title: 'Close Request',
                        icon: Icons.close,
                        onTap: () async{
                          await ServiceRequestHelper.validateAndUpdateRequest(
                            requestID: serviceRequest.requestId,
                            request: serviceRequest.copyWith(
                              status: 'Close'
                            ),
                            ref: ref
                          );
                        },
                      ),
                    ],
                    icon: const Icon(Icons.more_vert),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Status Banner
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(serviceRequest.status),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Text(
              serviceRequest.status.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
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
