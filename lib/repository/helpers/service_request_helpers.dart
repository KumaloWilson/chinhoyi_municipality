import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:municipality/models/service_request.dart';
import 'package:municipality/services/service_request_services.dart';
import '../../core/utils/providers.dart';
import '../../widgets/circular_loader/circular_loader.dart';
import '../../widgets/snackbar/custom_snackbar.dart';

class ServiceRequestHelper {
  static Future<void> validateAndSubmitForm({
    required ServiceRequest serviceRequest,
    required WidgetRef ref,
    String? fileName,
  }) async {
    if (serviceRequest.category.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Please input a request category');
      return;
    }

    if (serviceRequest.description.isEmpty) {
      CustomSnackBar.showErrorSnackbar(
          message: 'Please input description');
      return;
    }

    // Validate Name
    if (serviceRequest.residentAddress.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Resident is required');
      return;
    }


    // Show loader while creating user
    Get.dialog(
      const CustomLoader(
        message: 'Submitting Request',
      ),
      barrierDismissible: false,
    );


    await ServiceRequestServices.addServiceRequestToFirebase(serviceRequest: serviceRequest,)
        .then((response) {
      if (!response.success) {
        if (!Get.isSnackbarOpen) Get.back();
        CustomSnackBar.showErrorSnackbar(
            message: response.message ?? 'Something went wrong');
      } else {
        ref.refresh(ProviderUtils.serviceRequestsProvider);
        CustomSnackBar.showSuccessSnackbar(
            message: 'Request Submitted successfully');
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


  static Future<void> validateAndUpdateRequest({
    required String requestID,
    required ServiceRequest request,
    required WidgetRef ref
  }) async {
    // Show loader while creating user
    Get.dialog(
      const CustomLoader(
        message: 'Updating request',
      ),
      barrierDismissible: false,
    );

    await ServiceRequestServices.updateServiceRequestProfile(requestID: requestID, updatedRequest: request)
        .then((response) {
      if (!response.success) {
        if (!Get.isSnackbarOpen) Get.back();
        CustomSnackBar.showErrorSnackbar(
            message: response.message ?? 'Something went wrong');
      } else {
        ref.refresh(ProviderUtils.serviceRequestsProvider);
        CustomSnackBar.showSuccessSnackbar(
            message: 'Request updated successfully');
        if (Get.isDialogOpen!) Get.back(closeOverlays: true);
      }
    });
    
  }
}
