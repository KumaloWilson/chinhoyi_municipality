import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe_web/flutter_stripe_web.dart';
import 'package:get/get.dart';
import 'package:municipality/core/configs.dart';
import 'package:municipality/core/constants/color_constants.dart';
import 'package:municipality/views/not_found/not_found_screen.dart';
import 'core/utils/routes.dart';
import 'firebase_options.dart';
import 'views/auth/auth_handler.dart';

Future<void> main() async {
  await _setup();
  runApp(const ProviderScope(child: Alpha()));
}

Future<void> _setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );

  WebStripe.instance.initialise(
    publishableKey: SecretsConfig.publishableKey,
  );

  WebStripe.instance.updateSettingsLazily;
}

class Alpha extends StatelessWidget {
  const Alpha({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: Pallete.primaryColor,
        dialogBackgroundColor: Colors.white, // Change dialog background color
        focusColor: Pallete.primaryColor, // Change focus color
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Pallete.primaryColor,
          secondary: Pallete.accentColor,
          surface: Colors.grey[200], // General background color
          onPrimary: Colors.white, // Text color on primary color
          onSecondary: Colors.black, // Text color on secondary color
          onSurface: Colors.black,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 18.0),
          displayMedium: TextStyle(fontSize: 18.0),
          displaySmall: TextStyle(fontSize: 18.0),
          headlineLarge: TextStyle(fontSize: 18.0),
          headlineMedium: TextStyle(fontSize: 18.0),
          headlineSmall: TextStyle(fontSize: 18.0),
          titleLarge: TextStyle(fontSize: 18.0),
          titleMedium: TextStyle(fontSize: 18.0),
          titleSmall: TextStyle(fontSize: 18.0),
          bodyLarge: TextStyle(fontSize: 18.0),
          bodyMedium: TextStyle(fontSize: 18.0),
          bodySmall: TextStyle(fontSize: 18.0),
          labelLarge: TextStyle(fontSize: 18.0),
          labelMedium: TextStyle(fontSize: 18.0),
          labelSmall: TextStyle(fontSize: 18.0),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white, // Dialog background color
          titleTextStyle: TextStyle(
              color: Pallete.primaryColor, fontSize: 20), // Dialog title text style
          contentTextStyle: const TextStyle(
              color: Colors.black, fontSize: 16
          ), // Dialog content text style
        ),
      ),
      supportedLocales: const [
        Locale('en'), // English
        Locale('sh'), // Shona
        Locale('nbl') // Ndebele
      ],
      initialRoute: RoutesHelper.splashScreen,
      getPages: RoutesHelper.routes,
      unknownRoute: GetPage(
          name: "/",
          page: ()=> const NotFoundScreen()
      ),
      home: const AuthHandler(),
    );
  }
}
