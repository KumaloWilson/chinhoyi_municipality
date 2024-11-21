import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:municipality/services/staff_services.dart';
import '../../core/utils/logs.dart';
import '../../core/utils/routes.dart';
import '../../core/utils/shared_pref.dart';
import '../../global/global.dart';
import '../../services/auth_service.dart';
import '../../widgets/circular_loader/circular_loader.dart';
import '../../widgets/snackbar/custom_snackbar.dart';

class AuthHelpers {

  static Future<void> handleEmailVerification({required User user}) async {
    if (!user.emailVerified) {
      Get.offAllNamed(
        RoutesHelper.emailVerificationScreen,
        arguments: user
      );
    } else {
      Get.offAllNamed(RoutesHelper.initialScreen);
    }
  }

  static Future<void> checkEmailVerification({required User currentUser}) async {
    await currentUser.reload().then((value){
      final user = FirebaseAuth.instance.currentUser;

      if (user?.emailVerified ?? false) {
        Get.offAllNamed(RoutesHelper.initialScreen);
      }
    });

  }

  static setTimerForAutoRedirect() {
    const Duration timerPeriod = Duration(seconds: 5);
    Timer.periodic(
      timerPeriod,
          (timer) async {
        await FirebaseAuth.instance.currentUser?.reload().then((value){
          final user = FirebaseAuth.instance.currentUser;

          if (user?.emailVerified ?? false) {

            timer.cancel();

            Get.offAllNamed(RoutesHelper.successfulVerificationScreen);
          }
        });

      },
    );
  }

