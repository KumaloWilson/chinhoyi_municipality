import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:municipality/core/constants/color_constants.dart';
import 'package:municipality/models/resident.dart';
import 'package:municipality/models/property.dart';
import 'package:municipality/models/family_member.dart';
import 'package:municipality/models/emergency_contact.dart';
import 'package:municipality/repository/helpers/add_resident_helper.dart';
import 'package:municipality/widgets/custom_button/general_button.dart';
import 'package:municipality/widgets/custom_dropdown.dart';
import 'package:municipality/widgets/text_fields/custom_text_field.dart';

class AddResidentScreen extends StatefulWidget {
  const AddResidentScreen({super.key});

  @override
  _AddResidentScreenState createState() => _AddResidentScreenState();
}

class _AddResidentScreenState extends State<AddResidentScreen> {
  int _currentStep = 0;
  List<String> suburbs = [
    'Brundish',
    'Cherima',
    'Chikonohono',
    'Chitambo',
    'Chikangwe',
    'Cold Stream',
    'Gadzema',
    'Gunhill',
    'Hunyani',
    'Katanda',
    'Madzibaba',
    'Mapako',
    'Mhangura',
    'Mpata',
    'Ngezi',
    'Nyamhunga',
    'Orange Grove',
    'Pfura',
    'Ruvimbo',
    'Rusununguko',
    'White City',
    'Zvimba',
    'Chinhoyi Township',
  ];


  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _alternativePhoneController = TextEditingController();
  final TextEditingController _employerController = TextEditingController();
  final TextEditingController _monthlyIncomeController = TextEditingController();
  final TextEditingController _emergencyContactNameController = TextEditingController();
  final TextEditingController _emergencyContactPhoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Dropdown and date picker values
  String _selectedGender = 'Male';
  String _selectedSuburb = 'Cold Stream';
  String _employmentStatus = 'Employed';
  String _nationality = 'Local';
  final String _accountStatus = 'Active';
  DateTime? _dateOfBirth;
  final bool _isDisabled = false;
  bool _isSeniorCitizen = false;

  // Property related controllers
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _propertySizeController = TextEditingController();
  String _propertyType = 'Residential';
  String _ownershipType = 'Owned';

