import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:municipality/core/utils/providers.dart';
import 'package:municipality/models/service_request.dart';
import '../../../core/utils/api_response.dart';
import '../core/utils/logs.dart';

class ServiceRequestServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to add a resident profile to Firebase Firestore
  static Future<APIResponse<String?>> addServiceRequestToFirebase({
    required ServiceRequest serviceRequest,
  }) async {
    try {
      
      // Add new resident
      final data = serviceRequest.toJson();
      await _firestore.collection('service_requests').add(data);

      return APIResponse(success: true, message: 'Request added successfully');
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }

  // Method to update an existing resident profile
  static Future<APIResponse<String>> updateServiceRequestProfile({
    required String requestID,
    required ServiceRequest updatedRequest,
  }) async {
    try {
      // Ensure the resident exists by checking their nationalId
      final querySnapshot = await _firestore
          .collection('service_requests')
          .where('requestId', isEqualTo: requestID)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return APIResponse(
            success: false, message: 'No Requests found with the specified Request ID');
      }

      final docId = querySnapshot.docs.first.id;

      final updatedData = updatedRequest.toJson();
      await _firestore.collection('service_requests').doc(docId).update(updatedData);


      return APIResponse(success: true, message: 'Service Request updated successfully');
    } catch (e) {
      DevLogs.logError('ResidentProfile Update Error: $e');
      return APIResponse(success: false, message: 'Profile update failed: $e');
    }
  }


  static Future<APIResponse<List<ServiceRequest>>> getAllServiceRequests() async {
    try {
      // Query Firestore to get all users
      final querySnapshot = await _firestore.collection('service_requests').get();

      final requestsList = querySnapshot.docs
          .map((doc) => ServiceRequest.fromJson(doc.data()))
          .toList();

      return APIResponse(
        success: true,
        data: requestsList,
        message: 'Users fetched successfully',
      );
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }

}
