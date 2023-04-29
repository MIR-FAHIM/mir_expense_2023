import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Helper {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static String getAssetName(String fileName, String type) {
    return "assets/images/$type/$fileName";
  }
  static BoxDecoration getBoxDecorationImage(
      {Color? color, double? radius, bool? isLocal = false, Border? border, Gradient? gradient, String image = ''}) {
    return BoxDecoration(
      color: color ?? Get.theme.backgroundColor,
      borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
      boxShadow: [
        BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
      ],
      border: border ?? Border.all(color: Get.theme.focusColor.withOpacity(0.05)),
      gradient: gradient,
      image: DecorationImage(
          image: CachedNetworkImageProvider(
            image,
          ),
          fit: BoxFit.cover),
    );
  }
  static TextTheme getTheme(BuildContext context) {
    return Theme.of(context).textTheme;
  }
}
