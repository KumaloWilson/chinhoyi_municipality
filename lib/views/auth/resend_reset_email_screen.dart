import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/animation_asset_constants.dart';
import '../../core/constants/color_constants.dart';
import '../../core/utils/routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button/general_button.dart';

class ResendResetEmailScreen extends StatelessWidget {
  final String email;

  const ResendResetEmailScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
  double screenWidth = MediaQuery.sizeOf(context).width;


  return Scaffold(
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(65),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

            Row(
              children: [
                GestureDetector(
                  onTap: ()async{
                    await AuthServices.signOut().then((value){
                      Get.offAllNamed(
                        RoutesHelper.loginScreen
                      );
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Pallete.primaryColor
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),

            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Lottie.asset(
                      AnimationAsset.otpAnimation,
                      width: 200
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  const Text(
                    'Password Reset Email Sent',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  Text(
                    '\n$email\n',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  const Text(
                    'Your Account Security is our priority!. We`ve sent you a secure link to safely Change Your Password and keep\nYour Account Protected ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  GeneralButton(
                      btnColor: Pallete.primaryColor,
                      width: screenWidth,
                      borderRadius: 10,
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),

                      onTap: () => Get.offAllNamed(
                          RoutesHelper.loginScreen
                      )
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  GestureDetector(
                    onTap: ()async{
                      await AuthServices.sendPasswordResetEmail(email: email).then((response) {
                        Get.snackbar(
                          'Email Reset',
                          'Password Reset Email Sent',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 3),
                        );
                      });
                    },
                    child: RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              fontSize: 12,
                          ),
                          children: [
                            const TextSpan(
                                text: "Didn't receive the email?"
                            ),

                            TextSpan(
                                text: " Resend",
                                style: TextStyle(
                                    color: Pallete.primaryColor,
                                    fontWeight: FontWeight.bold
                                )
                            )
                          ]
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }
}