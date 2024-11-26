import 'package:flutter/material.dart';

import '../../core/constants/color_constants.dart';

class ProfileOptionTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final void Function()? onEdit;
  const ProfileOptionTile({super.key, required this.title, required this.value, required this.icon, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Pallete.whiteColor,
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
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          icon,
          size: 30,
          color: Colors.grey.shade700,
        ),
        title: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
              color: Pallete.primaryColor
          ),
        ),
        trailing: onEdit != null ? IconButton(
            onPressed: onEdit,
            icon: const Icon(
                Icons.edit
            )
        ): null
      ),
    );
  }
}
