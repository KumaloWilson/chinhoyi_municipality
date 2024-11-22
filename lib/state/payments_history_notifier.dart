import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:municipality/models/payment_history.dart';
import 'package:municipality/services/billing_services.dart';

class PaymentsHistoryNotifier extends StateNotifier<AsyncValue<List<PaymentHistory>>> {
  final String profileEmail;

  PaymentsHistoryNotifier({required this.profileEmail})
      : super(const AsyncValue.loading()) {
    fetchResidentPayments(email: profileEmail);
  }


  // Fetch payment history for a specific resident by email
  void fetchResidentPayments({required String email}) async {
    try {
      // Fetch payments for a resident
      final payments = await BillingServices.fetchResidentPaymentHistory(profileEmail: email);
      if (payments.success) {
        state = AsyncValue.data(payments.data!);
      } else {
        state = AsyncValue.error(
          payments.message ?? 'Something went wrong',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error('An unexpected error occurred: $e', stackTrace);
    }
  }
}
