import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../models/chat_entity.dart';


class PredefineTile extends StatelessWidget {
  final ChatEntity chat;
  final Color tileColor;
  final int messageId;
  final VoidCallback onTap;
  final double leftMargin;

  const PredefineTile({
    super.key,
    required this.chat,
    required this.tileColor,
    required this.messageId,
    required this.onTap,
    this.leftMargin = 70,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: leftMargin),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 16, right: 32, top: 12, bottom: 12),
          decoration: BoxDecoration(
              color: tileColor, borderRadius: BorderRadius.circular(10)),
          child: Text(
            chat.message,
            style: TextStyle(fontSize: 15, color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
