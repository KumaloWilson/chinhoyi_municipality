import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../core/constants/animation_asset_constants.dart';
import '../../core/constants/color_constants.dart';
import '../../core/utils/logs.dart';
import '../../core/utils/routes.dart';
import '../../repository/helpers/auth_helpers.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button/general_button.dart';

class EmailVerificationScreen extends StatefulWidget {
  final User user;

  const EmailVerificationScreen({super.key, required this.user});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    AuthHelpers.setTimerForAutoRedirect();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              Row(
                children: [
                  GestureDetector(
                    onTap: ()async{
                      await AuthServices.signOut().then((response){
                        if(response.success){
                          Get.offAllNamed(RoutesHelper.staffLoginScreen);
                        }else{
                          DevLogs.logError(response.message ?? 'Something went wrong');
                        }
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
                      'Verify you email address',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                    ),

                    Text(
                      '\n${widget.user.email}\n',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                      ),
                    ),

                    const Text(
                      'Congratulations your account awaits. Verify your email to start and get going.',
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

                        onTap: () => AuthHelpers.checkEmailVerification(currentUser: _currentUser)
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    GestureDetector(
                      onTap: () async {
                        await FirebaseAuth.instance.currentUser!.sendEmailVerification();

                        Get.snackbar(
                          'Email Verification',
                          'Verification Email Sent',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 3),
                        );
                      },

                      child: RichText(
                        text: TextSpan(
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black
                            ),
                            children: [
                              const TextSpan(
                                  text: "Didn't receive the email? "
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