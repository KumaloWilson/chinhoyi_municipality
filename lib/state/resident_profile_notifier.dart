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
    state = const AsyncValue.loading();
    try {
      final APIResponse<Resident> response =
      await ResidentServices.fetchResidentProfile(profileEmail: profileEmail);

      if (response.success) {
        state = AsyncValue.data(response.data!);
      } else {
        state = AsyncValue.error(
          response.message ?? 'Failed to fetch user',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error('An unexpected error occurred: $e', stackTrace);
    }
  }

  Future<void> updateResidentProfile(Resident updatedProfile) async {
    // Optimistic Update: Update the state first to reflect changes in the UI
    state = AsyncValue.data(updatedProfile);

    try {
      // Call the service to update the profile in Firestore
      final response = await ResidentServices.updateResidentProfile(
        email: profileEmail,
        updatedProfile: updatedProfile,
      );

      if (!response.success) {
        // If the update fails, revert to the old state
        state = AsyncValue.error('${response.message}', StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error('Failed to update profile: $e', stackTrace);
    }
  }
}
