import 'package:flutter/material.dart';

extension ExtendedContext on BuildContext {
  // context.colorScheme...
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // context.textTheme...
  TextTheme get textTheme => Theme.of(this).textTheme;
}
