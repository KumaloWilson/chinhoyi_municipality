import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:municipality/core/constants/dimensions.dart';
import 'package:municipality/core/constants/local_image_constants.dart';
import '../../animations/fade_in_slide.dart';
import '../../core/constants/color_constants.dart';
import '../../core/utils/routes.dart';
import '../../repository/helpers/auth_helpers.dart';
import '../../widgets/custom_button/general_button.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/text_fields/custom_text_field.dart';

class CustomerSignUpScreen extends StatefulWidget {
  const CustomerSignUpScreen({super.key});

  @override
  State<CustomerSignUpScreen> createState() => _CustomerSignUpScreenState();
}

class _CustomerSignUpScreenState extends State<CustomerSignUpScreen> {

  List<String> suburbs = [
    'Brundish',
    'Cherima',
    'Chikonohono',
    'Chitambo',
    'Chikangwe',
    'Cold Stream',
    'Gadzema',
    'Gunhill',
    'Hunyani',
    'Katanda',
    'Madzibaba',
    'Mapako',
    'Mhangura',
    'Mpata',
    'Ngezi',
    'Nyamhunga',
    'Orange Grove',
    'Pfura',
    'Ruvimbo',
    'Rusununguko',
    'White City',
    'Zvimba',
    'Chinhoyi Township',
  ];
  
  final nationalIDNumber = TextEditingController();
  final houseNumber = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String _selectedSuburb = 'Cold Stream';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 120),
          FadeInSlide(
              duration: 1.0,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 150,
                child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle
                    ),
                    child: Image.asset(LocalImageConstants.logo)
                ),
              )
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Chinhoyi Town Council',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
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
                  children: [
                    const FadeInSlide(
                      duration: 1.0,
                      child: Text(
                        'Residence Registration',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    FadeInSlide(
                      duration: 1.2,
                      child: CustomTextField(
                        controller: nationalIDNumber,
                        labelText: 'National ID Number',
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    FadeInSlide(
                      duration: 1.2,
                      child: CustomTextField(
                        controller: emailController,
                        labelText: 'Email Address',
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    FadeInSlide(
                      duration: 1.6,
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: houseNumber,
                              labelText: 'House Number',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomDropDown(
                              items: suburbs,
                              selectedValue: _selectedSuburb,
                              onChanged: (value) {
                                setState(() {
                                  _selectedSuburb = value!;
                                });
                              },
                              isEnabled: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    FadeInSlide(
                      duration: 1.8,
                      child: CustomTextField(
                        controller: passwordController,
                        obscureText: true,
                        labelText: 'password',
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),
                    FadeInSlide(
                      duration: 2,
                      child: CustomTextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        labelText: 'Confirm password',
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                      ),
                    ),


                    const SizedBox(
                      height: 24,
                    ),
                    FadeInSlide(
                      duration: 1.8,
                      child: GeneralButton(
                          btnColor: Pallete.primaryColor,
                          width: Dimensions.screenWidth,
                          borderRadius: 10,
                          child: const Text(
                            'Register Account',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12
                            ),
                          ),
                          onTap: ()=> AuthHelpers.customerSignUpValidateAndSubmitForm(
                            nationalID: nationalIDNumber.text.trim(),
                            confirmPassword: confirmPasswordController.text.trim(),
                            houseNumber: houseNumber.text.trim(),
                            suburb: _selectedSuburb,
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          )
                      ),
                    ),


                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          const SizedBox(
            height: 20,
          ),
          FadeInSlide(
            duration: 2.4,
            child: GestureDetector(
              onTap: () => Get.toNamed(RoutesHelper.residentLoginScreen),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                    children: [
                      const TextSpan(
                          text: "Already have an account?  ",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400
                          )
                      ),
                      TextSpan(
                          text: "Login Here",
                          style: TextStyle(
                              color: Pallete.primaryColor,
                              fontWeight: FontWeight.w400
                          )
                      ),
                    ]
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}