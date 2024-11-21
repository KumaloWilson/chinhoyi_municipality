import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:municipality/core/constants/color_constants.dart';
import 'package:municipality/models/resident.dart';
import 'package:municipality/models/service_request.dart';
import 'package:municipality/repository/helpers/service_request_helpers.dart';
import 'package:municipality/widgets/custom_button/general_button.dart';
import 'package:municipality/widgets/custom_dropdown.dart';
import 'package:municipality/widgets/text_fields/custom_text_field.dart';

class AddServiceRequestScreen extends StatefulWidget {
  final Resident resident;
  final WidgetRef ref;
  const AddServiceRequestScreen({super.key, required this.resident, required this.ref});

  @override
  State<AddServiceRequestScreen> createState() => _AddServiceRequestScreenState();
}

class _AddServiceRequestScreenState extends State<AddServiceRequestScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _resolutionNotesController = TextEditingController();

  String _selectedCategory = 'Water';
  String _selectedStatus = 'Open';
  DateTime _requestDate = DateTime.now();
  DateTime? _resolutionDate;

  final List<String> _categories = [
    'Water',
    'Electricity',
    'Waste',
    'Maintenance',
    'Roads',
    'Sewage',
    'Street Lighting',
    'Parks',
    'Other'
  ];

  final List<String> _statusOptions = [
    'Open',
    'In Progress',
    'Resolved',
    'Closed'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Add Service Request',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Pallete.primaryColor,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        margin: const EdgeInsets.symmetric(horizontal: 300, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              offset: Offset(-5, -5),
              blurRadius: 10,
            ),
            BoxShadow(
              color: Colors.black12,
              offset: Offset(5, 5),
              blurRadius: 10,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Resident Information Section
              _buildSectionTitle('Resident Information'),
              const SizedBox(height: 16),
              _buildResidentInfo(),
              const SizedBox(height: 32),

              // Request Details Section
              _buildSectionTitle('Request Details'),
              const SizedBox(height: 16),
              _buildRequestDetails(),
              const SizedBox(height: 32),

              // Resolution Details Section
              _buildSectionTitle('Resolution Details'),
              const SizedBox(height: 16),
              _buildResolutionDetails(),
              const SizedBox(height: 32),

              // Submit Button
              Center(
                child: GeneralButton(
                  onTap: (){
                    final serviceRequest = ServiceRequest(
                      requestId: DateTime.now().millisecondsSinceEpoch.toString(),
                      residentAddress: "${widget.resident.property.houseNumber} ${widget.resident.property.suburb}",
                      description: _descriptionController.text,
                      category: _selectedCategory,
                      requestDate: _requestDate,
                      status: _selectedStatus,
                      resolutionDate: _resolutionDate,
                      resolutionNotes: _resolutionNotesController.text,
                    );

                    ServiceRequestHelper.validateAndSubmitForm(serviceRequest: serviceRequest, ref: widget.ref);

                  },
                  width: 200,
                  height: 45,
                  borderRadius: 10,
                  btnColor: Pallete.primaryColor,
                  child: const Text(
                    'Submit Request',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildResidentInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Name', '${widget.resident.firstName} ${widget.resident.lastName}'),
          const SizedBox(height: 8),
          _buildInfoRow('Property', widget.resident.property.houseNumber),
          const SizedBox(height: 8),
          _buildInfoRow('Contact', widget.resident.phoneNumber),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    );
  }

  Widget _buildRequestDetails() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomDropDown(
                items: _categories,
                selectedValue: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                isEnabled: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _requestDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _requestDate = picked;
                    });
                  }
                },
                child: CustomTextField(
                  labelText: 'Request Date',
                  enabled: false,
                  controller: TextEditingController(
                    text: DateFormat('yyyy-MM-dd').format(_requestDate),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _descriptionController,
          labelText: 'Description',
        ),
      ],
    );
  }

  Widget _buildResolutionDetails() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomDropDown(
                items: _statusOptions,
                selectedValue: _selectedStatus,
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
                isEnabled: false,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  if (_selectedStatus == 'Resolved' || _selectedStatus == 'Closed') {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _resolutionDate ?? DateTime.now(),
                      firstDate: _requestDate,
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _resolutionDate = picked;
                      });
                    }
                  }
                },
                child: CustomTextField(
                  labelText: 'Resolution Date',
                  enabled: _selectedStatus == 'Resolved' || _selectedStatus == 'Closed',
                  controller: TextEditingController(
                    text: _resolutionDate != null
                        ? DateFormat('yyyy-MM-dd').format(_resolutionDate!)
                        : '',
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _resolutionNotesController,
          labelText: 'Resolution Notes',
          enabled: _selectedStatus == 'Resolved' || _selectedStatus == 'Closed',
        ),
      ],
    );
  }
}