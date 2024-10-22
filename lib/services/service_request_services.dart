import 'package:cloud_firestore/cloud_firestore.dart';
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
  static Future<APIResponse<String>> updateResidentProfile({
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

  // Method to fetch resident profile
  static Stream<APIResponse<List<ServiceRequest>>> streamResidentServiceRequests({
    required String residentId,
  }) {
    try {
      final snapshots = _firestore
          .collection('service_requests')
          .where('residentId', isEqualTo: residentId)
          .snapshots();

      return snapshots.map((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          // Map each document to a ServiceRequest and collect them into a list
          final serviceRequests = querySnapshot.docs
              .map((doc) => ServiceRequest.fromJson(doc.data()))
              .toList();

          return APIResponse<List<ServiceRequest>>(
            success: true,
            data: serviceRequests,
            message: 'Resident service requests fetched successfully',
          );
        } else {
          return APIResponse<List<ServiceRequest>>(
            success: false,
            message: 'No service requests found for the specified residentId',
          );
        }
      });
    } catch (e) {
      return Stream.value(APIResponse<List<ServiceRequest>>(
        success: false,
        message: e.toString(),
      ));
    }
  }


  static Stream<APIResponse<List<ServiceRequest>>> streamAllServiceRequests() {
    try {
      final snapshots = _firestore.collection('service_requests').snapshots();

      return snapshots.map((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          // Map each document to a ServiceRequest and collect them into a list
          final serviceRequests = querySnapshot.docs
              .map((doc) => ServiceRequest.fromJson(doc.data()))
              .toList();

          return APIResponse<List<ServiceRequest>>(
            success: true,
            data: serviceRequests,
            message: 'Service requests fetched successfully',
          );
        } else {
          return APIResponse<List<ServiceRequest>>(
            success: false,
            message: 'No service requests found',
          );
        }
      });
    } catch (e) {
      return Stream.value(APIResponse<List<ServiceRequest>>(
        success: false,
        message: e.toString(),
      ));
    }
  }

}
