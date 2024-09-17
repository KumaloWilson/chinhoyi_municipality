import 'package:flutter/material.dart';

class GeneralButton extends StatelessWidget {
  final Color btnColor;
  final double width;
  final double? height;
  final double borderRadius;
  final BoxBorder? boxBorder;
  final Widget child;
  final void Function() onTap;

  const GeneralButton({
    super.key,
    required this.btnColor,
    required this.width,
    required this.borderRadius,
    this.height,
    required this.child,
    this.boxBorder,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: width,
          height: height ?? 50,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
              color: btnColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: boxBorder),
          child: child),
    );
  }
}
