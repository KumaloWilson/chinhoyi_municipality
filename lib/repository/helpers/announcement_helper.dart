import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../models/announcement.dart';
import '../../services/communication_services.dart';
import '../../widgets/circular_loader/circular_loader.dart';
import '../../widgets/snackbar/custom_snackbar.dart';

class AddAnnouncementHelper {
  static Future validateAndSubmitAnnouncement({
    required Announcement announcement,
    required WidgetRef ref,
    required String? fileName,
    required File? file,
    required User user
  }) async {
    if (announcement.title.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Please input a title');
      return;
    }

    if (announcement.description.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Please input description');
      return;
    }

    if (announcement.category.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Category is required');
      return;
    }

    Get.dialog(
      const CustomLoader(
        message: 'Submitting Announcement',
      ),
      barrierDismissible: false,
    );

    Announcement updatedAnnouncement = announcement;

    if(file != null){
      final uploadResponse = await AnnouncementServices.uploadFileToFirebase(
          file: file,
          fileName: fileName!,
          user: user
      );

      if (!uploadResponse.success) {
        Get.back();
        CustomSnackBar.showErrorSnackbar(message: 'Error :${uploadResponse.message}');
        return;
      }else{
        updatedAnnouncement = announcement.copyWith(
          imageUrl: uploadResponse.data
        );
      }
    }


    await AnnouncementServices.addAnnouncement(
      announcement: updatedAnnouncement,
      ref: ref,
    ).then((response) {
      if (!response.success) {
        if (!Get.isSnackbarOpen) Get.back();
        CustomSnackBar.showErrorSnackbar(
            message: response.message ?? 'Something went wrong'
        );
      } else {
        CustomSnackBar.showSuccessSnackbar(
            message: 'Announcement submitted successfully'
        );
        if (Get.isDialogOpen!) Get.back(closeOverlays: true);
      }
    });
  }

  static Future validateAndUpdateAnnouncement({
    required Announcement announcement,
  }) async {
    Get.dialog(
      const CustomLoader(
        message: 'Updating announcement',
      ),
      barrierDismissible: false,
    );

    await AnnouncementServices.updateAnnouncement(
      announcementId: announcement.id,
      updatedAnnouncement: announcement,
    ).then((response) {
      Get.back();
      if (!response.success) {
        CustomSnackBar.showErrorSnackbar(
            message: response.message ?? 'Update failed'
        );
      } else {
        CustomSnackBar.showSuccessSnackbar(
            message: 'Announcement updated successfully'
        );
      }
    });
  }
}