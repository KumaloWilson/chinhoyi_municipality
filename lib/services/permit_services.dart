import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/utils/api_response.dart';
import '../models/building_permit.dart';

class PermitServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<APIResponse<String?>> applyForPermit(
      BuildingPermit permit) async {
    try {
      await _firestore.collection('building_permits').add(permit.toJson());
      return APIResponse(success: true, message: 'Permit applied successfully');
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }

  static Future<APIResponse<String?>> updatePermitStatus(String permitId,
      String status) async {
    try {
      final querySnapshot = await _firestore.collection('building_permits')
          .where('permitId', isEqualTo: permitId)
          .get();
      if (querySnapshot.docs.isEmpty) {
        return APIResponse(success: false, message: 'Permit not found');
      }
      final docId = querySnapshot.docs.first.id;
      await _firestore.collection('building_permits').doc(docId).update(
          {'permitStatus': status});
      return APIResponse(
          success: true, message: 'Permit status updated successfully');
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }
}