import 'package:flutter/material.dart';
import 'package:tourlao/themes/colors.dart';
import 'package:tourlao/themes/dimens.dart';
import 'package:tourlao/themes/textstyles.dart';
import 'package:tourlao/utils/constants.dart';

Path appBarPath({
  @required Size size,
}) {
  var ratio01Y = 0.6;
  var ratio02X = 0.16;
  var ratio02Y = 0.83;
  var ratio03Y = 0.5;

  var path = Path();
  path.lineTo(0, size.height * ratio01Y);
  path.quadraticBezierTo(
      0, size.height, size.width * ratio02X, size.height * ratio02Y);
  path.quadraticBezierTo(size.width * 0.5, size.height * ratio03Y,
      size.width * (1 - ratio02X), size.height * ratio02Y);
  path.quadraticBezierTo(
      size.width, size.height, size.width, size.height * ratio01Y);
  path.lineTo(size.width, 0);
  path.close();

  return path;
}

class AppbarClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = appBarPath(size: size);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}

class AppbarShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = appBarPath(size: size);
    canvas.drawShadow(path, Colors.black, 2.0, true);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class TourlaoAppBar extends StatelessWidget {
  final Widget titleWidget;
  final Widget prefix;
  final Widget suffix;

  const TourlaoAppBar({
    Key key,
    @required this.titleWidget,
    @required this.prefix,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: AppbarShadowPainter(),
      child: ClipPath(
        clipper: AppbarClipper(),
        child: Container(
          width: double.infinity,
          height: kAppbarHeight,
          color: kPrimaryColor,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: offsetSm,
                    left: offsetXLg,
                    right: offsetXLg,
                  ),
                  child: titleWidget,
                ),
              ),
              Positioned(
                left: offsetBase,
                top: offsetMd,
                child: prefix,
              ),
              if (suffix != null)
                Positioned(
                  right: offsetBase,
                  top: offsetMd,
                  child: suffix,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class TitleWidget extends Row {
  TitleWidget({
    @required Widget icon,
    @required String title,
  }) : super(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            SizedBox(
              width: offsetBase,
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 250.0),
              child: Text(
                title,
                style: TourlaoText.bold(
                  fontSize: fontXMd,
                  color: Colors.white,
                ),
                maxLines: 1,
              ),
            ),
          ],
        );
}
