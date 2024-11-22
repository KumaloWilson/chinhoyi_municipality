import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:municipality/core/constants/color_constants.dart';
import 'package:municipality/core/constants/local_image_constants.dart';
import 'package:municipality/services/payment_services.dart';
import 'package:municipality/widgets/cards/payment_method.dart';
import 'package:municipality/widgets/custom_button/general_button.dart';
import 'package:municipality/widgets/custom_dropdown.dart';
import 'package:municipality/widgets/text_fields/custom_text_field.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  String _selectedCurrency = 'USD';
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  /// Handles Credit Card Payment
  void _handleCreditCardPayment() {
    // Call PaymentServices.paymentSheetInit() here with the required amount and currency.
    // Example: PaymentServices.paymentSheetInit(amount: 50.0, currency: 'USD');
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
                           prefixIcon: Icon(
                               FontAwesomeIcons.moneyBill
                           ),
                         ),


                         SizedBox(
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

                         SizedBox(
                           height: 16,
                         ),

                         CustomTextField(
                           controller: _amountController,
                           labelText: 'Amount (0.00)',
                           prefixIcon: Icon(
                             FontAwesomeIcons.moneyBill
                           ),
                         ),
                         SizedBox(
                           height: 32,
                         ),

                         GeneralButton(
                           onTap: () async{
                             double amount  = double.parse(_amountController.text);

                             final List<Map<String, dynamic>> cartItems = [
                               {
                                 'price_data': {
                                   'currency': 'usd',
                                   'product_data': {'name': 'Water Bill Payment'},
                                   'unit_amount': (0.7 * amount) * 100,
                                 },
                                 'quantity': 1,
                               },

                               {
                                 'price_data': {
                                   'currency': 'usd',
                                   'product_data': {'name': 'Sewage'},
                                   'unit_amount': (0.2 * amount) * 100,
                                 },
                                 'quantity': 1,
                               },

                               {
                                 'price_data': {
                                   'currency': 'usd',
                                   'product_data': {'name': 'Bins'},
                                   'unit_amount': (0.1 * amount) * 100,
                                 },
                                 'quantity': 1,
                               },
                             ];


                             await PaymentServices.handleWebCheckout(email: _emailController.text, cartItems: cartItems);

                           },
                           width: 200,
                           borderRadius: 10,
                           btnColor: Pallete.primaryColor,
                           child: const Text(
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
