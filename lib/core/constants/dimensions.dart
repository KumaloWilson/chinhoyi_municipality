import 'package:get/get.dart';

class Dimensions {
  // Base height and width for scaling
  static double screenHeight = Get.height;
  static double screenWidth = Get.width;
  static bool get isSmallScreen => _isSmallScreen();
  static bool get isMediumScreen => _isMediumScreen();
  static bool get isLargeScreen => _isLargeScreen();

  // Breakpoints for different screen sizes
  static const double smallScreenMaxWidth = 600.0;
  static const double mediumScreenMaxWidth = 1200.0;

  // Dynamic height, padding, and margin
  static double height5 = screenHeight / 160.0;
  static double height10 = screenHeight / 80.0;
  static double height15 = screenHeight / 53.33;
  static double height20 = screenHeight / 40.0;
  static double height25 = screenHeight / 32.0;
  static double height30 = screenHeight / 26.67;
  static double height50 = screenHeight / 16.0;

  // Dynamic width, padding, and margin
  static double width5 = screenWidth / 160.0;
  static double width10 = screenWidth / 80.0;
  static double width15 = screenWidth / 53.33;
  static double width20 = screenWidth / 40.0;
  static double width25 = screenWidth / 32.0;
  static double width30 = screenWidth / 26.67;
  static double width50 = screenWidth / 16.0;

  // Font sizes
  static double font12 = screenHeight / 66.67;
  static double font14 = screenHeight / 57.14;
  static double font16 = screenHeight / 50.0;
  static double font18 = screenHeight / 44.44;
  static double font20 = screenHeight / 40.0;
  static double font24 = screenHeight / 33.33;

  // Icon sizes
  static double iconSize16 = screenHeight / 50.0;
  static double iconSize24 = screenHeight / 33.33;
  static double iconSize32 = screenHeight / 25.0;
  static double iconSize40 = screenHeight / 20.0;

  // Border Radius
  static double radius5 = screenHeight / 160.0;
  static double radius10 = screenHeight / 80.0;
  static double radius15 = screenHeight / 53.33;
  static double radius20 = screenHeight / 40.0;
  static double radius30 = screenHeight / 26.67;

  // Dynamic size method for specific usage
  static double dynamicHeight(double height) {
    return screenHeight * height / 800.0; // Based on a 800px height screen
  }

  static double dynamicWidth(double width) {
    return screenWidth * width / 400.0; // Based on a 400px width screen
  }

  // Methods to determine screen size categories
  static bool _isSmallScreen() {
    return screenWidth <= smallScreenMaxWidth;
  }

  static bool _isMediumScreen() {
    return screenWidth > smallScreenMaxWidth && screenWidth <= mediumScreenMaxWidth;
  }

  static bool _isLargeScreen() {
    return screenWidth > mediumScreenMaxWidth;
  }

  // Get screen height and width
  static double getScreenHeight() {
    return screenHeight;
  }

  static double getScreenWidth() {
    return screenWidth;
  }
}
