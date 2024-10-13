import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:municipality/models/resident.dart';
import 'package:municipality/services/resident_services.dart';
class ResidentsNotifier extends StateNotifier<AsyncValue<List<Resident>>> {
  ResidentsNotifier() : super(const AsyncValue.loading()) {
    fetchUsers();
  }

  // Fetch users using a one-time get request
  void fetchUsers() async {
    try {
      // Fetch all users from Firestore
      final usersResponse = await ResidentServices.getAllResidents();
      if (usersResponse.success) {
        state = AsyncValue.data(usersResponse.data!);
      } else {
        state = AsyncValue.error(usersResponse.message ?? 'Something went wrong', StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error('An unexpected error occurred: $e', stackTrace);
    }
  }
}
