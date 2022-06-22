import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tourlao/themes/colors.dart';
import 'package:tourlao/themes/dimens.dart';
import 'package:tourlao/themes/textstyles.dart';
import 'package:tourlao/widgets/commons.dart';

class ProductModel {
  String id;
  String name;
  String desc;
  String image;
  String rate;
  String review;

  ProductModel({
    this.id,
    this.name,
    this.desc,
    this.image,
    this.rate,
    this.review,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      name: json["name"],
      desc: json["desc"],
      image: json["image"],
      rate: json["rate"],
      review: json["review"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "desc": this.desc,
      "image": this.image,
      "rate": this.rate,
      "review": this.review,
    };
  }

  Widget getTopWidget(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 16, left: 12, bottom: 4, right: 4),
          child: CustomPaint(
            painter: TopShadowPainter(),
            child: ClipPath(
              clipper: TopClipper(),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: offsetBase,
                        vertical: offsetSm,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0)),
                        color: kPrimaryColor.withOpacity(0.5),
                      ),
                      child: Text(
                        name,
                        style: TourlaoText.semiBold(
                            fontSize: fontXMd, color: Colors.white),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: offsetBase,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, kPrimaryColor],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Text(
                          desc,
                          style: TourlaoText.medium(
                            fontSize: fontSm,
                            color: Colors.white,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 4,
          child: Container(
            width: 90.0,
            height: 90.0,
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.deepPurpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                Positioned(
                  left: 1.0,
                  top: 3.0,
                  child: Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 24.0,
                  ),
                ),
                Positioned(
                  left: 24.0,
                  top: 5.0,
                  child: Text(
                    rate,
                    style: TourlaoText.bold(
                      fontSize: 14.0,
                      color: Colors.yellowAccent,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          id,
                          style: TourlaoText.bold(
                            fontSize: 36.0,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            id == '1'? 'st' : id == '2'? 'nd' : id == '3'? 'rd' : 'th',
                            style: TourlaoText.medium(
                              fontSize: fontSm,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.supervisor_account_rounded,
                          color: Colors.black,
                          size: 16,
                        ),
                        Text(
                          ' $review',
                          style: TourlaoText.bold(
                            fontSize: fontSm,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CircleIndicator(
                  valueT: 75,
                  totalSecond: 100,
                  indicatorHeight: 90.0,
                  strokeWidth: 2.0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Path topPath({
  @required Size size,
}) {
  const offsetDimension = 70.5;
  const radius = 20.0;

  var path = Path();
  path.moveTo(0, offsetDimension);
  path.arcToPoint(
    Offset(offsetDimension, 0),
    radius: Radius.circular(50),
    rotation: pi,
    clockwise: false,
  );
  path.lineTo(size.width - radius, 0);
  path.quadraticBezierTo(size.width, 0, size.width, radius);
  path.lineTo(size.width, size.height - radius);
  path.quadraticBezierTo(
      size.width, size.height, size.width - radius, size.height);
  path.lineTo(radius, size.height);
  path.quadraticBezierTo(0, size.height, 0, size.height - radius);
  path.close();

  return path;
}

class TopClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = topPath(size: size);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}

class TopShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = topPath(size: size);
    canvas.drawShadow(path, Colors.white, 2.0, true);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
