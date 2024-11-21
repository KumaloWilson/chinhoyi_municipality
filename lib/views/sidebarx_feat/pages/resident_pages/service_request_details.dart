import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:municipality/core/constants/color_constants.dart';
import 'package:municipality/models/service_request.dart';

import '../../../../repository/helpers/service_request_helpers.dart';

class ServiceRequestDetailsScreen extends StatelessWidget {
  final ServiceRequest serviceRequest;
  final WidgetRef ref;

  const ServiceRequestDetailsScreen({
    super.key,
    required this.serviceRequest, required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMMM dd, yyyy');
    final resolutionDate = serviceRequest.resolutionDate != null
        ? dateFormat.format(serviceRequest.resolutionDate!)
        : 'Pending';

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Service Request: ${serviceRequest.requestId}',
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Pallete.primaryColor, Pallete.primaryColor.withOpacity(0.4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Status Banner
                Card(
                  margin: const EdgeInsets.only(bottom: 20),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: _getStatusColor(serviceRequest.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        serviceRequest.status.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),

                // Service Request Details Section
                _buildCardSection(
                  title: 'Details',
                  children: [
                    _buildDetailRow('Category:', serviceRequest.category),
                    _buildDetailRow('Description:', serviceRequest.description),
                    _buildDetailRow(
                        'Address:', serviceRequest.residentAddress),
                    _buildDetailRow(
                        'Request Date:', dateFormat.format(serviceRequest.requestDate)),
                    _buildDetailRow('Resolution Date:', resolutionDate),
                  ],
                ),

                // Resolution Notes
                if (serviceRequest.resolutionNotes.isNotEmpty)
                  _buildCardSection(
                    title: 'Resolution Notes',
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          serviceRequest.resolutionNotes,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),

                // Actions Section
                if(serviceRequest.status == 'Open' || serviceRequest.status == 'In Progress')_buildCardSection(
                  title: 'Actions',
                  children: [
                    Row(
                      children: [
                        _buildActionButton(
                          label: 'Mark Resolved',
                          color: Colors.green,
                          onPressed: () async{
                            await ServiceRequestHelper.validateAndUpdateRequest(
                                requestID: serviceRequest.requestId,
                                request: serviceRequest.copyWith(
                                    status: 'Resolved'
                                ),
                                ref: ref
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        _buildActionButton(
                          label: 'Close Request',
                          color: Colors.red,
                          onPressed: () async{
                            await ServiceRequestHelper.validateAndUpdateRequest(
                                requestID: serviceRequest.requestId,
                                request: serviceRequest.copyWith(
                                    status: 'Closed'
                                ),
                                ref: ref
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Open':
        return Colors.orangeAccent;
      case 'In Progress':
        return Colors.blueAccent;
      case 'Resolved':
        return Colors.greenAccent;
      case 'Closed':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  Widget _buildCardSection({required String title, required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
