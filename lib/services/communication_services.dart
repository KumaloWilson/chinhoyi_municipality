import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/utils/api_response.dart';
import '../models/service_request.dart';

class CommunicationServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to submit a complaint
  static Future<APIResponse<String>> submitComplaint({
    required String residentId,
    required ServiceRequest serviceRequest,
  }) async {
    try {
      await _firestore
          .collection('residents')
          .doc(residentId)
          .collection('serviceRequests')
          .add(serviceRequest.toJson());

      return APIResponse(success: true, message: 'Complaint submitted successfully');
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }

  // Method to fetch all service requests by a resident
  static Future<APIResponse<List<ServiceRequest>>> fetchServiceRequests({
    required String residentId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('residents')
          .doc(residentId)
          .collection('serviceRequests')
          .get();

      final serviceRequests = querySnapshot.docs
          .map((doc) => ServiceRequest.fromJson(doc.data()))
          .toList();

      return APIResponse(success: true, data: serviceRequests, message: 'Service requests fetched successfully');
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }
}
