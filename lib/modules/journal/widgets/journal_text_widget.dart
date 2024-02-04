import 'package:coaching_app/constants/app_colors.dart';
import 'package:coaching_app/modules/journal/model/get_journal_model.dart';
import 'package:flutter/material.dart';

class JournalTextWidget extends StatelessWidget {
  final String title;
  final String text;
  final Journal? journal;
  final Color? color;
  final TextStyle textStyle;
  final VoidCallback? seeAllTapped;

  const JournalTextWidget({
    super.key,
    this.title = '',
    required this.text,
    this.seeAllTapped,
    this.color,
    required this.textStyle,
    this.journal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              children: [
                Expanded(child: Text(title)),
                if (seeAllTapped != null)
                  GestureDetector(
                    onTap: seeAllTapped,
                    child: Text('See All'),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 4,
          ),
        ],
        Card(
          color: color,
          surfaceTintColor: Colors.transparent,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Text(
              text,
              style: textStyle,
            ),
          ),
        ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }
}
