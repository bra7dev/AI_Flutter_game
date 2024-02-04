import 'package:coaching_app/utils/extensions/extended_context.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    required this.onPressed,
    required this.title,
    this.textColor = AppColors.white,
    this.backgroundColor = AppColors.secondary,
    this.isOutlinedButton = false,
    this.horizontalPadding = 0,
    this.isRounded = false,
    this.isEnabled = true,
    this.disabledColor,
    this.hasIcon = false,
    this.icon,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String title;
  final Color textColor;
  final Color backgroundColor;
  final bool isOutlinedButton;
  final double horizontalPadding;
  final bool isRounded;
  final bool isEnabled;
  final Color? disabledColor;
  final bool hasIcon;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          disabledForegroundColor: Colors.black,
          disabledBackgroundColor: AppColors.secondary.withOpacity(0.5),
          backgroundColor: isOutlinedButton ? Colors.transparent : backgroundColor,
          side: BorderSide(
            color: isOutlinedButton ? backgroundColor : Colors.transparent,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isRounded ? 40 : 14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasIcon)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  icon!,
                  color: AppColors.secondary,
                  size: 20,
                ),
              ),
            Text(
              title,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
