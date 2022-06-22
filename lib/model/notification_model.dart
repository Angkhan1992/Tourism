import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tourlao/generated/l10n.dart';
import 'package:tourlao/themes/colors.dart';
import 'package:tourlao/themes/dimens.dart';
import 'package:tourlao/themes/textstyles.dart';
import 'package:tourlao/utils/extensions.dart';

class NotificationModel {
  String nt_id;
  String usr_id;
  String type;
  String created_at;

  NotificationModel({
    this.nt_id,
    this.usr_id,
    this.type,
    this.created_at,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      nt_id: json["nt_id"],
      usr_id: json["usr_id"],
      type: json["type"],
      created_at: json["created_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nt_id": this.nt_id,
      "usr_id": this.usr_id,
      "type": this.type,
      "created_at": this.created_at,
    };
  }

  Widget getItem() {
    var widgetColor = kPrimaryColor;
    var notificationIcon = Icons.verified_user;

    if (type == '3' || type == '4') {
      widgetColor = Colors.pink;
      notificationIcon = Icons.favorite_outline;
    }
    if (type == '5') {
      widgetColor = Colors.purple;
      notificationIcon = Icons.rate_review_outlined;
    }

    var notificationContent = S.current.notiRegister;
    switch (type) {
      case '1':
        notificationContent = S.current.notiRegister;
        break;
      case '2':
        notificationContent = S.current.notiLogin;
        break;
      case '3':
        notificationContent = S.current.notiLike;
        break;
      case '4':
        notificationContent = S.current.notiUnlike;
        break;
      case '5':
        notificationContent = S.current.notiComment;
        break;
    }
    return Padding(
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
                    top: offsetBase - 1,
                    bottom: offsetBase - 1,
                  ),
                  width: double.infinity,
                  height: 75.0,
                  color: Colors.white30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        created_at.currentTime,
                        style: TourlaoText.medium(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        notificationContent,
                        style: TourlaoText.bold(
                          fontSize: fontMd,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                      )
                    ],
                  ),
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
                    colors: [Colors.white, widgetColor],
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
                child: Icon(
                  notificationIcon,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Path notificationPath({
  @required Size size,
}) {
  const radius = 8.0;
  const iconLg = 52.0;

  var path = Path();
  path.moveTo(0, radius);
  path.lineTo(0, (size.height - iconLg) * 0.5);
  path.arcToPoint(
    Offset(0, (size.height + iconLg) * 0.5),
    radius: Radius.circular(iconLg * 0.5),
    rotation: pi,
    clockwise: true,
  );
  path.lineTo(0, size.height - radius);
  path.quadraticBezierTo(
    0,
    size.height,
    radius,
    size.height,
  );
  path.lineTo(size.width - radius, size.height);
  path.quadraticBezierTo(
      size.width, size.height, size.width, size.height - radius);
  // path.lineTo(size.width, (size.height + iconSm) * 0.5);
  // path.arcToPoint(
  //   Offset(size.width, (size.height - iconSm) * 0.5),
  //   radius: Radius.circular(iconSm * 0.5),
  //   rotation: pi,
  //   clockwise: true,
  // );
  path.lineTo(size.width, radius);
  path.quadraticBezierTo(size.width, 0, size.width - radius, 0);
  path.lineTo(radius, 0);
  path.quadraticBezierTo(0, 0, 0, radius);
  path.close();

  return path;
}

class NotificationClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = notificationPath(size: size);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}

class NotificationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = notificationPath(size: size);
    // canvas.drawShadow(path, Colors.white, 2.0, true);
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
