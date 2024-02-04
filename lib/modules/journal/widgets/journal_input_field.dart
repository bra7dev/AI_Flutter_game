import 'package:coaching_app/constants/app_colors.dart';
import 'package:coaching_app/utils/extensions/extended_context.dart';
import 'package:flutter/material.dart';

class JournalInputField extends StatelessWidget {
  final String title;
  final String hintText;
  final int maxLines;
  final int minLines;
  final TextEditingController? controller;
  final String? Function(String? val)? onValidate;
  final Function(String?) onChanged;

  const JournalInputField({
    super.key,
    this.controller,
    this.title = '',
    this.hintText = '',
    this.maxLines = 4,
    this.minLines = 4,
    this.onValidate,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          maxLines: maxLines,
          minLines: minLines,
          controller: controller,
          validator: onValidate,
          maxLength: 400,
          cursorColor: AppColors.secondary,
          style: TextStyle(height: 1.6),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              color: AppColors.white.withOpacity(0.7),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            // Set the fill color
            border: OutlineInputBorder(
              // Define the border
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none, // Remove the border
            ),
            enabledBorder: OutlineInputBorder(
              // Define the border
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none, // Remove the border
            ),

            disabledBorder: OutlineInputBorder(
              // Define the border
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none, // Remove the border
            ),
            errorBorder: OutlineInputBorder(
              // Define the border
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none, // Remove the border
            ),
            focusedBorder: OutlineInputBorder(
              // Define the border
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none, // Remove the border
            ),
            focusedErrorBorder: OutlineInputBorder(
              // Define the border
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none, // Remove the border
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
