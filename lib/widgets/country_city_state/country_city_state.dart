import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';

class CountryCityState extends StatefulWidget {
  const CountryCityState({super.key, this.onSelectionChanged});

  final Function(String country, String state, String city)? onSelectionChanged;

  @override
  State<CountryCityState> createState() => _CountryCityStateState();
}

class _CountryCityStateState extends State<CountryCityState> {
  // Variables to hold selected values
  String? countryValue;
  String? stateValue;
  String? cityValue;

  @override
  Widget build(BuildContext context) {
    return CSCPicker(
      onCountryChanged: (value) {
        setState(() {
          countryValue = value.toString();
          _onSelectionChanged();
        });
      },
      onStateChanged: (value) {
        setState(() {
          stateValue = value.toString();
          _onSelectionChanged();
        });
      },
      onCityChanged: (value) {
        setState(() {
          cityValue = value.toString();
          _onSelectionChanged();
        });
      },
    );
  }

  void _onSelectionChanged() {
    if (widget.onSelectionChanged != null) {
      widget.onSelectionChanged!(
        countryValue ?? '',
        stateValue ?? '',
        cityValue ?? '',
      );
    }
  }
}
