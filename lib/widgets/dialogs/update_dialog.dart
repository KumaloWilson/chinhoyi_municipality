import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimensions.dart';
import '../custom_button/general_button.dart';
import '../text_fields/custom_text_field.dart';

class UpdateDialog extends StatefulWidget {
  final String title;
  final String initialValue;
  final ValueChanged<String> onUpdate;

  const UpdateDialog({
    super.key,
    required this.title,
    required this.initialValue,
    required this.onUpdate,
  });

  @override
  _UpdateDialogState createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    final isButtonDisabled = controller.text.length < 5 || widget.initialValue == controller.text;

    return Dialog(
      alignment: Alignment.bottomCenter,
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 200,
        padding: const EdgeInsets.only(left: 350, right: 350, bottom: 16, top: 4),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Expanded(flex: 3, child: Container()),
                const Expanded(
                  flex: 1,
                  child: Divider(
                    thickness: 5,
                    color: Colors.grey,
                  ),
                ),
                Expanded(flex: 3, child: Container()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Update ${widget.title}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            CustomTextField(
              prefixIcon: const Icon(Icons.location_city),
              labelText: widget.title,
              controller: controller,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(
              height: 16,
            ),
            GeneralButton(
              onTap: isButtonDisabled
                  ? null
                  : () {
                widget.onUpdate(controller.text.trim());
                Get.back();
              },
              width: Dimensions.screenWidth,
              btnColor: isButtonDisabled ? Colors.grey : Pallete.primaryColor,
              child: Text(
                'Update',
                style: TextStyle(color: Pallete.whiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
