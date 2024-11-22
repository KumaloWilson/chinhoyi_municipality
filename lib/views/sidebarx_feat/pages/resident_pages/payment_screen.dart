import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:municipality/core/constants/color_constants.dart';
import 'package:municipality/core/constants/local_image_constants.dart';
import 'package:municipality/core/utils/logs.dart';
import 'package:municipality/widgets/cards/payment_method.dart';
import 'package:municipality/widgets/custom_button/general_button.dart';
import 'package:municipality/widgets/custom_dropdown.dart';
import 'package:municipality/widgets/snackbar/custom_snackbar.dart';
import 'package:municipality/widgets/text_fields/custom_text_field.dart';

import '../../../../services/stripe_services.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  final user = FirebaseAuth.instance.currentUser;
  String _selectedCurrency = 'USD';
  TextEditingController _amountController = TextEditingController();
  late TextEditingController _emailController;
  bool _isLoading = false;

  /// Handles Credit Card Payment
  void _handleCreditCardPayment() {
    // Call PaymentServices.paymentSheetInit() here with the required amount and currency.
    // Example: PaymentServices.paymentSheetInit(amount: 50.0, currency: 'USD');
  }
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: user!.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
             Row(
               children: [
                 Expanded(
                   flex: 2,
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       const Text(
                         'Select a Payment Method',
                         style: TextStyle(
                           fontSize: 20,
                           fontWeight: FontWeight.bold,
                           color: Colors.black87,
                         ),
                       ),

                       const SizedBox(
                         height: 32,
                       ),
                       PaymentMethodCard(
                         imagePath: LocalImageConstants.creditCard,
                         title: 'Credit Card',
                         subtitle: 'Pay using your credit or debit card.',
                         onTap: _handleCreditCardPayment,
                         isEnabled: true,
                       ),
                       const SizedBox(
                         height: 16,
                       ),
                       const PaymentMethodCard(
                         imagePath: LocalImageConstants.ecoCash,
                         title: 'EcoCash',
                         subtitle: 'Coming Soon',
                         isEnabled: false,
                       ),

                       const SizedBox(
                         height: 16,
                       ),

                       const PaymentMethodCard(
                         imagePath: LocalImageConstants.oneMoney,
                         title: 'OneWallet',
                         subtitle: 'Coming Soon',
                         isEnabled: false,
                       ),

                       const SizedBox(
                         height: 16,
                       ),

                       const PaymentMethodCard(
                         imagePath: LocalImageConstants.innBucks,
                         title: 'InnBucks',
                         subtitle: 'Coming Soon',
                         isEnabled: false,
                       ),
                     ],
                   ),
                 ),

                 const SizedBox(
                   width: 32,
                 ),

                 Expanded(
                   flex: 4,
                   child: Container(
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
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         const Text(
                           'Credit Card Payment Form',
                           style: TextStyle(
                             fontSize: 20,
                             fontWeight: FontWeight.bold,
                             color: Colors.black87,
                           ),
                         ),

                         const SizedBox(
                           height: 32,
                         ),

                         CustomTextField(
                           controller: _emailController,
                           labelText: 'Email Address',
                           enabled: false,
                           prefixIcon: const Icon(
                               FontAwesomeIcons.moneyBill
                           ),
                         ),


                         const SizedBox(
                           height: 16,
                         ),

                         CustomDropDown(
                           onChanged: (value){
                              setState(() {
                                _selectedCurrency = value!;
                              });
                           },
                           selectedValue: _selectedCurrency,
                           items: const ['USD', 'ZWG'],
                         ),

                         const SizedBox(
                           height: 16,
                         ),

                         CustomTextField(
                           controller: _amountController,
                           labelText: 'Amount (0.00)',
                           onChanged: (value) {
                             DevLogs.logInfo(value!.length.toString());

                             setState(() {
                               // Remove any non-numeric characters except for "."
                               String filteredValue = value.replaceAll(RegExp(r'[^0-9.]'), '');

                               // Prevent multiple decimal points
                               if (RegExp(r'\..*\.').hasMatch(filteredValue)) {
                                 filteredValue = filteredValue.replaceRange(
                                     filteredValue.lastIndexOf('.'), filteredValue.lastIndexOf('.') + 1, '');
                               }

                               // Limit decimal places to 2
                               if (filteredValue.contains('.')) {
                                 List<String> parts = filteredValue.split('.');
                                 String integerPart = parts[0];
                                 String decimalPart = parts[1].length > 2 ? parts[1].substring(0, 2) : parts[1];

                                 // Limit integer part to 3 digits
                                 if (integerPart.length > 3) {
                                   integerPart = integerPart.substring(0, 3);
                                 }

                                 filteredValue = '$integerPart.$decimalPart';
                               } else {
                                 // If there's no decimal, limit integer part to 3 digits
                                 if (filteredValue.length > 3) {
                                   filteredValue = filteredValue.substring(0, 3);
                                 }
                               }

                               // Update the controller only if the value changed
                               if (_amountController.text != filteredValue) {
                                 _amountController.value = TextEditingValue(
                                   text: filteredValue,
                                   selection: TextSelection.collapsed(offset: filteredValue.length),
                                 );
                               }
                             });
                           },
                           prefixIcon: const Icon(FontAwesomeIcons.moneyBill),
                         ),


                         const SizedBox(
                           height: 32,
                         ),

                         GeneralButton(
                           onTap: () async {
                             String input = _amountController.text.trim();

                             // Check if the amount field is empty
                             if (input.isEmpty) {
                               CustomSnackBar.showErrorSnackbar(message: "Amount field cannot be empty.");
                               return;
                             }

                             // Validate if the input is numeric
                             if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(input)) {
                               CustomSnackBar.showErrorSnackbar(message: "Please enter a valid numeric amount.");
                               return;
                             }

                             try {
                               double amount = double.parse(input);

                               // Ensure the amount is greater than 10
                               if (amount < 10 || amount > 300) {
                                 CustomSnackBar.showErrorSnackbar(message: "Amount should range between 10 and 300");
                                 return;
                               }

                               // Build the cart items
                               final List<Map<String, dynamic>> cartItems = [
                                 {
                                   'price_data': {
                                     'currency': 'usd',
                                     'product_data': {'name': 'Water Bill Payment'},
                                     'unit_amount': (0.7 * amount * 100).round(),
                                   },
                                   'quantity': 1,
                                 },
                                 {
                                   'price_data': {
                                     'currency': 'usd',
                                     'product_data': {'name': 'Sewage'},
                                     'unit_amount': (0.2 * amount * 100).round(),
                                   },
                                   'quantity': 1,
                                 },
                                 {
                                   'price_data': {
                                     'currency': 'usd',
                                     'product_data': {'name': 'Bins'},
                                     'unit_amount': (0.1 * amount * 100).round(),
                                   },
                                   'quantity': 1,
                                 },
                               ];

                               setState(() {
                                 _isLoading = true;
                               });

                               // Call the payment service
                               await StripeServices.handleWebCheckout(
                                 email: _emailController.text,
                                 cartItems: cartItems,
                               ).then((response){
                                 setState(() {
                                   _isLoading = false;
                                 });
                               });
                             } catch (e) {
                               // Handle unexpected errors
                               CustomSnackBar.showErrorSnackbar(message: "Something went wrong. Please try again.");
                             }
                           },
                           width: 200,
                           borderRadius: 10,
                           btnColor: Pallete.primaryColor,
                           child: _isLoading
                               ? LoadingAnimationWidget.hexagonDots(
                             color: Pallete.whiteColor,
                             size: 30
                         )
                               : const Text(
                             'Proceed',
                             style: TextStyle(color: Colors.white, fontSize: 16),
                           ),
                         ),
                       ]
                     ),
                   ),
                 ),
               ],
             ),
            ],
          ),
        ),
      ),
    );
  }
}
