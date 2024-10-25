import 'package:flutter/material.dart';
import 'package:municipality/core/constants/color_constants.dart';
import 'package:municipality/core/constants/local_image_constants.dart';
import 'package:municipality/widgets/custom_button/general_button.dart';

class ChinhoyiMunicipalityScreen extends StatelessWidget {
  const ChinhoyiMunicipalityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 150),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'MUNICIPALITY\nOF CHINHOYI',
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'A smart city of\nchoice by 2030',
                        style: TextStyle(
                          fontSize: 32,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        children: [
                          Expanded(
                            child: GeneralButton(
                              onTap: (){

                              },
                              width: 100,
                              borderRadius: 10,
                              btnColor: Pallete.primaryColor,
                              child: const Text(
                                'CUSTOMER SURVEY 2024',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                            )
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GeneralButton(
                              onTap: (){

                              },
                              width: 100,
                              borderRadius: 10,
                              btnColor: Colors.white,
                              boxBorder: Border.all(
                                color: Pallete.primaryColor
                              ),
                              child: Text(
                                'PAY BILLS ONLINE',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Pallete.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  width: 40,
                ),

                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 500,
                        width: 800,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            LocalImageConstants.laptopWidget,
                            width: 400,
                            height: 300,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}