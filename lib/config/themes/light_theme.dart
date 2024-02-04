import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

/// body medium 14 normal
/// body large 16 normal
/// title small 14 500
/// title medium 16 500

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.darkGrey1,

  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.darkGrey,
    brightness: Brightness.dark,
  ),

  textTheme: TextTheme(
    bodyLarge: TextStyle(fontSize: 16),
    bodyMedium: TextStyle(fontSize: 14),
    bodySmall: TextStyle(fontSize: 12),
  ),

  splashFactory: InkSplash.splashFactory,

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkGrey3,
    selectedItemColor: AppColors.secondary,
    unselectedItemColor: Color(0xffB5B4B4),
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: TextStyle(fontSize: 12),
    unselectedLabelStyle: TextStyle(fontSize: 12),
  ),

  /// -------------------------- Card Theme -------------------------- ///

  cardTheme: CardTheme(
    color: AppColors.darkGrey3,
    shape: RoundedRectangleBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(8.0),
      ),
    ),
  ),

  /// -------------------------- TextButton theme ------------------------

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.secondary,
      textStyle: TextStyle(color: AppColors.secondary),
    ),
  ),

  checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all<Color>(AppColors.grey),
      checkColor: MaterialStateProperty.all<Color>(AppColors.white),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), side: BorderSide.none),
      side: BorderSide.none),

  /// -------------------------- Appbar Theme -------------------------- ///
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkGrey3,
    // set status bar text color to dark...
    // systemOverlayStyle: SystemUiOverlayStyle.dark,
    elevation: 0,
    centerTitle: true,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  ),

  /// -------------------------- Textfield Theme -------------------------- ///
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: const TextStyle(fontSize: 14, color: AppColors.black),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
    hintStyle: const TextStyle(
        fontWeight: FontWeight.w400, fontSize: 14, color: Colors.grey),
    filled: true,

    fillColor: AppColors.darkGrey3,
    errorStyle: const TextStyle(color: AppColors.red),

    /// Borders
    disabledBorder: _outlineInputBorder,
    enabledBorder: _outlineInputBorder,
    border: _outlineInputBorder,
    errorBorder: _errorBorder,
    focusedErrorBorder: _errorBorder,
    focusedBorder: _outlineInputBorder.copyWith(
      borderSide: const BorderSide(
        color: AppColors.secondary,
      ),
    ),
  ),
);

final _outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: const BorderSide(
    color: AppColors.secondary,
  ),
);

final _errorBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: const BorderSide(
    color: AppColors.red,
  ),
);
