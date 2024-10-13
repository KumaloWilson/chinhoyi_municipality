import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/utils/api_response.dart';
import '../models/payment_history.dart';

class BillingServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to add a payment entry to a resident's profile
  static Future<APIResponse<String>> addPayment({
    required String residentId,
    required PaymentHistory payment,
  }) async {
    try {
      // Add payment to the resident's payment history
      await _firestore.collection('residents').doc(residentId).collection('payments').add(payment.toJson());

      return APIResponse(success: true, message: 'Payment added successfully');
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }

  // Method to fetch payment history for a resident
  static Future<APIResponse<List<PaymentHistory>>> fetchPaymentHistory({
    required String residentId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('residents')
          .doc(residentId)
          .collection('payments')
          .get();

      final paymentHistory = querySnapshot.docs
          .map((doc) => PaymentHistory.fromJson(doc.data()))
          .toList();

      return APIResponse(success: true, data: paymentHistory, message: 'Payment history fetched successfully');
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }
}
