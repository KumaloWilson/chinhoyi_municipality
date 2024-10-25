import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:municipality/core/constants/color_constants.dart';
import 'package:municipality/core/utils/logs.dart';
import 'package:municipality/models/announcement.dart';
import 'package:municipality/repository/helpers/announcement_helper.dart';
import 'package:municipality/widgets/custom_button/general_button.dart';
import 'package:municipality/widgets/custom_dropdown.dart';
import 'package:municipality/widgets/snackbar/custom_snackbar.dart';
import 'package:municipality/widgets/text_fields/custom_text_field.dart';

class AddAnnouncementScreen extends StatefulWidget {
  final WidgetRef ref;
  const AddAnnouncementScreen({super.key, required this.ref});

  @override
  State<AddAnnouncementScreen> createState() => _AddAnnouncementScreenState();
}

class _AddAnnouncementScreenState extends State<AddAnnouncementScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedCategory = 'General';
  DateTime _announcementDate = DateTime.now();
  bool _isHighPriority = false;

  File? _selectedFile;
  String? _fileName;
  final user = FirebaseAuth.instance.currentUser;

  final List<String> _categories = [
    'General',
    'Emergency',
    'Maintenance',
    'Community',
    'Events',
    'Other'
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Add Announcement',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.newspaper,
                    size: 100,
                    color: Pallete.primaryColor,
                  )
                ],
              ),
              _buildSectionTitle('Announcement Details'),
              const SizedBox(height: 16),
              _buildAnnouncementDetails(),
              const SizedBox(height: 32),

              _buildSectionTitle('Additional Information'),
              const SizedBox(height: 16),
              _buildAdditionalInfo(),
              const SizedBox(height: 32),

              Center(
                child: Center(
                  child: GeneralButton(
                    onTap: _submitAnnouncement,
                    width: 200,
                    height: 45,
                    borderRadius: 10,
                    btnColor: Pallete.primaryColor,
                    child: const Text(
                   'Submit Announcement',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildAnnouncementDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          CustomTextField(
            controller: _titleController,
            labelText: 'Title',
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _descriptionController,
            labelText: 'Description',
          ),
          const SizedBox(height: 16),
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
                      initialDate: _announcementDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() {
                        _announcementDate = picked;
                      });
                    }
                  },
                  child: CustomTextField(
                    labelText: 'Date',
                    enabled: false,
                    controller: TextEditingController(
                      text: DateFormat('yyyy-MM-dd').format(_announcementDate),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo() {
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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attachment',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_fileName != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Selected file: $_fileName',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ElevatedButton.icon(
                      onPressed: _pickFile,
                      icon: const Icon(Icons.attach_file),
                      label: const Text('Choose File'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallete.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: _isHighPriority,
                onChanged: (value) {
                  setState(() {
                    _isHighPriority = value!;
                  });
                },
              ),
              const Text('High Priority Announcement'),
            ],
          ),
        ],
      ),
    );
  }

  void _submitAnnouncement() {

    final announcement = Announcement(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      date: _announcementDate,
      category: _selectedCategory,
      imageUrl: '',
      status: 'active',
      isHighPriority: _isHighPriority,
    );

    AddAnnouncementHelper.validateAndSubmitAnnouncement(
      file: _selectedFile,
      fileName: _fileName,
      announcement: announcement,
      ref: widget.ref,
      user: user!
    );
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
          _fileName = result.files.single.name;
        });
      }
    } catch (e) {
      DevLogs.logError('Error picking file: $e');
      CustomSnackBar.showErrorSnackbar(message: e.toString());
    }
  }
}