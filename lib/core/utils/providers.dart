import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:municipality/models/payment_history.dart';
import 'package:municipality/models/resident.dart';
import 'package:municipality/models/service_request.dart';
import 'package:municipality/models/staff_profile.dart';
import 'package:municipality/state/payments_history_notifier.dart';
import 'package:municipality/state/resident_notifier.dart';
import 'package:municipality/state/resident_profile_notifier.dart';
import 'package:municipality/state/revenue_notifier.dart';
import 'package:municipality/state/service_requests_notifier.dart';
import 'package:municipality/state/staff_profile_notifier.dart';
import '../../global/global.dart';
import '../../models/announcement.dart';
import '../../services/communication_services.dart';
import '../../services/service_request_services.dart';
import '../../state/authentication_provider.dart';
import '../../state/staff_notifier.dart';
import 'api_response.dart';

class ProviderUtils {
  static final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
    return UserNotifier();
  });

  static final staffProvider = StateNotifierProvider<StaffNotifier, AsyncValue<List<StaffProfile>>>(
      (ref) {
    return StaffNotifier();
  });


  static final residentsProvider = StateNotifierProvider<ResidentsNotifier, AsyncValue<List<Resident>>>(
      (ref) {
    return ResidentsNotifier();
  });


  static final revenuesProvider = StateNotifierProvider<RevenueNotifier, AsyncValue<List<PaymentHistory>>>(
          (ref) {
        return RevenueNotifier();
      });



  static final paymentHistoryProvider = StateNotifierProvider.family<PaymentsHistoryNotifier,
      AsyncValue<List<PaymentHistory>>, String>((ref, profileEmail) {
    return PaymentsHistoryNotifier(profileEmail: profileEmail);
  });


  static final serviceRequestsProvider = StateNotifierProvider<ServiceRequestsNotifier, AsyncValue<List<ServiceRequest>>>(
  (ref) {
  return ServiceRequestsNotifier();
  });



  static final staffProfileProvider = StateNotifierProvider.family<StaffProfileNotifier,
      AsyncValue<StaffProfile>, String>((ref, profileEmail) {
    return StaffProfileNotifier(profileEmail: profileEmail);
  });

  static final residentProfileProvider = StateNotifierProvider.family<ResidentProfileNotifier,
      AsyncValue<Resident>, String>((ref, profileEmail) {
    return ResidentProfileNotifier(profileEmail: profileEmail);
  });


  static final userRoleProvider = StateProvider<UserRole?>((ref) {
    return null;
  });

  static final announcementsProvider = StreamProvider<APIResponse<List<Announcement>>>((ref) {
    return AnnouncementServices.streamAnnouncements();
  });
}
