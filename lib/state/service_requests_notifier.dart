import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:municipality/models/service_request.dart';
import 'package:municipality/services/service_request_services.dart';

class ServiceRequestsNotifier extends StateNotifier<AsyncValue<List<ServiceRequest>>> {
  ServiceRequestsNotifier() : super(const AsyncValue.loading()) {
    fetchServiceRequests();
  }

  // Fetch service requests using a one-time get request
  void fetchServiceRequests() async {
    try {
      // Fetch all service requests from Firestore
      final serviceRequestsResponse = await ServiceRequestServices.getAllServiceRequests();
      if (serviceRequestsResponse.success) {
        state = AsyncValue.data(serviceRequestsResponse.data!);
      } else {
        state = AsyncValue.error(serviceRequestsResponse.message ?? 'Something went wrong', StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error('An unexpected error occurred: $e', stackTrace);
    }
  }
}
