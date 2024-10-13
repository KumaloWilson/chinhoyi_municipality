import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/utils/api_response.dart';
import '../models/property_maintenance.dart';

class MaintenanceServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<APIResponse<String?>> addMaintenance(PropertyMaintenance maintenance) async {
    try {
      await _firestore.collection('property_maintenance').add(maintenance.toJson());
      return APIResponse(success: true, message: 'Maintenance record added');
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }
}
