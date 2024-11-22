import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  final List<String> items;
  final String selectedValue;
  final IconData? prefixIcon;
  final Color? bgColor;
  final void Function(String?)? onChanged;
  final bool? isEnabled;

  const CustomDropDown({
    super.key,
    this.prefixIcon,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.isEnabled,
    this.bgColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: (isEnabled == null || isEnabled == true) ? bgColor ?? Colors.transparent :Theme.of(context).disabledColor.withOpacity(0.2),
        border: Border.all(
          color: Theme.of(context).disabledColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          if(prefixIcon != null)Expanded(
            flex: 1,
            child: Icon(
              prefixIcon,
              color: Theme.of(context).disabledColor,
            ),
          ),
          if(prefixIcon != null)const SizedBox(
            width: 8,
          ),
          Expanded(
            flex: 9,
            child: DropdownButton<String>(
              value: selectedValue,
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (isEnabled == null || isEnabled == true) ? onChanged : null, // Set onChanged callback based on isEnabled
              isExpanded: true,
              underline: const SizedBox(),
              style: const TextStyle(
                color: Colors.black,
              ),
              iconEnabledColor: Colors.black,
              icon: const Icon(Icons.arrow_drop_down),
              hint: const Text(
                'Select',
                style: TextStyle(color: Colors.grey),
              ),
              elevation: 16,
              borderRadius: BorderRadius.circular(10),
              dropdownColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
