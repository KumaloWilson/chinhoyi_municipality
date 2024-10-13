import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/utils/api_response.dart';
import '../models/property.dart';

class PropertyServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new property
  static Future<APIResponse<String?>> addProperty(Property property) async {
    try {
      await _firestore.collection('properties').add(property.toJson());
      return APIResponse(success: true, message: 'Property added successfully');
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }

  // Update an existing property
  static Future<APIResponse<String?>> updateProperty(String propertyId, Property updatedProperty) async {
    try {
      final querySnapshot = await _firestore.collection('properties').where('propertyId', isEqualTo: propertyId).get();
      if (querySnapshot.docs.isEmpty) {
        return APIResponse(success: false, message: 'Property not found');
      }
      final docId = querySnapshot.docs.first.id;
      await _firestore.collection('properties').doc(docId).update(updatedProperty.toJson());
      return APIResponse(success: true, message: 'Property updated successfully');
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }

  // Get all properties
  static Stream<List<Property>> streamAllProperties() {
    return _firestore.collection('properties').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Property.fromJson(doc.data())).toList();
    });
  }
}
