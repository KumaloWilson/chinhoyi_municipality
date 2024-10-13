import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/utils/api_response.dart';
import '../core/utils/logs.dart';
import '../models/resident.dart';

class ResidentServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to add a resident profile to Firebase Firestore
  static Future<APIResponse<String?>> addResidentToFirebase({
    required Resident residentProfile,
  }) async {
    try {
      // Check if a resident with the same National ID already exists
      final querySnapshot = await _firestore
          .collection('residents')
          .where('nationalId', isEqualTo: residentProfile.nationalId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return APIResponse(
            success: false, message: 'Resident with the same National ID already exists');
      }

      // Add new resident
      final residentData = residentProfile.toJson();
      await _firestore.collection('residents').add(residentData);

      return APIResponse(success: true, message: 'Resident added successfully');
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }

  // Method to update an existing resident profile
  static Future<APIResponse<String>> updateResidentProfile({
    required String nationalId,
    required Resident updatedProfile,
  }) async {
    try {
      // Ensure the resident exists by checking their nationalId
      final querySnapshot = await _firestore
          .collection('residents')
          .where('nationalId', isEqualTo: nationalId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return APIResponse(
            success: false, message: 'No resident found with the specified National ID');
      }

      final docId = querySnapshot.docs.first.id;

      final updatedData = updatedProfile.toJson();
      await _firestore.collection('residents').doc(docId).update(updatedData);

      return APIResponse(success: true, message: 'Resident profile updated successfully');
    } catch (e) {
      DevLogs.logError('ResidentProfile Update Error: $e');
      return APIResponse(success: false, message: 'Profile update failed: $e');
    }
  }

  // Method to fetch resident profile
  static Future<APIResponse<Resident>> fetchResidentProfile({
    required String profileEmail,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('residents')
          .where('email', isEqualTo: profileEmail)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final residentData = querySnapshot.docs.first.data();
        final residentProfile = Resident.fromJson(residentData);

        return APIResponse(
          success: true,
          data: residentProfile,
          message: 'Resident profile fetched successfully',
        );
      } else {
        return APIResponse(
          success: false,
          message: 'No resident found with the specified National ID',
        );
      }
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }

  static Future<APIResponse<List<Resident>>> getAllResidents() async {
    try {
      // Query Firestore to get all users
      final querySnapshot = await _firestore.collection('residents').get();

      // Map the query results to UserProfile objects
      final userList = querySnapshot.docs
          .map((doc) => Resident.fromJson(doc.data()))
          .toList();

      return APIResponse(
        success: true,
        data: userList,
        message: 'Users fetched successfully',
      );
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }
}
