import 'package:coaching_app/modules/chat/models/chat_entity.dart';
import 'package:coaching_app/utils/extensions/extended_context.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

class ReceiverTile extends StatelessWidget {
  final ChatEntity chat;

  ReceiverTile({required this.chat});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: chat.status == 'typing' ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(right: 10),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Image.asset(
            'assets/images/png/ic-gpt.png',
            height: 22,
            width: 22,
          ),
        ),
        Flexible(
          child: chat.status == 'typing'
              ? Text('typing...', style: context.textTheme.bodyMedium?.copyWith(color: AppColors.white))
              : Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(right: 50),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.grey2, borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      chat.message,
                      style: TextStyle(fontSize: 15, color: AppColors.black),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