  // Family members
  final List<FamilyMember> _familyMembers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text('Add Resident', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
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
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 3) {
              setState(() {
                _currentStep += 1;
              });
            } else {
              final property = Property(
                propertyId: DateTime.now().millisecondsSinceEpoch.toString(),
                houseNumber: _houseNumberController.text,
                suburb: _selectedSuburb,
                propertyType: _propertyType,
                propertySize: double.parse(_propertySizeController.text),
                ownershipType: _ownershipType,
                currentOwnerId: '',  // This will be set when the resident is created
                previousOwnerIds: [],
                status: 'Occupied',
                addedOn: DateTime.now(),
                notes: '',
              );

              // Create EmergencyContact object
              final emergencyContact = EmergencyContact(
                emergencyContactName: _emergencyContactNameController.text,
                emergencyContactPhone: _emergencyContactPhoneController.text,
                relationshipToResident: 'Not specified',  // You might want to add this field to the form
              );

              // Create Resident object
              final resident = Resident(
                accountNumber: '',
                residentId: DateTime.now().millisecondsSinceEpoch.toString(),
                firstName: _firstNameController.text,
                lastName: _lastNameController.text,
                nationalId: _nationalIdController.text,
                gender: _selectedGender,
                dateOfBirth: _dateOfBirth!,
                email: _emailController.text,
                phoneNumber: _phoneController.text,
                alternativePhone: _alternativePhoneController.text,
                property: property,
                familyMembers: _familyMembers,
                employmentStatus: _employmentStatus,
                employer: _employerController.text,
                monthlyIncome: double.parse(_monthlyIncomeController.text),
                emergencyContact: emergencyContact,
                nationality: _nationality,
                isDisabled: _isDisabled,
                isSeniorCitizen: _isSeniorCitizen,
                notes: _notesController.text,
                accountStatus: _accountStatus,
                lastUpdated: DateTime.now(),
              );

                AddResidentHelper.validateAndSubmitForm(resident: resident);
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep -= 1;
              });
            }
          },
          steps: [
            _buildPersonalInfoStep(),
            _buildPropertyInfoStep(),
            _buildFamilyMembersStep(),
            _buildAdditionalInfoStep(),
          ],
        ),
      ),
    );
  }

  Step _buildPersonalInfoStep() {
    return Step(
      title: const Text('Personal Information'),
      content: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _firstNameController,
                  labelText: 'First Name',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: _lastNameController,
                  labelText: 'Last Name',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _nationalIdController,
                  labelText: 'National ID',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomDropDown(
                  items: const ['Male', 'Female'],
                  selectedValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                  isEnabled: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    _dateOfBirth = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    setState(() {});
                  },
                  child: CustomTextField(
                    labelText: 'Date of Birth',
                    enabled: false,
                    controller: TextEditingController(
                      text: _dateOfBirth != null
                          ? DateFormat('yyyy-MM-dd').format(_dateOfBirth!)
                          : '',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _phoneController,
                  labelText: 'Phone Number',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: _alternativePhoneController,
                  labelText: 'Alternative Phone',
                ),
              ),
            ],
          ),
        ],
      ),
      isActive: _currentStep >= 0,
    );
  }

  Step _buildPropertyInfoStep() {
    return Step(
      title: const Text('Property Information'),
      content: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _houseNumberController,
                  labelText: 'House Number',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomDropDown(
                  items: suburbs,
                  selectedValue: _selectedSuburb,
                  onChanged: (value) {
                    setState(() {
                      _selectedSuburb = value!;
                    });
                  },
                  isEnabled: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomDropDown(
                  items: const ['Residential', 'Commercial', 'Municipal'],
                  selectedValue: _propertyType,
                  onChanged: (value) {
                    setState(() {
                      _propertyType = value!;
                    });
                  },
                  isEnabled: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: _propertySizeController,
                  labelText: 'Property Size (sq m)',
                  keyBoardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomDropDown(
            items: const ['Owned', 'Rented', 'Municipal Lease'],
            selectedValue: _ownershipType,
            onChanged: (value) {
              setState(() {
                _ownershipType = value!;
              });
            },
            isEnabled: true,
          ),
        ],
      ),
      isActive: _currentStep >= 1,
    );
  }

  Step _buildFamilyMembersStep() {
    return Step(
      title: const Text('Family Members'),
      content: Column(
        children: [
          ..._familyMembers.map((member) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              title: Text('${member.firstName} ${member.lastName}'),
              subtitle: Text(member.relationship),
              tileColor: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          )),
          const SizedBox(height: 16),
          GeneralButton(
            onTap: () {
              _showAddFamilyMemberDialog();
            },
            width: 250,
            boxBorder: Border.all(color: Pallete.primaryColor, width: 2),
            height: 40,
            borderRadius: 10,
            btnColor: Colors.white,
            child: Text('Add Family Member', style: TextStyle(color: Pallete.primaryColor),),
          ),
        ],
      ),
      isActive: _currentStep >= 2,
    );
  }

  Step _buildAdditionalInfoStep() {
    return Step(
      title: const Text('Additional Information'),
      content: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomDropDown(
                  items: const ['Employed', 'Unemployed', 'Retired', 'Student'],
                  selectedValue: _employmentStatus,
                  onChanged: (value) {
                    setState(() {
                      _employmentStatus = value!;
                    });
                  },
                  isEnabled: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: _employerController,
                  labelText: 'Employer',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _monthlyIncomeController,
                  labelText: 'Monthly Income',
                  keyBoardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomDropDown(
                  items: const ['Local', 'Foreign'],
                  selectedValue: _nationality,
                  onChanged: (value) {
                    setState(() {
                      _nationality = value!;
                    });
                  },
                  isEnabled: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _emergencyContactNameController,
                  labelText: 'Emergency Contact Name',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: _emergencyContactPhoneController,
                  labelText: 'Emergency Contact Phone',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _notesController,
            labelText: 'Additional Notes',
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Is Senior Citizen'),
            value: _isSeniorCitizen,
            onChanged: (value) {
              setState(() {
                _isSeniorCitizen = value!;
              });
            },
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
      isActive: _currentStep >= 3,
    );
  }

  void _showAddFamilyMemberDialog() {
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    String relationship = 'Spouse';
    DateTime? dateOfBirth;
    bool isDependent = false;

    showDialog(
      context: context,
      builder: (context) {
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
                    relationship = value!;
                  },
                  isEnabled: true,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    dateOfBirth = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
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
                  setState(() {
                    _familyMembers.add(FamilyMember(
                      memberId: DateTime.now().millisecondsSinceEpoch.toString(),
                      residentId: '',  // This will be set when the resident is created
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      relationship: relationship,
                      dateOfBirth: dateOfBirth!,
                      isDependent: isDependent,
                    ));
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}