  static Future<String?> getCurrentUserToken() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? token = await user.getIdToken();
        return token;
      } else {
        return null;
      }
    } catch (e) {
      DevLogs.logError('Error getting user token: $e');
      return null;
    }
  }

  static void customerLoginValidateAndSubmitForm({
    required String password,
    required String email,
    required UserRole userRole
  }) async {
    if (password.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Password is required.');
      return;
    }

    if (password.length < 8) {
      CustomSnackBar.showErrorSnackbar(message: 'Password too Short');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      CustomSnackBar.showErrorSnackbar(message: 'Please input a valid email');
      return;
    }

    Get.dialog(
      const CustomLoader(
        message: 'Logging in',
      ),
      barrierDismissible: false,
    );

    await AuthServices.residentLogin(
      emailAddress: email.trim(),
      password: password.trim(),
      currentRole: userRole
    ).then((response) {
      if (!response.success && response.message != 'No user found for that email.') {
        if (!Get.isSnackbarOpen) Get.back();
        CustomSnackBar.showErrorSnackbar(message: response.message ?? 'Something went wrong');
      } else if (!response.success && response.message == 'No user found for that email.') {
        if (!Get.isSnackbarOpen) Get.back();
        CustomSnackBar.showErrorSnackbar(message: response.message ?? 'Something went wrong',);
      } else {
        if (Get.isDialogOpen!) Get.back();

        CustomSnackBar.showSuccessSnackbar(message: 'Login Successful',);
        Get.offAllNamed(RoutesHelper.initialScreen);
      }
    });
  }

  static void customerSignUpValidateAndSubmitForm({
    required String nationalID,
    required String email,
    required String password,
    required String confirmPassword,
    required String houseNumber,
    required String suburb,
  }) async {
    // Validate National ID
    if (nationalID.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'National ID is required.');
      return;
    }

    // Validate Email
    if (!GetUtils.isEmail(email)) {
      CustomSnackBar.showErrorSnackbar(message: 'Please input a valid email');
      return;
    }

    // Validate House Number
    if (houseNumber.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'House number is required.');
      return;
    }

    // Validate Suburb
    if (suburb.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Suburb is required.');
      return;
    }

    // Validate Password
    if (password.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Password is required.');
      return;
    }

    if (password.length < 8) {
      CustomSnackBar.showErrorSnackbar(message: 'Password must be at least 8 characters.');
      return;
    }

    // Validate Confirm Password
    if (confirmPassword != password) {
      CustomSnackBar.showErrorSnackbar(message: 'Passwords do not match.');
      return;
    }

    Get.dialog(
      const CustomLoader(
        message: 'Creating account...',
      ),
      barrierDismissible: false,
    );

    await AuthServices.residentSignUp(
      emailAddress: email.trim(),
      password: password.trim(),
      nationalId: nationalID.trim(),
      houseNumber: houseNumber.trim(),
      suburb: suburb.trim(),
    ).then((response) {
      if (!response.success) {
        if (!Get.isSnackbarOpen) Get.back();
        CustomSnackBar.showErrorSnackbar(message: response.message ?? 'Something went wrong');
      } else {
        if (Get.isDialogOpen!) Get.back();
        CustomSnackBar.showSuccessSnackbar(message: 'Account created successfully');
        Get.offAllNamed(RoutesHelper.initialScreen);
      }
    });
  }


  static void staffValidateAndSubmitLoginForm({
    required String password,
    required String email,
  }) async {
    if (password.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Password is required.');
      return;
    }

    if (password.length < 8) {
      CustomSnackBar.showErrorSnackbar(message: 'Password too Short');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      CustomSnackBar.showErrorSnackbar(message: 'Please input a valid email');
      return;
    }

    Get.dialog(
      const CustomLoader(
        message: 'Logging in',
      ),
      barrierDismissible: false,
    );

    await AuthServices.staffLogin(
      emailAddress: email.trim(),
      password: password.trim(),
    ).then((response) {
      if (!response.success && response.message != 'No user found for that email.') {
        if (!Get.isSnackbarOpen) Get.back();
        CustomSnackBar.showErrorSnackbar(message: response.message ?? 'Something went wrong');
      } else if (!response.success && response.message == 'No user found for that email.') {
        if (!Get.isSnackbarOpen) Get.back();
        CustomSnackBar.showErrorSnackbar(message: response.message ?? 'Something went wrong',);
      } else {
        if (Get.isDialogOpen!) Get.back();

        // Show success snackbar

        CustomSnackBar.showSuccessSnackbar(message: 'Login Successful',);
        Get.offAllNamed(RoutesHelper.initialScreen);
      }
    });
  }


  static void staffValidateAndSubmitSignUpForm({
    required String password,
    required String confirmPassword,
    required String email,
    required String phoneNumber
  }) async {
    if (password.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Password is required.');
      return;
    }

    if (phoneNumber.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Phone Number is required.');
      return;
    }

    if (confirmPassword != password) {
      CustomSnackBar.showErrorSnackbar(message: 'Passwords don`t match');
      return;
    }

    if (password.length < 8) {
      CustomSnackBar.showErrorSnackbar(message: 'Password too Short');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      CustomSnackBar.showErrorSnackbar(message: 'Please input a valid email');
      return;
    }


    Get.dialog(
      const CustomLoader(
        message: 'Creating User Account',
      ),
      barrierDismissible: false,
    );

    await AuthServices.staffSignUp(
      emailAddress: email.trim(),
      password: password.trim(),
      phoneNumber: phoneNumber
    ).then((response) {
      if (!response.success && response.message != 'No user found for that email.') {
        if (!Get.isSnackbarOpen) Get.back();
        CustomSnackBar.showErrorSnackbar(message: response.message ?? 'Something went wrong');
      } else if (!response.success && response.message == 'No user found for that email.') {
        if (!Get.isSnackbarOpen) Get.back();
        CustomSnackBar.showErrorSnackbar(message: response.message ?? 'Something went wrong',);
      } else {
        if (Get.isDialogOpen!) Get.back();

        // Show success snackbar

        CustomSnackBar.showSuccessSnackbar(message: 'Login Successful',);
        Get.offAllNamed(RoutesHelper.initialScreen);
      }
    });
  }


  static Future<UserRole?> getStaffRole(User user) async {
    UserRole? userRole = await CacheUtils.getUserRoleFromCache();

    if (userRole == null) {
      await StaffServices.fetchUserProfile(profileEmail:  user.email!).then((response) async{

        DevLogs.logInfo("USER ROLE = ${response.data!.role}");

        if (response.data != null) {
          await CacheUtils.saveUserRoleToCache(response.data!.role);

          userRole = await CacheUtils.getUserRoleFromCache();
        }
      });
    }

    return userRole ?? UserRole.customer;
  }
}


