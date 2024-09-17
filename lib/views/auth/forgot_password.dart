import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../core/constants/animation_asset_constants.dart';
import '../../core/constants/color_constants.dart';
import '../../core/utils/routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/circular_loader/circular_loader.dart';
import '../../widgets/custom_button/general_button.dart';
import '../../widgets/text_fields/custom_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {

  ForgotPasswordScreen({super.key,});

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(
              height: 50,
            ),
            CircleAvatar(
              radius: 120,
              backgroundColor: Colors.transparent,
              child: Lottie.asset(
                AnimationAsset.resetPasswordAnimation,
              ),
            ),

            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20
              ),

              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-5, -5),
                    blurRadius: 10,
                  ),
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(5, 5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Reset Password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  const Text(
                    'Enter your email and we will send you a password reset link',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),


                  CustomTextField(
                    controller: emailController,
                    obscureText: false,
                    labelText: 'Email Address',
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  GeneralButton(
                    btnColor: Pallete.primaryColor,
                    width: screenWidth,
                    borderRadius: 10,
                    child: const Text(
                        'Reset Password',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),

                    onTap: () async{
                      Get.dialog(
                          const CustomLoader(
                              message: 'Resetting Password'
                          )
                      );


                      await AuthServices.sendPasswordResetEmail(email: emailController.text.trim()).then((response) {
                        Get.offAllNamed(
                          RoutesHelper.resendVerificationEmailScreen,
                          arguments: [
                            emailController.text.trim()
                          ]
                        );
                      });

                    },
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
