import 'package:coaching_app/modules/chat/models/chat_entity.dart';
import 'package:flutter/cupertino.dart';

import '../../../constants/app_colors.dart';

class SenderTile extends StatelessWidget {
  final ChatEntity chat;
  final tileColor;

  SenderTile({
    required this.chat,
    this.tileColor = AppColors.darkGrey3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 70),
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
    );
  }
}
