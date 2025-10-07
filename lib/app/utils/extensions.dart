import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

extension SvgPictureRotation on SvgPicture {
  Widget enableAutoMirror(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    if (!isRtl) {
      return Transform.rotate(angle: 3.1415926535, child: this); //180 degree
    }
    return this;
  }
}