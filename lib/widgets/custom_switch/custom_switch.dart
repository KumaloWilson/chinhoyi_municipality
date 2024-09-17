import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final Function(bool) onChanged;
  final Color activeColor;
  final Color backgroundColor;
  final double width;
  final double height;
  final EdgeInsets padding;

  const CustomSwitch({super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.blue,
    this.backgroundColor = Colors.grey,
    this.width = 50.0,
    this.height = 30.0,
    this.padding = const EdgeInsets.all(4.0),
  });

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  late bool switchValue;

  @override
  void initState() {
    super.initState();
    switchValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          switchValue = !switchValue;
          widget.onChanged(switchValue);
        });
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.height * 0.5),
          color: switchValue ? widget.activeColor : widget.backgroundColor,
        ),
        child: Stack(
          alignment: switchValue ? Alignment.centerRight : Alignment.centerLeft,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: widget.height - widget.padding.vertical,
              height: widget.height - widget.padding.vertical,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
