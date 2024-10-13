import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:municipality/models/staff_profile.dart';
import '../../services/staff_services.dart';
import '../../widgets/circular_loader/circular_loader.dart';
import '../../widgets/snackbar/custom_snackbar.dart';

class AddUserHelper {
  static Future<void> validateAndSubmitForm({
    required StaffProfile userProfile,
  }) async {
    // Validate all required fields before proceeding
    if (!_validateUserProfile(userProfile)) return;

    // Show loader while creating the user
    Get.dialog(
      const CustomLoader(message: 'Creating user'),
      barrierDismissible: false,
    );


    // Submit the profile to the database
    await StaffServices.addStuffToFirebase(userProfile: userProfile)
        .then((response) {
      if (!response.success) {
        if (Get.isDialogOpen!) Get.back();
        CustomSnackBar.showErrorSnackbar(
            message: response.message ?? 'Something went wrong.');
      } else {
        if (Get.isDialogOpen!) Get.back(closeOverlays: true);
        CustomSnackBar.showSuccessSnackbar(
            message: 'User account created successfully.');
      }
    });
  }

  /// Helper function to validate the user profile fields
  static bool _validateUserProfile(StaffProfile userProfile) {
    // Validate Email
    if (!GetUtils.isEmail(userProfile.email!)) {
      CustomSnackBar.showErrorSnackbar(message: 'Please input a valid email.');
      return false;
    }

    // Validate Phone Number
    if (userProfile.phoneNumber!.isEmpty ||
        !GetUtils.isPhoneNumber(userProfile.phoneNumber!)) {
      CustomSnackBar.showErrorSnackbar(
          message: 'Please input a valid phone number.');
      return false;
    }

    // Validate First Name
    if (userProfile.firstName.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'First name is required.');
      return false;
    }

    // Validate Last Name
    if (userProfile.lastName!.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Last name is required.');
      return false;
    }


    // Validate Role
    if (userProfile.role!.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Role is required.');
      return false;
    }

    return true;
  }

  /// Date picker helper
  static Future<DateTime?> pickDate({
    required BuildContext context,
    required DateTime initialDate,
    DateTime? firstDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    return picked;
  }

  /// Time picker helper
  static Future<TimeOfDay?> pickTime({
    required BuildContext context,
  }) async {
    final picked = await showTimePicker(
        context: context, initialTime: const TimeOfDay(hour: 6, minute: 00));
    return picked;
  }

  /// Week Picker for selecting workdays
  static Future<String> showWeekPicker(BuildContext context) async {
    final selectedDays = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        List<String> selectedDays = [];
        List<String> weekDays = [
          'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
        ];

        return AlertDialog(
          title: const Text('Select Preferred Work Days'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: weekDays.map((day) {
                  return CheckboxListTile(
                    title: Text(day),
                    value: selectedDays.contains(day),
                    onChanged: (bool? checked) {
                      setState(() {
                        if (checked == true) {
                          selectedDays.add(day);
                        } else {
                          selectedDays.remove(day);
                        }
                      });
                    },
                  );
                }).toList(),
              );
            },
          ),
          actions: <Widget>[
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(selectedDays),
            ),
          ],
        );
      },
    );

    return selectedDays?.join(', ') ?? '';
  }

  /// Add specialisation dynamically
  static List<String> addSpecialisation({
    required String value,
    required List<String> specialisations,
  }) {
    if (value.isNotEmpty && !specialisations.contains(value)) {
      specialisations.add(value);
    }
    return specialisations;
  }

  /// Validate and Update Profile
  static Future<void> validateAndUpdateProfile({
    required StaffProfile userProfile,
  }) async {
    if (!_validateUserProfile(userProfile)) return;

    Get.dialog(
      const CustomLoader(message: 'Updating profile'),
      barrierDismissible: false,
    );

    await StaffServices.updateUserProfile(
      email: userProfile.email!,
      updatedProfile: userProfile,
    ).then((response) {
      if (!response.success) {
        if (!Get.isDialogOpen!) Get.back();
        CustomSnackBar.showErrorSnackbar(
            message: response.message ?? 'Something went wrong.');
      } else {
        if (Get.isDialogOpen!) Get.back(closeOverlays: true);
        CustomSnackBar.showSuccessSnackbar(
            message: 'User profile updated successfully.');
      }
    });
  }
}
