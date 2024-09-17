import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../core/constants/animation_asset_constants.dart';
import '../../core/constants/color_constants.dart';
import '../../core/utils/routes.dart';
import '../../widgets/custom_button/general_button.dart';
class AccountVerificationSuccessful extends StatelessWidget {
  const AccountVerificationSuccessful({super.key});


  @override
  Widget build(BuildContext context) {
  double screenWidth = Get.width;

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 25,
          ),

          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Lottie.asset(
                    AnimationAsset.successfulAnimation,
                    width: 200
                ),

                const SizedBox(
                  height: 8,
                ),

                const Text(
                  'Verification Successful',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),

                const Text(
                  'Congratulations your account has been activated.Continue to start using the app.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),

                const SizedBox(
                  height: 40,
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

                    onTap: () => Get.offAllNamed(RoutesHelper.initialScreen)
                ),

                const SizedBox(
                  height: 30,
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
