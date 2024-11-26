import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/utils/logs.dart';
import '../../../../core/utils/providers.dart';
import '../../../../repository/helpers/add_resident_helper.dart';
import '../../../../services/communication_services.dart';
import '../../../../widgets/circular_loader/circular_loader.dart';
import '../../../../widgets/snackbar/custom_snackbar.dart';
import '../../../../widgets/tiles/profile_option_tile.dart';



class StaffProfileScreen extends StatefulWidget {
  const StaffProfileScreen({super.key});

  @override
  State<StaffProfileScreen> createState() => _StaffProfileScreenState();
}


class _StaffProfileScreenState extends State<StaffProfileScreen> {

  final TextEditingController usernameController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;



  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final staffAsync = ref.watch(ProviderUtils.staffProfileProvider(user?.email ?? ''));
        final userAsync = ref.watch(ProviderUtils.userProvider);

        if (staffAsync.isLoading || userAsync == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (staffAsync.hasError || userAsync == null) {
          return const Center(
            child: Text('An error occurred. Please try again.'),
          );
        }

        return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Pallete.whiteColor),
              centerTitle: true,
              title: Text(
                'Edit Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Pallete.whiteColor,
                ),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    color: Pallete.primaryColor
                ),
              ),
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(170),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 65,
                            backgroundImage: NetworkImage(
                              userAsync.photoURL ?? 'https://cdn-icons-png.flaticon.com/128/3177/3177440.png',
                            ),
                            onBackgroundImageError: (exception, stackTrace) {
                              DevLogs.logError('Error loading image: $exception');
                            },
                            child: userAsync.photoURL == null
                                ? const Icon(
                              Icons.person,
                              size: 65,
                              color: Colors.grey,
                            )
                                : null, // Fallback icon when there's no photo URL
                          ),
                          GestureDetector(
                            onTap: () async {
                              try {
                                // Show loader during the operation
                                Get.dialog(const CustomLoader(message: 'Updating profile picture'), barrierDismissible: false);

                                final result = await pickFile();
                                if (result != null) {
                                  // Upload the file to Firebase
                                  final response = await AnnouncementServices.uploadFileToFirebaseWeb(
                                    fileBytes: result.files.single.bytes!,
                                    fileName: result.files.single.name,
                                    user: user!,
                                  );

                                  // Validate response success and data
                                  if (response.success && response.data != null) {
                                    // Update Firebase user photo URL
                                    await user!.updatePhotoURL(response.data);

                                    // Update provider state with new user data
                                    final updatedUser = FirebaseAuth.instance.currentUser;
                                    ref.read(ProviderUtils.userProvider.notifier).updateUser(updatedUser);

                                    CustomSnackBar.showSuccessSnackbar(message: 'Profile picture updated successfully');
                                  } else {
                                    throw Exception('File upload failed. Please try again.');
                                  }
                                } else {
                                  DevLogs.logInfo('File selection was canceled.');
                                }
                              } catch (e) {
                                DevLogs.logError('Error updating profile picture: $e');
                                CustomSnackBar.showErrorSnackbar(message: 'An error occurred: $e');
                              } finally {
                                // Close the loader dialog
                                Get.back();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Pallete.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Pallete.whiteColor,
                              ),
                            ),
                          ),
                        ],
                      ),


                      const SizedBox(height: 16),
                    ],
                  )
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ProfileOptionTile(
                    title: "Username",
                    value: userAsync.displayName ?? 'No username',
                    icon: FontAwesomeIcons.userLarge,
                    onEdit: () async {
                      await AddResidentHelper.updateField(
                        title: 'Username',
                        initialValue: usernameController.text,
                        onUpdate: (updatedValue) async {
                          DevLogs.logSuccess("NEW VALUE: $updatedValue");
                          Get.dialog(
                            const CustomLoader(message: 'Updating username'),
                          );

                          try {
                            // Update Firebase user
                            await user!.updateDisplayName(updatedValue);

                            // Update provider state
                            final updatedUser = FirebaseAuth.instance.currentUser;
                            ref.read(ProviderUtils.userProvider.notifier).updateUser(updatedUser);

                            Get.back(); // Close the loader dialog
                            CustomSnackBar.showSuccessSnackbar(message: 'Username updated successfully');
                          } catch (e) {
                            DevLogs.logError(e.toString());
                            Get.back(); // Close the loader dialog
                            CustomSnackBar.showErrorSnackbar(message: 'Update error: $e');
                          }
                        },
                      );
                    },
                  ),


                  const SizedBox(height: 16),

                  ProfileOptionTile(
                    title: "Email",
                    value: user!.email!,
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 16),
                  ProfileOptionTile(
                    title: "Phone Number",
                    value: staffAsync.value!.phoneNumber,
                    icon: FontAwesomeIcons.phone,
                    onEdit: () async {
                      await AddResidentHelper.updateField(
                        title: 'Phone Number',
                        initialValue: staffAsync.value!.phoneNumber,
                        onUpdate: (updatedValue) async {
                          try {
                            final notifier = ref.read(ProviderUtils.staffProfileProvider(user!.email!).notifier);
                            final updatedProfile = notifier.state.value!.copyWith(phoneNumber: updatedValue);
                            await notifier.updateUserProfile(updatedProfile);
                          } catch (e) {
                            CustomSnackBar.showErrorSnackbar(message: 'Failed to update phone number: $e');
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  ProfileOptionTile(
                    title: "Department",
                    value: staffAsync.value!.department,
                    icon: FontAwesomeIcons.building,
                  ),
                  const SizedBox(height: 16),

                  const SizedBox(height: 16),
                  ProfileOptionTile(
                    title: "Date of Birth",
                    value: DateFormat('yyyy/MM/dd').format(staffAsync.value!.dateOfBirth),
                    icon: FontAwesomeIcons.cakeCandles,
                  ),
                  const SizedBox(height: 16),

                  ProfileOptionTile(
                    title: "Password",
                    value: '**************',
                    icon: FontAwesomeIcons.lock,
                    onEdit: () async {
                      await AddResidentHelper.updatePasswordField(
                        title: 'Password',
                        onUpdate: (oldPassword, updatedPassword) async {
                          // Show loading dialog
                          Get.dialog(
                            const CustomLoader(message: 'Updating password'),
                            barrierDismissible: false,
                          );

                          try {
                            // Validate the password strength before updating
                            if (updatedPassword.length < 8 || oldPassword.length < 8) {
                              throw Exception("Password must be at least 8 characters long.");
                            }

                            // Re-authenticate the user
                            final email = user!.email;

                            if (oldPassword.isEmpty) {
                              throw Exception("Re-authentication canceled.");
                            }

                            final credential = EmailAuthProvider.credential(email: email!, password: oldPassword);
                            await user!.reauthenticateWithCredential(credential);

                            // Update the password
                            await user!.updatePassword(updatedPassword);

                            // Close loader and show success message
                            Get.back();
                            CustomSnackBar.showSuccessSnackbar(message: 'Password updated successfully');
                          } catch (e) {
                            // Log error and show user-friendly message
                            DevLogs.logError("Password update error: $e");
                            Get.back(); // Ensure dialog is closed
                            CustomSnackBar.showErrorSnackbar(
                              message: e.toString().contains("requires-recent-login")
                                  ? "This operation requires recent authentication. Please log in again and try."
                                  : e.toString(),
                            );
                          }
                        },
                      );
                    },
                  ),


                ],
              ),
            )
        );
      },
    );
  }


  Future<FilePickerResult?> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      return result;
    } catch (e) {
      DevLogs.logError('Error picking file: $e');
      CustomSnackBar.showErrorSnackbar(message: e.toString());
      return null;
    }
  }

}