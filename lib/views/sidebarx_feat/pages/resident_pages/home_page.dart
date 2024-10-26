import 'package:flutter/material.dart';
import 'package:municipality/animations/fade_in_slide.dart';
import 'package:municipality/core/constants/color_constants.dart';
import 'package:municipality/core/constants/local_image_constants.dart';
import 'package:municipality/widgets/custom_button/general_button.dart';

class ChinhoyiMunicipalityScreen extends StatefulWidget {
  const ChinhoyiMunicipalityScreen({super.key});

  @override
  State<ChinhoyiMunicipalityScreen> createState() => _ChinhoyiMunicipalityScreenState();
}

class _ChinhoyiMunicipalityScreenState extends State<ChinhoyiMunicipalityScreen> {
  bool _isSurveyHovered = false;
  bool _isPayBillsHovered = false;
  bool _isImageHovered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 150),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: FadeInSlide(
                  duration: 2,
                  direction: FadeSlideDirection.btt,
                  curve: Curves.bounceIn,
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
                            child: MouseRegion(
                              onEnter: (_) => setState(() => _isSurveyHovered = true),
                              onExit: (_) => setState(() => _isSurveyHovered = false),
                              child: Transform.scale(
                                scale: _isSurveyHovered ? 1.1 : 1.0,
                                child: GeneralButton(
                                  onTap: () {},
                                  width: 100,
                                  borderRadius: 10,
                                  boxBorder: Border.all(
                                    color: !_isSurveyHovered
                                        ? Colors.white
                                        : Pallete.primaryColor,
                                  ),
                                  btnColor: _isSurveyHovered
                                      ? Colors.white
                                      : Pallete.primaryColor,
                                  child: Text(
                                    'CUSTOMER SURVEY 2024',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: !_isSurveyHovered
                                          ? Colors.white
                                          : Pallete.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: MouseRegion(
                              onEnter: (_) => setState(() => _isPayBillsHovered = true),
                              onExit: (_) => setState(() => _isPayBillsHovered = false),
                              child: Transform.scale(
                                scale: _isPayBillsHovered ? 1.1 : 1.0,
                                child: GeneralButton(
                                  onTap: () {},
                                  width: 100,
                                  borderRadius: 10,
                                  boxBorder: Border.all(
                                    color: _isPayBillsHovered
                                        ? Colors.white
                                        : Pallete.primaryColor,
                                  ),
                                  btnColor: !_isPayBillsHovered
                                      ? Colors.white
                                      : Pallete.primaryColor,
                                  child: Text(
                                    'PAY BILLS ONLINE',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _isPayBillsHovered
                                          ? Colors.white
                                          : Pallete.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                width: 40,
              ),

              Expanded(
                flex: 2,
                child: FadeInSlide(
                  duration: 2,
                  direction: FadeSlideDirection.ttb,
                  curve: Curves.bounceIn,
                  child: MouseRegion(
                    onEnter: (_) => setState(() => _isImageHovered = true),
                    onExit: (_) => setState(() => _isImageHovered = false),
                    child: Transform.scale(
                      scale: _isImageHovered ? 1.1 : 1.0,
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
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
