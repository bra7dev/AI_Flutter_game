import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/constants.dart';
import 'circular_cached_image.dart';

class ProfilePictureWidget extends StatelessWidget {
  final String profileUrl;
  final VoidCallback onTap;

  const ProfilePictureWidget({
    Key? key,
    required this.profileUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(profileUrl);
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            profileUrl.contains('http')
                ? Hero(
              tag: 'profile_image',

              child: CircularCachedImage(
              imageUrl: profileUrl,
              width: 115,
              height: 115,
            ),
                )
                : SizedBox(
              height: 115,
              width: 115,
              child: CircleAvatar(
                backgroundImage: profileUrl.contains('assets/')
                    ? AssetImage(profileUrl) as ImageProvider
                    : FileImage(
                  File(profileUrl),
                ),
              ),
            ),
            GestureDetector(
              onTap: onTap,
              child: Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.primaryLight,
                ),
                child: Center(
                  child: Icon(Icons.edit),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
