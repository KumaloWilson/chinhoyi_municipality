import 'package:flutter/material.dart';
import '../../../../../models/service_request.dart';
import '../../../../../widgets/cards/service_card.dart';

class ResidentServicesRequestsTab extends StatefulWidget {
  final String searchTerm;
  final List<ServiceRequest> requests;
  const ResidentServicesRequestsTab({
    super.key,
    required this.requests,
    required this.searchTerm,
  });

  @override
  State<ResidentServicesRequestsTab> createState() => _ResidentServicesRequestsTabState();
}

class _ResidentServicesRequestsTabState extends State<ResidentServicesRequestsTab> {
  @override
  Widget build(BuildContext context) {
    if (widget.requests.isEmpty) {
      return const Center(child: Text('No Requests found'));
    }

    final filteredServices = widget.requests.where((requests) {
      final nameMatch = requests.resident.firstName.toLowerCase().contains(widget.searchTerm.toLowerCase());
      final lastNameMatch = requests.resident.lastName.toLowerCase().contains(widget.searchTerm.toLowerCase());
      final emailMatch = requests.resident.email.toLowerCase().contains(widget.searchTerm.toLowerCase());
      return nameMatch || emailMatch || lastNameMatch;
    }).toList();

    if (filteredServices.isEmpty) {
      return const Center(child: Text('No matching service found.'));
    }

    return ListView.builder(
      itemCount: filteredServices.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final service = filteredServices[index];
        return ServiceCard(serviceRequest: service);
      },
    );
  }
}
