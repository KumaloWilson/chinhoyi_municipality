import 'package:extended_phone_number_input/phone_number_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../models/staff_profile.dart';
import '../../../../repository/helpers/add_staff_helper.dart';
import '../../../../widgets/custom_button/general_button.dart';
import '../../../../widgets/custom_dropdown.dart';
import '../../../../widgets/text_fields/custom_phone_input.dart';
import '../../../../widgets/text_fields/custom_text_field.dart';

class AddStaffScreen extends ConsumerStatefulWidget {
  const AddStaffScreen({super.key});

  @override
  ConsumerState<AddStaffScreen> createState() => _AdminAddStaffState();
}

class _AdminAddStaffState extends ConsumerState<AddStaffScreen> {
  String selectedRole = 'User';
  PhoneNumberInputController? phoneNumberController;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController employmentStatusController = TextEditingController();
  TextEditingController employmentPostController = TextEditingController();
  TextEditingController qualificationsController = TextEditingController();
  List<String> qualifications = [];
  TextEditingController dobController = TextEditingController();
  TextEditingController dateOfHireController = TextEditingController();
  List<String> roles = ['User', 'Admin',];
  DateTime? dob;
  DateTime? dateOfHire;
  dynamic pickedImage;

  @override
  void initState() {
    super.initState();
    phoneNumberController = PhoneNumberInputController(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Add Staff',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 200),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: firstNameController,
                    labelText: 'First Name',
                    prefixIcon: const Icon(Icons.person, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextField(
                    controller: lastNameController,
                    labelText: 'Last Name',
                    prefixIcon: const Icon(Icons.person, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Date of Birth and Date of Hire in one row
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      dob = await AddUserHelper.pickDate(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900));
                      setState(() {});
                    },
                    child: CustomTextField(
                      labelText: 'Date of Birth',
                      prefixIcon: const Icon(Icons.cake, color: Colors.grey),
                      enabled: false,
                      controller: TextEditingController(
                        text:
                        dob != null ? DateFormat('yyyy-MM-dd').format(dob!) : '',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      dateOfHire = await AddUserHelper.pickDate(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000));
                      setState(() {});
                    },
                    child: CustomTextField(
                      labelText: 'Date of Hire',
                      prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                      enabled: false,
                      controller: TextEditingController(
                        text: dateOfHire != null
                            ? DateFormat('yyyy-MM-dd').format(dateOfHire!)
                            : '',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Email and Phone number in one row
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: emailController,
                    labelText: 'Email Address',
                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomPhoneInput(
                    labelText: 'Phone Number',
                    pickFromContactsIcon: const Icon(Icons.perm_contact_cal),
                    controller: phoneNumberController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Department and Role dropdown in one row
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: departmentController,
                    labelText: 'Department',
                    prefixIcon:
                    const Icon(Icons.business_center, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomDropDown(
                    prefixIcon: Icons.work,
                    items: roles,
                    selectedValue: selectedRole,
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value!;
                      });
                    },
                    isEnabled: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Employment Status
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: employmentStatusController,
                    labelText: 'Employment Status',
                    prefixIcon: const Icon(Icons.work, color: Colors.grey),
                  ),
                ),

                Expanded(
                  child: CustomTextField(
                    controller: employmentPostController,
                    labelText: 'Employment Post',
                    prefixIcon: const Icon(Icons.work, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            const Divider(),
            Column(
              children: [
                const Text(
                  'Qualifications',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: qualifications
                      .map((qualification) => Chip(
                    label: Text(
                      qualification,
                      style: const TextStyle(
                          fontSize: 10, color: Colors.white),
                    ),
                    backgroundColor:
                    Pallete.primaryColor.withOpacity(0.7),
                    deleteIcon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onDeleted: () {
                      setState(() {
                        qualifications.remove(qualification);
                      });
                    },
                  ))
                      .toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  labelText: 'Qualifications',
                  controller: qualificationsController,
                  prefixIcon:
                  const Icon(Icons.school, color: Colors.grey),
                  onSubmitted: (value) {
                    setState(() {
                      if (value != null && value.isNotEmpty) {
                        qualifications.add(value);
                        qualificationsController.clear();
                      }
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 20),

            Center(
              child: GeneralButton(
                onTap: () async {
                  AddUserHelper.validateAndSubmitForm(
                    ref: ref,
                    userProfile: StaffProfile(
                      staffId: '',
                      firstName: firstNameController.text.trim(),
                      lastName: lastNameController.text.trim(),
                      email: emailController.text.trim(),
                      phoneNumber: phoneNumberController!.fullPhoneNumber.trim(),
                      role: selectedRole,
                      post: employmentPostController.text,
                      department: departmentController.text.trim(),
                      dateOfBirth: dob!,
                      dateOfHire: dateOfHire!,
                      employmentStatus:
                      employmentStatusController.text.trim(),
                      qualifications: qualifications,
                      employmentHistory: [],
                    ),
                  );
                },
                borderRadius: 10,
                btnColor: Pallete.primaryColor,
                width: 300,
                child: const Text(
                  "Add Staff",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
