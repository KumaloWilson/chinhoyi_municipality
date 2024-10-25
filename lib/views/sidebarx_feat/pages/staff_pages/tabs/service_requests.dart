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

class _ResidentServicesRequestsTabState extends State<ResidentServicesRequestsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Four tabs for statuses
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ServiceRequest> _filterRequestsByStatus(String status) {
    return widget.requests.where((request) {
      final addressMatch = request.residentAddress.toLowerCase().contains(widget.searchTerm.toLowerCase());
      final categoryMatch = request.category.toLowerCase().contains(widget.searchTerm.toLowerCase());
      return (addressMatch || categoryMatch) && request.status == status;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.requests.isEmpty) {
      return const Center(child: Text('No Requests found'));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Open'),
              Tab(text: 'In Progress'),
              Tab(text: 'Resolved'),
              Tab(text: 'Closed'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRequestList('Open'),
                _buildRequestList('In Progress'),
                _buildRequestList('Resolved'),
                _buildRequestList('Closed'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestList(String status) {
    final filteredServices = _filterRequestsByStatus(status);

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
