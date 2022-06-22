import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tourlao/generated/l10n.dart';
import 'package:tourlao/themes/colors.dart';
import 'package:tourlao/themes/dimens.dart';
import 'package:tourlao/themes/textstyles.dart';

class CategoryModel {
  String id;
  String name;
  String name_la;
  String desc;
  String amount;
  String image;

  CategoryModel({
    this.id,
    this.name,
    this.name_la,
    this.desc,
    this.amount,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "name_la": this.name,
      "desc": this.desc,
      "amount": this.amount,
      "image": this.image,
    };
  }

  factory CategoryModel.fromLocalJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["id"],
      name: json["name"],
      name_la: json["name"],
      desc: json["desc"],
      amount: json["amount"],
      image: json["image"],
    );
  }

  factory CategoryModel.fromServerJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["sc_id"],
      name: json["sc_name"],
      name_la: json["sc_name_la"],
      amount: json["sc_amount"].toString(),
      image: 'assets/icons/${(json["sc_icon"] as String).split('.')[0]}.svg',
    );
  }

  Widget getListWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: offsetBase,
        vertical: offsetXSm,
      ),
      child: Stack(
        children: [
          Positioned(
            top: 15.5,
            child: Container(
              width: 44.0,
              height: 44.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.white, kPrimaryColor],
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
                  ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  image,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 21.5,
            child: Container(
              width: 32.0,
              height: 32.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                Icons.double_arrow,
                size: 14.0,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 21.5, right: 16),
            child: ClipPath(
              clipper: CategoryClipper(),
              child: Container(
                width: double.infinity,
                height: 75.0,
                padding: EdgeInsets.only(left: offsetLg, top: offsetSm),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.withOpacity(0.5),
                      kPrimaryColor.withOpacity(0.5)
                    ],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TourlaoText.semiBold(
                        fontSize: fontXMd,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                    ),
                    SizedBox(height: offsetXSm,),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14.0,
                          color: kHintColor,
                        ),
                        SizedBox(width: offsetXSm,),
                        Text(
                          '${S.current.found} ${amount != null? amount : '---'} ${S.current.places}',
                          style: TourlaoText.medium(
                            fontSize: fontSm,
                            color: kHintColor,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Path categoryPath({
  @required Size size,
}) {
  const radius = 8.0;
  const iconLg = 52.0;
  const iconSm = 36.0;

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
  path.lineTo(size.width, (size.height + iconSm) * 0.5);
  path.arcToPoint(
    Offset(size.width, (size.height - iconSm) * 0.5),
    radius: Radius.circular(iconSm * 0.5),
    rotation: pi,
    clockwise: true,
  );
  path.lineTo(size.width, radius);
  path.quadraticBezierTo(size.width, 0, size.width - radius, 0);
  path.lineTo(radius, 0);
  path.quadraticBezierTo(0, 0, 0, radius);
  path.close();

  return path;
}

class CategoryClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = categoryPath(size: size);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}

class CategoryShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = categoryPath(size: size);
    canvas.drawShadow(path, Colors.white, 2.0, true);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
