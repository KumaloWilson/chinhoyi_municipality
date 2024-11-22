import 'package:flutter/material.dart';

import '../../core/constants/color_constants.dart';

class PaymentMethodCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool isEnabled;
  const PaymentMethodCard({super.key, required this.imagePath, required this.title, required this.subtitle, this.onTap, required this.isEnabled});

  @override
  State<PaymentMethodCard> createState() => _PaymentMethodCardState();
}

class _PaymentMethodCardState extends State<PaymentMethodCard> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;

        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: isHovered
                ? (Matrix4.identity()..scale(1.05))
                : Matrix4.identity(),
            decoration: BoxDecoration(
              color: widget.isEnabled ? Colors.white : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: widget.isEnabled ? Pallete.primaryColor : Colors.grey.shade400,
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Image.asset(
                  widget.imagePath,
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: widget.isEnabled ? Colors.black87 : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.isEnabled ? Colors.black54 : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
