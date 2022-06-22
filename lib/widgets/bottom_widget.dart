import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tourlao/themes/colors.dart';

Path bottomBarPath({
  @required Size size,
  int index = 2,
}) {
  const kBottomSelectedIconSize = 60.0;
  var width = size.width - kBottomSelectedIconSize;

  var path = Path();
  path.lineTo(width * (0.1 + 0.4 * index), 0);
  path.arcToPoint(
    Offset(width * (0.1 + 0.4 * index) + kBottomSelectedIconSize, 0),
    radius: Radius.circular(kBottomSelectedIconSize * 0.5 + 2.0),
    rotation: pi / 9 * 10,
    clockwise: false,
    largeArc: true,
  );
  path.lineTo(size.width, 0);
  path.lineTo(size.width, size.height);
  path.lineTo(0, size.height);
  path.close();

  return path;
}

class BottomBarClipper extends CustomClipper<Path> {
  final int selectedIndex;
  BottomBarClipper(this.selectedIndex);

  @override
  getClip(Size size) {
    var path = bottomBarPath(size: size, index: selectedIndex);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}

class BottomBarPainter extends CustomPainter {
  final int selectedIndex;
  BottomBarPainter(this.selectedIndex);

  @override
  void paint(Canvas canvas, Size size) {
    var path = bottomBarPath(size: size);
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = kPrimaryColor;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
