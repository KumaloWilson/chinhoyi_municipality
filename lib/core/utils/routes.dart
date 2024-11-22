import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:municipality/models/resident.dart';
import 'package:municipality/models/service_request.dart';
import 'package:municipality/views/auth/customer_login_page.dart';
import 'package:municipality/views/auth/signup.dart';
import 'package:municipality/views/auth/staff_login_page.dart';
import 'package:municipality/views/auth/staff_sign_up.dart';
import 'package:municipality/views/sidebarx_feat/pages/resident_pages/payment_screen.dart';
import 'package:municipality/views/sidebarx_feat/pages/resident_pages/payment_successful.dart';
import 'package:municipality/views/sidebarx_feat/pages/resident_pages/service_request_details.dart';
import 'package:municipality/views/sidebarx_feat/pages/staff_pages/add_announcement_screen.dart';
import 'package:municipality/views/sidebarx_feat/pages/staff_pages/add_user.dart';
import 'package:municipality/views/splash/splash.dart';
import '../../views/auth/email_verification.dart';
import '../../views/auth/email_verification_success.dart';
import '../../views/auth/forgot_password.dart';
import '../../views/auth/resend_reset_email_screen.dart';
import '../../views/sidebarx_feat/pages/resident_pages/add_service_request.dart';
import '../../views/sidebarx_feat/pages/staff_pages/add_resident_screen.dart';
import '../../views/sidebarx_feat/pages/staff_pages/resident_details_screen.dart';

class RoutesHelper {
  static String welcomeScreen = '/welcome';
  static String initialScreen = "/";
  static String splashScreen = "/splash";
  static String emailVerificationScreen = "/verifyEmail";
  static String successfulVerificationScreen = "/verified";
  static String staffLoginScreen = '/staffLogin';
  static String staffSignUpScreen = '/staffSignUp';
  static String residentLoginScreen = '/residentLogin';
  static String residentSignUpScreen = '/residentSignUp';
  static String forgotPasswordScreen = '/forgotPassword';
  static String resendVerificationEmailScreen = '/resendVerificationEmail';
  static String adminHomeScreen = '/adminHome';
  static String userHomeScreen = '/userHome';
  static String adminStaffStatsScreen = '/adminStaffStats';
  static String adminShiftStatsScreen = '/adminShiftStats';
  static String addStaffScreen = '/addUser';
  static String viewUserScreen = '/viewUsers';
  static String userProfileScreen = '/profile';
  static String residentDetailsScreen = '/residentDetails';
  static String serviceRequestDetailsScreen = '/serviceRequestDetails';
  static String updateShiftScreen = '/updateShift';
  static String addResidentsScreen = '/addResidents';
  static String addServiceRequestScreen = '/addServiceRequest';
  static String addAnnouncementScreen = '/addAnnouncement';
  static String paymentScreen = '/makePayment';
  static String successfulPaymentScreen = '/paymentSuccessful';

  static List<GetPage> routes = [
    GetPage(
        name: emailVerificationScreen,
        page: () {
          final user = Get.arguments as User;

          return EmailVerificationScreen(user: user);
        }),
    GetPage(
        name: resendVerificationEmailScreen,
        page: () {
          final String email = Get.arguments as String;

          return ResendResetEmailScreen(email: email);
        }),
    GetPage(name: staffLoginScreen, page: () => const StaffLoginScreen()),
    GetPage(name: staffSignUpScreen, page: () => const StaffSignUpScreen()),
    GetPage(name: residentLoginScreen, page: () => const CustomerLoginScreen()),
    GetPage(name: residentSignUpScreen, page: () => const CustomerSignUpScreen()),
    GetPage(
        name: successfulVerificationScreen,
        page: () => const AccountVerificationSuccessful()),
    GetPage(name: forgotPasswordScreen, page: () => ForgotPasswordScreen()),
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: addStaffScreen, page: () => const AddStaffScreen()),
    GetPage(name: paymentScreen, page: () => const PaymentScreen()),
    GetPage(name: successfulPaymentScreen, page: () => const PaymentSuccessful()),
    GetPage(
        name: residentDetailsScreen,
        page: () {
          final Resident resident = Get.arguments as Resident;

          return ResidentDetailsScreen(resident: resident);
        }),

    GetPage(
        name: serviceRequestDetailsScreen,
        page: () {

          final args = Get.arguments as List;

          final ServiceRequest request = args[0] as ServiceRequest;
          final WidgetRef ref = args[1] as WidgetRef;

          return ServiceRequestDetailsScreen(serviceRequest: request, ref: ref,);
        }),

    GetPage(
        name: addServiceRequestScreen,
        page: () {
          final args = Get.arguments as List;

          final Resident resident = args[0] as Resident;
          final WidgetRef ref = args[1] as WidgetRef;
          return AddServiceRequestScreen(resident: resident, ref: ref,);
        }
        ),

    GetPage(
        name: addAnnouncementScreen,
        page: () {
          final WidgetRef ref = Get.arguments as WidgetRef;

          return AddAnnouncementScreen(ref: ref);
        }),


    GetPage(
        name: addResidentsScreen,
        page: () {
          final WidgetRef ref = Get.arguments as WidgetRef;

          return AddResidentScreen(ref: ref);
        }),
  ];
}
