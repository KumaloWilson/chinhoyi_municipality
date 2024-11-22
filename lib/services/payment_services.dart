import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe_web/flutter_stripe_web.dart';
import 'package:get/get.dart';
import 'package:municipality/core/configs.dart';
import 'package:municipality/core/utils/api_response.dart';
import 'package:municipality/core/utils/logs.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../widgets/snackbar/custom_snackbar.dart';

class PaymentServices {
  /// Displays the payment sheet to the user
  static Future<void> showPaymentSheet() async {
    try {
      await WebStripe.instance.presentPaymentSheet();
    } on StripeException catch (e) {
      DevLogs.logError("StripeException: ${e.toString()}");

      Get.dialog(
        AlertDialog(
          title: const Text('Payment Error'),
          content: Text(e.error.localizedMessage ?? 'Unknown error occurred'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Close'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      DevLogs.logError("Unexpected error: $e");
      _showGenericErrorDialog();
    }
  }

  /// Initializes the payment sheet with the required parameters
  static Future<void> paymentSheetInit({
    required double amount,
    required String currency,
  }) async {
    try {
      // Fetch the Payment Intent details
      final intent = await makePaymentIntent(amount: amount, currency: currency);

      if (intent.success && intent.data != null) {
        final data = intent.data;

        await WebStripe.instance.initPaymentSheet(

          SetupPaymentSheetParameters(
            customFlow: false,
            allowsDelayedPaymentMethods: true,
            merchantDisplayName: 'Chinhoyi Municipality',
            paymentIntentClientSecret: data['paymentIntent'],
            customerEphemeralKeySecret: data['ephemeralKey'],
            customerId: data['customer'],
            googlePay: const PaymentSheetGooglePay(
              merchantCountryCode: 'US',
              testEnv: true,
            ),
            style: ThemeMode.dark,
            // Only include Apple Pay on supported platforms
            applePay: GetPlatform.isWeb
                ? null
                : const PaymentSheetApplePay(
              merchantCountryCode: 'US',
            ),
          ),
        );
        DevLogs.logSuccess('Payment sheet initialized successfully');
      } else {
        DevLogs.logError('Failed to initialize payment sheet');
        _showGenericErrorDialog();
      }
    } catch (e) {
      DevLogs.logError("Error during payment sheet initialization: $e");
      _showGenericErrorDialog();
    }
  }

  /// Creates a Payment Intent and returns the result
  static Future<APIResponse<dynamic>> makePaymentIntent({
    required double amount,
    required String currency,
  }) async {
    try {
      final paymentInfo = {
        'amount': (amount * 100).round().toString(),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': "Bearer ${SecretsConfig.secretKey}",
          'Content-Type': "application/x-www-form-urlencoded",
        },
        body: paymentInfo,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        DevLogs.logSuccess('Payment Intent created: ${response.body}');

        return APIResponse(
          message: 'success',
          data: data,
          success: true,
        );
      } else {
        DevLogs.logError(
          'Failed to create Payment Intent. Status Code: ${response.statusCode}',
        );
        DevLogs.logError('Response Body: ${response.body}');
        return APIResponse(
          message: 'Failed to create Payment Intent',
          success: false,
        );
      }
    } catch (e) {
      DevLogs.logError("Exception in makePaymentIntent: $e");
      return APIResponse(
        message: 'Exception occurred while creating Payment Intent',
        success: false,
      );
    }
  }

  /// Displays a generic error dialog
  static void _showGenericErrorDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Error'),
        content: const Text('An unexpected error occurred. Please try again.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }


  ///HANDLE WEB CHECKOUT

  static Future<void> handleWebCheckout({required String email, required List<dynamic> cartItems}) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/checkout'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'line_items': cartItems,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final String checkoutUrl = responseData['url'];

        if (await canLaunchUrl(Uri.parse(checkoutUrl))) {
          await launchUrl(
            Uri.parse(checkoutUrl),
            webOnlyWindowName: '_self',
          );
        }
      } else {
        CustomSnackBar.showErrorSnackbar(message: 'Failed to Initialize Payment');
        return;
      }
    } catch (e) {
      DevLogs.logError(e.toString());
      CustomSnackBar.showErrorSnackbar(message: e.toString());
      return;
    }
  }


}
