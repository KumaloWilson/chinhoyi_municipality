import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/animation_asset_constants.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/dimensions.dart';
import '../../../../core/utils/routes.dart';
import '../../../../widgets/custom_button/general_button.dart';

class PaymentSuccessful extends StatelessWidget {
  const PaymentSuccessful({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: Dimensions.isSmallScreen ? 350 : 400,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                  AnimationAsset.successfulAnimation,
                  width: 200
              ),

              const SizedBox(
                height: 8,
              ),

              const Text(
                'Payment Successful',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),

              const Text(
                'Your payment was made successfully\nContinue to proceed',
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
                  width: Dimensions.screenWidth,
                  borderRadius: 10,
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),

                  onTap: () => Get.offAllNamed(RoutesHelper.initialScreen)
              ),

            ],
          ),
        ),
      ),
    );
  }
}
