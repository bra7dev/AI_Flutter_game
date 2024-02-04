import 'package:cached_network_image/cached_network_image.dart';
import 'package:coaching_app/components/components.dart';
import 'package:flutter/material.dart';

class CircularCachedImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final String errorPath;

  CircularCachedImage({
    required this.imageUrl,
    this.width = 100,
    this.height = 100,
    this.fit = BoxFit.cover,
    this.errorPath =  'assets/images/png/placeholder.jpg',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,

      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => Center(child: LoadingIndicator(),),
        imageBuilder: (context, imageProvider) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider, fit: BoxFit.cover,),
          ),
        ),
        errorWidget: (context, url, error) =>  Center(
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                      errorPath),
                  fit: BoxFit.cover,
                ),
              ),
            )),
        fit: fit,
      ),
    );
  }
}
