import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:municipality/core/utils/providers.dart';
import 'package:municipality/models/resident.dart';
import 'package:municipality/services/resident_services.dart';
import 'package:municipality/widgets/dialogs/password_dialog.dart';

import '../../widgets/circular_loader/circular_loader.dart';
import '../../widgets/dialogs/update_dialog.dart';
import '../../widgets/snackbar/custom_snackbar.dart';

class AddResidentHelper {
  static Future<void> validateAndSubmitForm({
    required Resident resident,
    required WidgetRef ref,
    String? fileName,
  }) async {
    // Validate Email
    if (!GetUtils.isEmail(resident.email)) {
      CustomSnackBar.showErrorSnackbar(message: 'Please input a valid email.');
      return;
    }

    // Validate Phone Number
    if (resident.phoneNumber.isEmpty ||
        !GetUtils.isPhoneNumber(resident.phoneNumber)) {
      CustomSnackBar.showErrorSnackbar(
          message: 'Please input a valid phone number.');
      return;
    }

    // Validate Name
    if (resident.firstName.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Name is required.');
      return;
    }

    if (resident.lastName.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Name is required.');
      return;
    }

    if (resident.dateOfBirth.toString().isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Date of Birth is required.');
      return;
    }

    if (resident.nationalId.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'National ID is required.');
      return;
    }

    if (!GetUtils.isEmail(resident.email)) {
      CustomSnackBar.showErrorSnackbar(message: 'Please input a valid email.');
      return;
    }

    // Validate Phone Number
    if (resident.phoneNumber.isEmpty ||
        !GetUtils.isPhoneNumber(resident.phoneNumber)) {
      CustomSnackBar.showErrorSnackbar(
          message: 'Please input a valid phone number.');
      return;
    }

    // Validate Name
    if (resident.lastName.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: ' First name is required.');
      return;
    }


    // Validate Name
    if (resident.lastName.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: ' First name is required.');
      return;
    }

    if (resident.property.houseNumber.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'House Number is required.');
      return;
    }

    if (resident.property.suburb.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Suburb is required.');
      return;
    }

    if (resident.emergencyContact!.emergencyContactName.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Emergency contact is required');
      return;
    }


    if (resident.emergencyContact!.emergencyContactPhone.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Emergency contact phone is required');
      return;
    }

    // Validate Previous Employer
    if (resident.employmentStatus.isEmpty) {
      CustomSnackBar.showErrorSnackbar(
          message: 'Previous Employer is required.');
      return;
    }

    if (resident.employer.isEmpty) {
      CustomSnackBar.showErrorSnackbar(
          message: 'Previous Employer is required.');
      return;
    }


    if (resident.employmentStatus.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Address is required.');
      return;
    }


    if (resident.employer.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Address is required.');
      return;
    }


    if (resident.monthlyIncome.toString().isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Address is required.');
      return;
    }


    // Show loader while creating user
    Get.dialog(
      const CustomLoader(
        message: 'Creating user',
      ),
      barrierDismissible: false,
    );


    await ResidentServices.addResidentToFirebase(residentProfile: resident).then((response) {
      if (!response.success) {
        if (!Get.isSnackbarOpen) Get.back();
        CustomSnackBar.showErrorSnackbar(message: response.message ?? 'Something went wrong');
      } else {
        ref.refresh(ProviderUtils.residentsProvider);
        CustomSnackBar.showSuccessSnackbar(
            message: 'Resident created successfully');
        CustomSnackBar.showSuccessSnackbar(
            message: 'Resident created successfully');
        if (Get.isDialogOpen!) Get.back(closeOverlays: true);
      }
    });
  }

  static Future<DateTime?> pickDate(
      {required BuildContext context,
        required DateTime initialDate,
        DateTime? firstDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );

    return picked;
  }

  static Future<TimeOfDay?> pickTime({
    required BuildContext context,
  }) async {
    final picked = await showTimePicker(
        context: context, initialTime: const TimeOfDay(hour: 6, minute: 00));

    return picked;
  }

  static Future<void> updateField({
    required String title,
    required String initialValue,
    required ValueChanged<String> onUpdate,
  }) async {
    await Get.dialog(
      UpdateDialog(
        title: title,
        initialValue: initialValue,
        onUpdate: onUpdate,
      ),
      barrierDismissible: true,
    );
  }


  static Future<void> updatePasswordField({
    required String title,
    required PasswordUpdateCallback onUpdate,
  }) async {
    await Get.dialog(
      UpdatePasswordDialog(
        title: title,
        newPassword: onUpdate,
      ),
      barrierDismissible: true,
    );
  }
}
