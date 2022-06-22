import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tourlao/model/notification_model.dart';
import 'package:tourlao/themes/colors.dart';
import 'package:tourlao/themes/dimens.dart';
import 'package:tourlao/themes/textstyles.dart';

class BackgroundWidget extends Container {
  BackgroundWidget({
    Key key,
    @required Widget child,
    bool isBlur = true,
    String backImage = 'assets/images/landing.png',
  }) : super(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage(backImage),
              fit: BoxFit.cover,
            ),
          ),
          child: isBlur
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.1)),
                    child: child,
                  ),
                )
              : child,
        );
}

class BlurWidget extends Container {
  BlurWidget({
    Key key,
    @required Widget child,
    EdgeInsets padding = const EdgeInsets.all(offsetBase),
    EdgeInsets margin = EdgeInsets.zero,
    double cornerRadius = offsetBase,
  }) : super(
          margin: margin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
            border: Border.all(color: Colors.white30),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                width: double.infinity,
                padding: padding,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius:
                        BorderRadius.all(Radius.circular(cornerRadius))),
                child: child,
              ),
            ),
          ),
        );
}

class BackgroundClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = itemPath(size);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}

Path itemPath(Size size) {
  var radius = 20.0;
  var path = Path();

  path.moveTo(0, size.height - radius);
  path.quadraticBezierTo(0, size.height, radius, size.height);
  path.lineTo(size.width - radius, size.height);
  path.quadraticBezierTo(
      size.width, size.height, size.width, size.height - radius);
  path.lineTo(size.width, radius);
  path.quadraticBezierTo(size.width, 0, size.width - radius, 0);
  path.lineTo(size.height + radius, 0);
  path.quadraticBezierTo(size.height, 0, size.height, radius);
  // path.lineTo(size.height, size.height * 0.25);
  path.quadraticBezierTo(
      size.height - 15, size.height - 15, 33, size.height - 41);
  path.quadraticBezierTo(0, size.height - 56.5, 0, size.height - radius);

  path.close();

  return path;
}

class CircleIndicator extends Container {
  CircleIndicator({
    double indicatorHeight = 100.0,
    double strokeWidth = 4.0,
    @required int valueT,
    @required int totalSecond,
  }) : super(
          height: indicatorHeight,
          width: indicatorHeight,
          alignment: Alignment.center,
          child: Container(
            height: indicatorHeight,
            width: indicatorHeight,
            child: Transform(
              child: CircularProgressIndicator(
                value: valueT / totalSecond,
                strokeWidth: strokeWidth,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation(
                  Colors.yellowAccent,
                ),
              ),
              alignment: FractionalOffset.center, // set transform origin
              // transform: new Matrix4.rotationZ(pi / 2),
              transform: new Matrix4.rotationZ(0),
            ),
          ),
        );
}

class BoxShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = itemPath(size);
    canvas.drawShadow(path, Colors.black, 2.0, true);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ItemView extends Container {
  ItemView()
      : super(
          padding: EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Positioned(
                left: 9,
                top: 8,
                child: Stack(
                  children: [
                    Container(
                      width: 100.0,
                      height: 100.0,
                    ),
                    CircleIndicator(valueT: 75, totalSecond: 100),
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          width: 90.0,
                          height: 90.0,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: CustomPaint(
                  painter: BoxShadowPainter(),
                  child: ClipPath(
                    clipper: BackgroundClipper(),
                    child: Container(
                      width: double.infinity,
                      height: 120.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.grey, Colors.blueGrey],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
}

class EmptyWidget extends Container {
  EmptyWidget(String title)
      : super(
          margin: EdgeInsets.symmetric(horizontal: offsetSm),
          width: double.infinity,
          height: 150.0,
          decoration: BoxDecoration(
            color: Colors.white30,
            borderRadius: BorderRadius.circular(offsetBase),
            border: Border.all(color: Colors.white12),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TourlaoText.medium(color: Colors.white),
          ),
        );
}

class ProcessingWidget extends SizedBox {
  ProcessingWidget({
    double size = 24.0,
  }) : super(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
}

class EmptyAvatar extends Container {
  EmptyAvatar()
      : super(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(offsetLg),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.white, kHintColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SvgPicture.asset(
            'assets/icons/ic_avatar.svg',
            color: Colors.white,
          ),
        );
}

class SettingItem extends Padding {
  SettingItem({
    @required Widget icon,
    @required Color color,
    @required Widget child,
  }) : super(
          padding: const EdgeInsets.symmetric(
            horizontal: offsetBase,
            vertical: offsetSm,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 21.5),
                child: CustomPaint(
                  painter: NotificationPainter(),
                  child: ClipPath(
                    clipper: NotificationClipper(),
                    child: Container(
                      padding: EdgeInsets.only(
                        left: offsetXLg,
                        top: offsetBase,
                        bottom: offsetBase,
                      ),
                      width: double.infinity,
                      color: Colors.white30,
                      child: child,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 15.5,
                child: Container(
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.white, color],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white54,
                          offset: Offset(0, 0),
                          blurRadius: 5,
                          spreadRadius: 3,
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: icon,
                  ),
                ),
              ),
            ],
          ),
        );
}
