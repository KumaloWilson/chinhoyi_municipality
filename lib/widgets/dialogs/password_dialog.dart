
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:municipality/core/constants/dimensions.dart';
import 'package:municipality/widgets/snackbar/custom_snackbar.dart';

import '../../core/constants/color_constants.dart';
import '../custom_button/general_button.dart';
import '../text_fields/custom_text_field.dart';

class UpdatePasswordDialog extends StatefulWidget {
  final String title;
  final PasswordUpdateCallback newPassword;

  const UpdatePasswordDialog({
    super.key,
    required this.title,
    required this.newPassword,
  });

  @override
  _UpdatePasswordDialogState createState() => _UpdatePasswordDialogState();
}

class _UpdatePasswordDialogState extends State<UpdatePasswordDialog> {
  late TextEditingController passwordController = TextEditingController();
  late TextEditingController oldPasswordController = TextEditingController();
  late TextEditingController confirmationController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final isButtonDisabled = passwordController.text.length < 8 && confirmationController.text.length < 8;

    return Dialog(
      alignment: Alignment.bottomCenter,
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 400,
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
              prefixIcon: const Icon(Icons.lock),
              labelText: 'Old password',
              controller: oldPasswordController,
              onChanged: (_) => setState(() {}),
            ),


            const SizedBox(
              height: 8,
            ),

            CustomTextField(
              prefixIcon: const Icon(Icons.lock),
              labelText: 'New Password',
              controller: passwordController,
              onChanged: (_) => setState(() {}),
            ),


            const SizedBox(
              height: 8,
            ),

            CustomTextField(
              prefixIcon: const Icon(Icons.lock),
              labelText: 'Confirm Password',
              controller: confirmationController,
              onChanged: (_) => setState(() {}),
            ),


            const SizedBox(
              height: 16,
            ),
            GeneralButton(
              onTap: isButtonDisabled
                  ? null
                  : () {

                if(oldPasswordController.text == passwordController.text || oldPasswordController.text == confirmationController.text){
                  CustomSnackBar.showErrorSnackbar(message: 'Old password can not be a new password');
                  return;
                }

                if(oldPasswordController.text.length < 8 || oldPasswordController.text.length < 8 || confirmationController.text.length < 8){
                  CustomSnackBar.showErrorSnackbar(message: 'Password length cannot be less than 8');
                  return;
                }

                if(passwordController.text != confirmationController.text){
                  CustomSnackBar.showErrorSnackbar(message: 'Passwords don`t match');
                  return;
                }


                widget.newPassword(oldPasswordController.text.trim() ,confirmationController.text.trim());
                Get.back();
              },
              width: Dimensions.screenWidth,
              btnColor: isButtonDisabled ? Colors.grey : Pallete.primaryColor,
              child: Text(
                'Change Password',
                style: TextStyle(color: Pallete.whiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


typedef PasswordUpdateCallback = void Function(String oldPassword, String newPassword);
