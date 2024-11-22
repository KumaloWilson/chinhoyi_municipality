import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:municipality/core/utils/logs.dart';
import '../core/utils/api_response.dart';
import '../models/payment_history.dart';

class BillingServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch payment history for a specific resident
  static Future<APIResponse<List<PaymentHistory>>> fetchResidentPaymentHistory({
    required String profileEmail,
  }) async {
    try {
      // Fetch payments from Firestore where the email matches
      final querySnapshot = await _firestore
          .collection('payments')
          .where('email', isEqualTo: profileEmail)
          .orderBy('timestamp', descending: true) // Sort by most recent payments
          .get();

      // Map the documents to the PaymentHistory model
      final paymentHistory = querySnapshot.docs
          .map((doc) => PaymentHistory.fromJson(doc.data()))
          .toList();

      // Return the data wrapped in a success response
      return APIResponse(
        success: true,
        data: paymentHistory,
        message: 'Payment history fetched successfully',
      );
    } catch (e) {
      // Handle exceptions and return a failure response
      return APIResponse(
        success: false,
        message: 'Failed to fetch payment history: ${e.toString()}',
      );
    }
  }

  // Fetch all payments for administrative purposes
  static Future<APIResponse<List<PaymentHistory>>> fetchPaymentHistory() async {
    try {
      DevLogs.logError('FETCH DATA');
      // Fetch all payments from Firestore
      final querySnapshot = await _firestore
          .collection('payments')
          .orderBy('timestamp', descending: true) // Sort by most recent payments
          .get();

      // Map the documents to the PaymentHistory model
      final paymentHistory = querySnapshot.docs
          .map((doc) => PaymentHistory.fromJson(doc.data()))
          .toList();

      DevLogs.logError(paymentHistory.toString());
      // Return the data wrapped in a success response
      return APIResponse(
        success: true,
        data: paymentHistory,
        message: 'Payment history fetched successfully',
      );
    } catch (e) {
      DevLogs.logError(e.toString());
      // Handle exceptions and return a failure response
      return APIResponse(
        success: false,
        message: 'Failed to fetch payment history: ${e.toString()}',
      );
    }
  }
}
