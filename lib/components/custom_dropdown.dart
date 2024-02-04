import 'package:coaching_app/utils/extensions/extended_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';

class CustomDropDown extends StatefulWidget {
  final String hint;
  final List<String> items;
  final bool disable;
  final Color borderColor;
  final Color hintColor;
  final Color iconColor;
  final bool isOutline;
  final String? suffixIconPath;
  final double allPadding;
  final double verticalPadding;
  final double horizontalPadding;
  final Function(String value)? onSelect;

  const CustomDropDown(
      {Key? key,
      required this.hint,
      required this.items,
      this.iconColor = AppColors.grey3,
      this.hintColor = AppColors.grey3,
      this.suffixIconPath,
      this.disable = false,
      this.borderColor = AppColors.black,
      this.onSelect,
      this.isOutline = true,
      this.allPadding = 10,
      this.horizontalPadding = 16,
      this.verticalPadding = 0})
      : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: _boxDecoration(widget.isOutline),
      child: IgnorePointer(
        ignoring: widget.disable,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: DropdownButtonFormField(
            isExpanded: true,
            isDense: true,
            icon: (Icon(Icons.arrow_drop_down_circle_outlined)),
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.greyText,
              fontWeight: FontWeight.w500,
            ),
            hint: Text(
              widget.hint,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodySmall?.copyWith(
                fontSize: 16,
                color: widget.hintColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            decoration: InputDecoration(
              hintStyle: const TextStyle(
                fontSize: 16,
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w500,
              ),
              enabled: false,
              filled: true,
              fillColor: AppColors.darkGrey3,
              contentPadding: EdgeInsets.all(widget.allPadding) +
                  EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
              suffixIconConstraints:
                  const BoxConstraints(maxHeight: 24, maxWidth: 24),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            dropdownColor:  AppColors.darkGrey3,
            value: dropdownValue,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            onChanged: (String? newValue) {
              if (widget.onSelect != null) {
                widget.onSelect!(newValue!);
              }
              setState(() {
                dropdownValue = newValue!;
              });
            },
            menuMaxHeight: 550,
            items: widget.items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  value,
                  style: context.textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                    color: widget.hintColor,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(12.0),
  borderSide: const BorderSide(color: AppColors.grey),
);

BoxDecoration _boxDecoration(bool isOutline) {
  if (isOutline) {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.transparent,
          width: 1, //                   <--- border width here
        ));
  } else {
    return const BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12)));
  }
}
