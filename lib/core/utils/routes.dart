import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:municipality/models/resident.dart';
import 'package:municipality/views/auth/customer_login_page.dart';
import 'package:municipality/views/auth/staff_login_page.dart';
import 'package:municipality/views/splash/splash.dart';
import '../../views/auth/email_verification.dart';
import '../../views/auth/email_verification_success.dart';
import '../../views/auth/forgot_password.dart';
import '../../views/auth/resend_reset_email_screen.dart';
import '../../views/sidebarx_feat/pages/staff_pages/add_resident_screen.dart';
import '../../views/sidebarx_feat/pages/staff_pages/resident_details_screen.dart';

class RoutesHelper {
  static String welcomeScreen = '/welcome';
  static String initialScreen = "/";
  static String splashScreen = "/splash";
  static String emailVerificationScreen = "/verifyEmail";
  static String successfulVerificationScreen = "/verified";
  static String staffLoginScreen = '/staffLogin';
  static String residentLoginScreen = '/residentLogin';
  static String signUpScreen = '/signUp';
  static String forgotPasswordScreen = '/forgotPassword';
  static String resendVerificationEmailScreen = '/resendVerificationEmail';
  static String adminHomeScreen = '/adminHome';
  static String userHomeScreen = '/userHome';
  static String adminStaffStatsScreen = '/adminStaffStats';
  static String adminShiftStatsScreen = '/adminShiftStats';
  static String adminAddUserScreen = '/addUser';
  static String viewUserScreen = '/viewUsers';
  static String userProfileScreen = '/profile';
  static String residentDetailsScreen = '/residentDetails';
  static String updateShiftScreen = '/updateShift';
  static String addResidentsScreen = '/addResidents';
  static String addUserFeedbackScreen = '/addFeedback';

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
    GetPage(name: residentLoginScreen, page: () => const CustomerLoginScreen()),
    GetPage(
        name: successfulVerificationScreen,
        page: () => const AccountVerificationSuccessful()),
    GetPage(name: forgotPasswordScreen, page: () => ForgotPasswordScreen()),
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: addResidentsScreen, page: () => const AddResidentScreen()),
    GetPage(
        name: residentDetailsScreen,
        page: () {
          final Resident resident = Get.arguments as Resident;

          return ResidentDetailsScreen(resident: resident);
        }),
  ];
}
