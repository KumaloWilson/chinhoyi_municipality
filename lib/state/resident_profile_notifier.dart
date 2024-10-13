import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:municipality/models/resident.dart';
import 'package:municipality/services/resident_services.dart';
import '../../../core/utils/api_response.dart';

class ResidentProfileNotifier extends StateNotifier<AsyncValue<Resident>> {
  final String profileEmail;

  ResidentProfileNotifier({required this.profileEmail})
      : super(const AsyncValue.loading()) {
    fetchUser(profileEmail: profileEmail);
  }

  Future<void> fetchUser({required String profileEmail}) async {
    // Set loading state
    state = const AsyncValue.loading();

    try {
      // Fetch user profile from the service
      final APIResponse<Resident> response = await ResidentServices.fetchResidentProfile(profileEmail: profileEmail);

      if (response.success) {
        state = AsyncValue.data(response.data!);
      } else {
        state = AsyncValue.error(
            response.message ?? 'Failed to fetch user', StackTrace.current
        );
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error('An unexpected error occurred: $e', stackTrace);
    }
  }

  // Update the state with a new profile
  void updateProfile(Resident updatedProfile) {
    state = AsyncValue.data(updatedProfile);
  }
}
