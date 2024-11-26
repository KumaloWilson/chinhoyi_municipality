import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:municipality/models/staff_profile.dart';
import '../../../core/utils/api_response.dart';
import '../services/staff_services.dart';

class StaffProfileNotifier extends StateNotifier<AsyncValue<StaffProfile>> {
  final String profileEmail;

  StaffProfileNotifier({required this.profileEmail})
      : super(const AsyncValue.loading()) {
    fetchUser(profileEmail: profileEmail);
  }

  Future<void> fetchUser({required String profileEmail}) async {
    // Set loading state
    state = const AsyncValue.loading();

    try {
      // Fetch user profile from the service
      final APIResponse<StaffProfile> response = await StaffServices.fetchUserProfile(profileEmail: profileEmail);

      if (response.success) {
        state = AsyncValue.data(response.data!);
      } else {
        state = AsyncValue.error(
            response.message ?? 'Failed to fetch user', StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error('An unexpected error occurred: $e', stackTrace);
    }
  }

  // Method to update the staff profile
  Future<void> updateUserProfile(StaffProfile updatedProfile) async {
    try {
      // Ensure the state is loaded before updating
      final currentProfile = state.value;
      if (currentProfile == null) {
        state = AsyncValue.error(
            'Cannot update profile: Current profile is not loaded',
            StackTrace.current);
        return;
      }

      // Call the service to update the profile
      final response = await StaffServices.updateUserProfile(
        email: currentProfile.email,
        updatedProfile: updatedProfile,
      );

      if (response.success) {
        // Update the local state with the updated profile
        state = AsyncValue.data(updatedProfile);
      } else {
        // Handle the error response
        state = AsyncValue.error(
            response.message ?? 'Failed to update user', StackTrace.current);
      }
    } catch (e, stackTrace) {
      // Handle unexpected exceptions
      state = AsyncValue.error('An unexpected error occurred: $e', stackTrace);
    }
  }

  // Update the state with a new profile directly (for local updates)
  void updateProfileLocally(StaffProfile updatedProfile) {
    state = AsyncValue.data(updatedProfile);
  }
}
