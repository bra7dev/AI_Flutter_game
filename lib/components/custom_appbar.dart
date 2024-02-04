import 'package:coaching_app/config/routes/nav_router.dart';
import 'package:coaching_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

import 'custom_back_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final Widget? leading;
  final Color backgroundColor;
  final List<Widget> actions;

  CustomAppBar({
    required this.title,
    this.actions = const [],
    this.height = kToolbarHeight,  this.leading,
    this.backgroundColor = AppColors.darkGrey3
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 48,
      backgroundColor:backgroundColor ,
      automaticallyImplyLeading: false,
      leading:leading,
      title: Text(title),
      actions: actions,
    );
  }
}
