import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:municipality/core/utils/logs.dart';
import 'package:municipality/services/resident_services.dart';
import 'package:municipality/services/staff_services.dart';

import '../core/utils/api_response.dart';
import '../core/utils/routes.dart';
import '../global/global.dart';
import '../repository/helpers/auth_helpers.dart';

class AuthServices {
  // Sign up with email and password, with email verification
  static Future<APIResponse<User?>> residentSignUp({
    required String emailAddress,
    required String password,
    required String nationalId,
    required String houseNumber,
    required String suburb,
  }) async {
    try {
      // First check if a resident profile exists with the given details
      final residentResponse = await ResidentServices.checkResidentProfileForSignUp(
        nationalId: nationalId,
        houseNumber: houseNumber,
        suburb: suburb,
        email: emailAddress,
      );

      if (residentResponse.data != null) {
        try {
          // Create Firebase auth account
          final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: residentResponse.data!.email,
              password: password
          );

          if (userCredential.user != null) {
            // Update user profile
            await userCredential.user!.updateProfile(
              displayName: "${residentResponse.data!.firstName} ${residentResponse.data!.lastName}",
            );

            // Send email verification
            await userCredential.user!.sendEmailVerification();

            return APIResponse(
                success: true,
                data: userCredential.user,
                message: 'Account created successfully'
            );
          }
          return APIResponse(
              success: false,
              message: 'Failed to create account'
          );
        } on FirebaseAuthException catch (signUpError) {
          switch (signUpError.code) {
            case 'email-already-in-use':
              return APIResponse(
                  success: false, message: 'Email address already in use');
            case 'weak-password':
              return APIResponse(
                  success: false, message: 'Password is too weak');
            default:
              return APIResponse(
                  success: false,
                  message: 'An error occurred while creating your account');
          }
        }
      } else {
        return APIResponse(
            success: false,
            message: 'No resident profile found with the provided details. Please verify your information.'
        );
      }
    } catch (e) {
      return APIResponse(
          success: false,
          message: 'An error occurred. Please try again.'
      );
    }
  }

  static Future<APIResponse<User?>> staffSignUp({
    required String emailAddress,
    required String password,
    required String phoneNumber
  }) async {
    try {

      final profileResponse = await StaffServices.checkUserProfileForSignUp(profileEmail: emailAddress, phoneNumber: phoneNumber);

      if (profileResponse.data != null) {
        DevLogs.logError('Staff Found');
        try {
          final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: profileResponse.data!.email,
              password: password
          );

          if (userCredential.user != null) {
            await userCredential.user!.updateProfile(
              displayName: "${profileResponse.data!.firstName} ${profileResponse.data!.firstName}",
            );

            await userCredential.user!.sendEmailVerification();
          }
          return APIResponse(
              success: true,
              data: userCredential.user,
              message: 'User profile found and login successful'
          );
        } on FirebaseAuthException catch (signUpError) {
          // Handle signup errors
          switch (signUpError.code) {
            case 'email-already-in-use':
              return APIResponse(
                  success: false, message: 'Email Address already in use');
            case 'weak-password':
              return APIResponse(
                  success: false, message: 'Your password is too weak');
            default:
              return APIResponse(
                  success: false,
                  message: 'Unknown error, please contact Support');
          }
        }
      } else {
        return APIResponse(
            success: false, message: 'No user found for that email.');
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return APIResponse(
              success: false, message: 'Email Address already in use');
        case 'weak-password':
          return APIResponse(
              success: false, message: 'Your password is too weak');
        default:
          return APIResponse(
              success: false, message: 'Unknown error, please contact Support');
      }
    } catch (e) {
      return APIResponse(
          success: false, message: 'An error occurred. Please try again.');
    }
  }



  // Login with email and password

  static Future<APIResponse<User?>> staffLogin({
    required String emailAddress,
    required String password,
  }) async {
    try {
      final UserCredential loginResponse = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailAddress, password: password);

      if (loginResponse.user != null) {
        final userRole = await AuthHelpers.getStaffRole(loginResponse.user!);

        if (userRole == null) {
          await signOut();
          return APIResponse(
            success: false,
            message: 'Invalid UserRole, Please switch your your role and try again',
          );
        } else {
          return APIResponse(
            success: true,
            data: loginResponse.user,
            message: 'Login successful',
          );
        }
      } else {
        return APIResponse(
          success: false,
          message: 'Failed to login. Please try again.',
        );
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return APIResponse(
              success: false, message: 'Invalid email address format.');

        case 'user-not-found':
          return APIResponse(
              success: false, message: 'Email address not found');

        case 'invalid-credential':
          return APIResponse(
              success: false, message: 'Invalid email or password');

        case 'wrong-password':
          return APIResponse(
              success: false, message: 'Invalid password');
        case 'user-disabled':
          return APIResponse(
              success: false, message: 'User account is disabled.');
        default:
          return APIResponse(
              success: false,
              message: e.message ?? 'An unknown error occurred.');
      }
    } catch (e) {
      return APIResponse(
          success: false, message: 'An error occurred. Please try again.');
    }
  }



  static Future<APIResponse<User?>> residentLogin({
    required String emailAddress,
    required String password,
    required UserRole currentRole,
  }) async {
    try {
      final UserCredential loginResponse = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);

      if (loginResponse.user != null) {
        final userAccountResponse = await ResidentServices.fetchResidentProfile(profileEmail: emailAddress);

        if (userAccountResponse.data == null) {
          await signOut();
          return APIResponse(
            success: false,
            message: 'Invalid UserRole, Please switch your your role and tyr again',
          );
        } else {
          return APIResponse(
            success: true,
            data: loginResponse.user,
            message: 'Login successful',
          );
        }
      } else {
        return APIResponse(
          success: false,
          message: 'Failed to login. Please try again.',
        );
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return APIResponse(
            success: false,
            message: 'Invalid email address format.',
          );

        case 'user-not-found':
          return APIResponse(
            success: false,
            message: 'Email address not found',
          );

        case 'invalid-credential':
          return APIResponse(
            success: false,
            message: 'Invalid email or password',
          );

        case 'wrong-password':
          return APIResponse(
            success: false,
            message: 'Invalid password',
          );
        case 'user-disabled':
          return APIResponse(
            success: false,
            message: 'User account is disabled.',
          );
        default:
          return APIResponse(
            success: false,
            message: e.message ?? 'An unknown error occurred.',
          );
      }
    } catch (e) {
      return APIResponse(
        success: false,
        message: 'An error occurred. Please try again.',
      );
    }
  }


  // Sign out user
  static Future<APIResponse<void>> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return APIResponse(success: true, message: 'Sign out successful');
    } catch (e) {
      return APIResponse(
          success: false, message: 'Failed to sign out. Please try again.');
    }
  }

  // Send password reset email
  static Future<APIResponse<void>> sendPasswordResetEmail(
      {required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return APIResponse(success: true, message: 'Password reset email sent.');
    } catch (e) {
      return APIResponse(
          success: false,
          message: 'Failed to send password reset email. Please try again.');
    }
  }



  static Future<APIResponse<void>> requestVerificationCode({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
  }) async {
    try {
      // Check if the phone number exists in Firestore
      final usersRef = FirebaseFirestore.instance.collection('staff');
      final querySnapshot =
          await usersRef.where('phone_number', isEqualTo: phoneNumber).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Phone number exists, proceed with sending OTP
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            try {
              // Automatically sign in the user if the verification is completed
              await FirebaseAuth.instance.signInWithCredential(credential);
              Get.offAllNamed(RoutesHelper.initialScreen);
            } catch (e) {
              // Handle any sign-in errors here
              Get.snackbar(
                'Sign In Error',
                'Failed to sign in automatically. Please try again.',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          verificationFailed: (FirebaseAuthException error) {
            Get.snackbar(
              'Verification Failed',
              'Verification failed: ${error.message}',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          codeSent: (String verificationId, int? forceResendingToken) {
            onCodeSent(
                verificationId); // Call the provided callback with verificationId
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            // Handle auto retrieval timeout if needed
          },
        );
        return APIResponse(success: true, message: 'Verification code sent.');
      } else {
        // Phone number does not exist, show error message
        Get.snackbar(
          'Phone Number Not Registered',
          'Phone number not registered. Please sign up first.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return APIResponse(
            success: false, message: 'Phone number not registered.');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return APIResponse(
          success: false, message: 'An error occurred: ${e.toString()}');
    }

    // void _handlePhoneNumberSubmit(String phoneNumber) async {
    //   final response = await AuthServices.requestVerificationCode(
    //     phoneNumber: phoneNumber,
    //     onCodeSent: (verificationId) {
    //       Get.to(() => OTPScreen(verificationId: verificationId));
    //     },
    //   );
    //
    //   if (!response.success) {
    //     // Handle the API response error if needed
    //     print(response.message);
    //   }
    // }
  }
}

// Custom AuthException class for better error handling
class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => message;
}
