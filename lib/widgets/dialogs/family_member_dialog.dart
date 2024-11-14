import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/family_member.dart';
import '../custom_dropdown.dart';
import '../text_fields/custom_text_field.dart';

class AddFamilyMemberDialog extends StatefulWidget {
  final Function(FamilyMember) onAdd;

  const AddFamilyMemberDialog({
    super.key,
    required this.onAdd,
  });

  @override
  _AddFamilyMemberDialogState createState() => _AddFamilyMemberDialogState();
}

class _AddFamilyMemberDialogState extends State<AddFamilyMemberDialog> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  String relationship = 'Spouse';
  DateTime? dateOfBirth;
  bool isDependent = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Family Member'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: firstNameController,
              labelText: 'First Name',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: lastNameController,
              labelText: 'Last Name',
            ),
            const SizedBox(height: 16),
            CustomDropDown(
              items: const ['Spouse', 'Child', 'Parent', 'Other'],
              selectedValue: relationship,
              onChanged: (value) {
                setState(() {
                  relationship = value!;
                });
              },
              isEnabled: true,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() {
                    dateOfBirth = picked;
                  });
                }
              },
              child: CustomTextField(
                labelText: 'Date of Birth',
                enabled: false,
                controller: TextEditingController(
                  text: dateOfBirth != null
                      ? DateFormat('yyyy-MM-dd').format(dateOfBirth!)
                      : '',
                ),
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Is Dependent'),
              value: isDependent,
              onChanged: (value) {
                setState(() {
                  isDependent = value!;
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (firstNameController.text.isNotEmpty &&
                lastNameController.text.isNotEmpty &&
                dateOfBirth != null) {
              final newMember = FamilyMember(
                memberId: DateTime.now().millisecondsSinceEpoch.toString(),
                residentId: '',  // This will be set when the resident is created
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                relationship: relationship,
                dateOfBirth: dateOfBirth!,
                isDependent: isDependent,
              );
              widget.onAdd(newMember);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }
}