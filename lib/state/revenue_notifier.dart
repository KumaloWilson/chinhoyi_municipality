import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:municipality/models/payment_history.dart';

import '../services/billing_services.dart';

class RevenueNotifier extends StateNotifier<AsyncValue<List<PaymentHistory>>> {
  RevenueNotifier() : super(const AsyncValue.loading()) {
    fetchPaymentsHistory();
  }

  // Fetch all payment histories
  void fetchPaymentsHistory() async {
    try {
      // Fetch all payment histories
      final payments = await BillingServices.fetchPaymentHistory();
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
