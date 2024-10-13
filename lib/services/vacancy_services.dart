import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/utils/api_response.dart';
import '../models/vacancy.dart';

class VacancyServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<APIResponse<String?>> addVacancy(Vacancy vacancy) async {
    try {
      await _firestore.collection('property_vacancies').add(vacancy.toJson());
      return APIResponse(success: true, message: 'Vacancy added successfully');
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }

  static Future<APIResponse<String?>> allocateProperty(String vacancyId, String residentId) async {
    try {
      final querySnapshot = await _firestore.collection('property_vacancies').where('vacancyId', isEqualTo: vacancyId).get();
      if (querySnapshot.docs.isEmpty) {
        return APIResponse(success: false, message: 'Vacancy not found');
      }
      final docId = querySnapshot.docs.first.id;
      await _firestore.collection('property_vacancies').doc(docId).update({
        'allocatedTo': residentId,
        'status': 'Allocated',
      });
      return APIResponse(success: true, message: 'Property allocated successfully');
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }
}
