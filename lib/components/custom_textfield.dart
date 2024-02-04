// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.title,
    this.enableBorderColor = Colors.orangeAccent,
    this.focusBorderColor = Colors.orange,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixWidget,
    this.fontSize = 14,
    this.obscureText = false,
    this.fillColor = Colors.white,
    this.bottomMargin = 20,
    this.minLines = 1,
    this.onTap,
    this.controller,
    this.inputType,
    this.inputFormatters,
    this.onSaved,
    this.onChange,
    this.onValidate,
  });

  final Color fillColor;
  final String hintText;
  final String title;
  final double bottomMargin;
  final bool readOnly;
  final Color enableBorderColor;
  final Color focusBorderColor;
  final Widget? prefixIcon;
  final Widget? suffixWidget;
  final double? fontSize;
  final bool obscureText;
  final VoidCallback? onTap;
final int minLines;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String? val)? onSaved;
  final void Function(String val)? onChange;
  final String? Function(String? val)? onValidate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          height: 6,
        ),
        Stack(
          children: [
            TextFormField(
              controller: controller,
              readOnly: readOnly,
              keyboardType: inputType,
              validator: onValidate,
              onSaved: onSaved,
              onChanged: onChange,
              minLines: minLines,
              maxLines: minLines,
              inputFormatters: inputFormatters,
              onTap: onTap,
              cursorColor: Colors.deepOrangeAccent,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: prefixIcon,
              ),
            ),
            Positioned(
              right: 0,
              left: null,
              top: -3,
              child: Align(
                alignment: Alignment.centerRight,
                child: suffixWidget,
              ),
            ),
          ],
        ),
        SizedBox(
          height: bottomMargin,
        ),
      ],
    );
  }
}
