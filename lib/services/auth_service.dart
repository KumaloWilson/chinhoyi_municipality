import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:municipality/core/utils/logs.dart';
import 'package:municipality/services/resident_services.dart';
import 'package:municipality/services/staff_services.dart';

import '../core/utils/api_response.dart';
import '../core/utils/routes.dart';

class AuthServices {
  // Sign up with email and password, with email verification
  static Future<APIResponse<String?>> signUpWithVerification({
    String? profilePic,
    required String emailAddress,
    required String password,
    required String userName,
  }) async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      await userCredential.user!.sendEmailVerification();
      await userCredential.user!.updateDisplayName(userName);

      final String? userToken = await userCredential.user!.getIdToken();

      return APIResponse(
          success: true,
          data: userToken,
          message: 'Signup successful. Please verify your email.');
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
        return APIResponse(
            success: true,
            data: loginResponse.user,
            message: 'Login successful');
      } else {
        return APIResponse(
            success: false, message: 'Failed to login. Please try again.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        // Check if the user profile exists
        final userDoc = await StaffServices.fetchUserProfile(profileEmail: emailAddress);

        if (userDoc.data != null) {
          try {
            final UserCredential userCredential = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                email: emailAddress, password: password);

            if (userCredential.user != null) {
              await userCredential.user!.updateProfile(
                displayName: "${userDoc.data!.firstName} ${userDoc.data!.firstName}",
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
      } else if (e.code == 'wrong-password') {
        return APIResponse(success: false, message: 'Incorrect password.');
      } else {
        switch (e.code) {
          case 'invalid-email':
            return APIResponse(
                success: false, message: 'Invalid email address format.');
          case 'user-disabled':
            return APIResponse(
                success: false, message: 'User account is disabled.');
          default:
            return APIResponse(
                success: false,
                message: e.message ?? 'An unknown error occurred.');
        }
      }
    } catch (e) {
      return APIResponse(
          success: false, message: 'An error occurred. Please try again.');
    }
  }



  static Future<APIResponse<User?>> residentLogin({
    required String emailAddress,
    required String password,
  }) async {
    try {
      final UserCredential loginResponse = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailAddress, password: password);

      if (loginResponse.user != null) {
        return APIResponse(
            success: true,
            data: loginResponse.user,
            message: 'Login successful');
      } else {
        return APIResponse(
            success: false, message: 'Failed to login. Please try again.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        // Check if the user profile exists
        final userDoc = await ResidentServices.fetchResidentProfile(profileEmail: emailAddress);

        if (userDoc.data != null) {
          try {
            final UserCredential userCredential = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                email: emailAddress, password: password);

            if (userCredential.user != null) {
              await userCredential.user!.updateProfile(
                displayName: "${userDoc.data!.firstName} ${userDoc.data!.firstName}",
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
      } else if (e.code == 'wrong-password') {
        return APIResponse(success: false, message: 'Incorrect password.');
      } else {
        switch (e.code) {
          case 'invalid-email':
            return APIResponse(
                success: false, message: 'Invalid email address format.');
          case 'user-disabled':
            return APIResponse(
                success: false, message: 'User account is disabled.');
          default:
            return APIResponse(
                success: false,
                message: e.message ?? 'An unknown error occurred.');
        }
      }
    } catch (e) {
      return APIResponse(
          success: false, message: 'An error occurred. Please try again.');
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

  static Future<APIResponse<String?>> fetchUserRole(String email) async {
    final usersRef = FirebaseFirestore.instance.collection('staff');

    // Query the collection to find a user document with the specified email
    final querySnapshot = await usersRef.where('email', isEqualTo: email).get();

    // Check if any documents are found
    if (querySnapshot.docs.isNotEmpty) {
      // Get the first document found (assuming email is unique)
      final userDoc = querySnapshot.docs.first;
      return APIResponse(
          success: true,
          data: userDoc.data()['role'],
          message: 'Role fetched successfully');
    } else {
      return APIResponse(
          success: false,
          message:
              'Role fetching failed: no user found with the specified email');
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
