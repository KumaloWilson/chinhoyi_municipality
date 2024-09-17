import 'package:extended_phone_number_input/consts/enums.dart';
import 'package:extended_phone_number_input/phone_number_controller.dart';
import 'package:extended_phone_number_input/phone_number_input.dart';
import 'package:flutter/material.dart';

import '../../core/constants/color_constants.dart';

class CustomPhoneInput extends StatelessWidget {
  final Color? fillColor;
  final bool? filled;
  final Color? focusedBoarderColor;
  final Color? defaultBoarderColor;
  final PhoneNumberInputController? controller;
  final String? labelText;
  final void Function(String?)? onChanged;
  final bool? obscureText;
  final TextStyle? labelStyle;
  final TextStyle? inputTextStyle;
  final TextInputType? keyBoardType;
  final Icon? pickFromContactsIcon;
  final int? maxLength;
  final Widget? suffixIconButton;
  final bool? enabled;

  const CustomPhoneInput({super.key, this.maxLength, this.controller, this.fillColor, this.filled, this.defaultBoarderColor, this.focusedBoarderColor, required this.labelText, this.labelStyle, this.inputTextStyle, this.keyBoardType, required this.pickFromContactsIcon, this.obscureText, this.suffixIconButton, this.enabled, this.onChanged,});

  @override
  Widget build(BuildContext context) {
    return PhoneNumberInput(
      controller: controller,
      onChanged: onChanged,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: defaultBoarderColor ?? Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: focusedBoarderColor ?? Pallete.primaryColor),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: defaultBoarderColor ?? Colors.grey),
      ),
      countryListMode: CountryListMode.bottomSheet,
      allowPickFromContacts: true,
      allowSearch: true,
      initialCountry: 'ZW',
      locale: 'fr',
      errorText: 'Invalid Phone Number',
      searchHint: 'Search Country Code',
      hint: labelText,
      pickContactIcon: pickFromContactsIcon,
      showSelectedFlag: false,
      contactsPickerPosition: ContactsPickerPosition.suffix,
    );
  }
}
