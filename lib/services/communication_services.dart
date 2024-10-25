import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:municipality/core/utils/providers.dart';
import '../core/utils/api_response.dart';
import '../core/utils/logs.dart';
import '../models/announcement.dart';

class AnnouncementServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<APIResponse<String?>> addAnnouncement({
    required Announcement announcement,
    required WidgetRef ref,
  }) async {
    try {
      final data = announcement.toJson();
      await _firestore.collection('announcements').add(data);

      ref.refresh(ProviderUtils.announcementsProvider);
      return APIResponse(success: true, message: 'Announcement added successfully');
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }

  static Stream<APIResponse<List<Announcement>>> streamAnnouncements() {
    try {
      final snapshots = _firestore
          .collection('announcements')
          .orderBy('date', descending: true)
          .snapshots();

      return snapshots.map((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          final announcements = querySnapshot.docs
              .map((doc) => Announcement.fromJson(doc.data()))
              .toList();

          return APIResponse<List<Announcement>>(
            success: true,
            data: announcements,
            message: 'Announcements fetched successfully',
          );
        } else {
          return APIResponse<List<Announcement>>(
            success: false,
            message: 'No announcements found',
          );
        }
      });
    } catch (e) {
      return Stream.value(APIResponse<List<Announcement>>(
        success: false,
        message: e.toString(),
      ));
    }
  }

  static Future<APIResponse<String>> updateAnnouncement({
    required String announcementId,
    required Announcement updatedAnnouncement,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('announcements')
          .where('id', isEqualTo: announcementId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return APIResponse(
            success: false,
            message: 'No announcement found with the specified ID'
        );
      }

      final docId = querySnapshot.docs.first.id;
      final updatedData = updatedAnnouncement.toJson();
      await _firestore.collection('announcements').doc(docId).update(updatedData);

      return APIResponse(success: true, message: 'Announcement updated successfully');
    } catch (e) {
      return APIResponse(success: false, message: 'Update failed: $e');
    }
  }


  static Future<APIResponse<String>> uploadFileToFirebase({
    required File file,
    required String fileName,
    required User user,
  }) async {
    try {
      final storage = FirebaseStorage.instance;
      final String path = 'documents/${user.uid}/$fileName';

      // Create a reference to the file location in Firebase Storage
      final Reference storageRef = storage.ref().child(path);

      // Check if the file already exists by attempting to get its download URL
      try {
        final existingUrl = await storageRef.getDownloadURL();
        if (existingUrl.isNotEmpty) {
          return APIResponse(
            message: 'File already exists',
            success: true,
            data: existingUrl,
          );
        }
      } catch (e) {
        // If the file doesn't exist, Firebase throws an error, and we'll catch it and proceed with upload.
        DevLogs.logInfo('File does not exist. Proceeding to upload.');
      }

      // Proceed to upload the file to Firebase Storage
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});

      // Retrieve the public URL of the uploaded file
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return APIResponse(
        message: 'Document Upload Successful',
        success: true,
        data: downloadUrl,
      );
    } on FirebaseException catch (e) {
      // Handle Firebase-specific exceptions
      DevLogs.logError('Firebase Storage Exception: ${e.message}, Code: ${e.code}');
      return APIResponse(
        message: 'Upload failed: ${e.message}',
        success: false,
        data: null,
      );
    } catch (e) {
      // Handle any other errors
      DevLogs.logError('Error uploading file: $e');
      return APIResponse(
        message: 'Document Upload Failed',
        success: false,
        data: null,
      );
    }
  }

}