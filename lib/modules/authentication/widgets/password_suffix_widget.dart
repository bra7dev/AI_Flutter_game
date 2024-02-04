import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

class PasswordSuffixWidget extends StatelessWidget {
  const PasswordSuffixWidget(
      {Key? key, required this.isPasswordVisible, required this.onTap})
      : super(key: key);
  final bool isPasswordVisible;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      splashRadius: 20,
      icon: Icon(
        isPasswordVisible
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined,
        color: AppColors.grey,
        size: 24,
      ),
    );
  }
}
