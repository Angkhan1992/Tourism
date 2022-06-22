import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:tourlao/providers/network_provider.dart';
import 'package:tourlao/themes/colors.dart';
import 'package:tourlao/themes/dimens.dart';
import 'package:tourlao/themes/textstyles.dart';
import 'package:tourlao/utils/constants.dart';
import 'package:tourlao/utils/params.dart';

class SpotModel {
  String spot_id;
  String spot_name;
  String spot_name_la;
  String spot_district;
  String spot_district_la;
  String spot_city;
  String spot_city_la;
  String spot_province;
  String spot_province_la;
  String spot_address;
  String spot_address_la;
  String spot_usage;
  String spot_usage_la;
  String spot_mark;
  String spot_mark_la;
  String spot_price;
  String spot_lat;
  String spot_lon;
  String spot_tel;
  String spot_thumb;
  String spot_desc;
  String spot_desc_la;
  String loc_id;
  String con_name;
  String con_name_la;
  String con_village;
  String con_village_la;
  String con_district;
  String con_district_la;
  String con_province;
  String con_province_la;
  String con_city;
  String con_city_la;
  String con_tel;
  String con_fax;
  String created_at;
  String updated_at;

  String spot_imgs;
  String cnt_like;
  String is_like;
  String cnt_comment;
  String rate;

  SpotModel({
    this.spot_id,
    this.spot_name,
    this.spot_name_la,
    this.spot_district,
    this.spot_district_la,
    this.spot_city,
    this.spot_city_la,
    this.spot_province,
    this.spot_province_la,
    this.spot_address,
    this.spot_address_la,
    this.spot_usage,
    this.spot_usage_la,
    this.spot_mark,
    this.spot_mark_la,
    this.spot_price,
    this.spot_lat,
    this.spot_lon,
    this.spot_tel,
    this.spot_thumb,
    this.spot_desc,
    this.spot_desc_la,
    this.loc_id,
    this.con_name,
    this.con_name_la,
    this.con_village,
    this.con_village_la,
    this.con_district,
    this.con_district_la,
    this.con_province,
    this.con_province_la,
    this.con_city,
    this.con_city_la,
    this.con_tel,
    this.con_fax,
    this.created_at,
    this.updated_at,
    this.spot_imgs,
    this.cnt_like,
    this.is_like,
    this.cnt_comment,
    this.rate,
  });

  factory SpotModel.fromJson(Map<String, dynamic> json) {
    return SpotModel(
      spot_id: json["spot_id"],
      spot_name: json["spot_name"],
      spot_name_la: json["spot_name_la"],
      spot_district: json["spot_district"],
      spot_district_la: json["spot_district_la"],
      spot_city: json["spot_city"],
      spot_city_la: json["spot_city_la"],
      spot_province: json["spot_province"],
      spot_province_la: json["spot_province_la"],
      spot_address: json["spot_address"],
      spot_address_la: json["spot_address_la"],
      spot_usage: json["spot_usage"],
      spot_usage_la: json["spot_usage_la"],
      spot_mark: json["spot_mark"],
      spot_mark_la: json["spot_mark_la"],
      spot_price: json["spot_price"],
      spot_lat: json["spot_lat"],
      spot_lon: json["spot_lon"],
      spot_tel: json["spot_tel"],
      spot_thumb: json["spot_thumb"],
      spot_desc: json["spot_desc"],
      spot_desc_la: json["spot_desc_la"],
      loc_id: json["loc_id"],
      con_name: json["con_name"],
      con_name_la: json["con_name_la"],
      con_village: json["con_village"],
      con_village_la: json["con_village_la"],
      con_district: json["con_district"],
      con_district_la: json["con_district_la"],
      con_province: json["con_province"],
      con_province_la: json["con_province_la"],
      con_city: json["con_city"],
      con_city_la: json["con_city_la"],
      con_tel: json["con_tel"],
      con_fax: json["con_fax"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      spot_imgs: json["spot_imgs"],
      cnt_like: json["cnt_like"].toString(),
      is_like: json["is_like"].toString(),
      cnt_comment: json["cnt_comment"].toString(),
      rate: json["rate"].toString(),
    );
  }

  Future<dynamic> comment(String comment, String rate) async {
    var res = await NetworkProvider.of(null).post(
      Constants.apiSetComment,
      {
        'spot_id': spot_id,
        'usr_id': Params.currentModel.usr_id,
        'content': comment,
        'rate': rate,
      },
    );
    return res;
  }

  Future<dynamic> like() async {
    var res = await NetworkProvider.of(null).post(
      Constants.apiSetLike,
      {
        'spot_id': spot_id,
        'usr_id': Params.currentModel.usr_id,
      },
    );
    return res;
  }

  void share() {
    Share.share(
      '$spot_name \n\n${spot_desc.isEmpty ? 'Tourlao spot share' : spot_desc}',
    );
  }

  String getRate() {
    var rate = '---';
    if (int.parse(cnt_comment) > 0) {
      rate = (double.parse(this.rate) / double.parse(cnt_comment))
          .toStringAsFixed(1);
    }
    return rate;
  }

  String getLikeCounter() {
    var counter = '---';
    try {
      var cntLike = int.parse(cnt_like);
      if (cntLike > 1000000) return '1M+';
      if (cntLike > 100000) return '100K+';
      if (cntLike > 10000) return '10K+';
      if (cntLike > 1000) return '1K+';
      if (cntLike > 100) return '100+';
      if (cntLike > 10) return '10+';
      if (cntLike > 5) return '5+';
      return '1+';
    } catch (e) {}
    return counter;
  }

  String getCommentCounter() {
    var counter = '---';
    try {
      var cnt = int.parse(cnt_comment);
      if (cnt > 1000000) return '1M+';
      if (cnt > 100000) return '100K+';
      if (cnt > 10000) return '10K+';
      if (cnt > 1000) return '1K+';
      if (cnt > 100) return '100+';
      if (cnt > 10) return '10+';
      if (cnt > 5) return '5+';
      return '1+';
    } catch (e) {}
    return counter;
  }

  Widget getListItem({
    Function() share,
    Function() comment,
    Function like,
  }) {
    var actionColors = [
      Colors.pink,
      Colors.purple,
      kPrimaryColor,
    ];
    var actionIcons = [
      is_like == 'true' ? Icons.favorite : Icons.favorite_outline,
      Icons.comment,
      Icons.share_sharp,
    ];
    var actionTexts = [
      cnt_like,
      cnt_comment,
      '',
    ];
    var rate = '---';
    if (int.parse(cnt_comment) > 0) {
      rate = (double.parse(this.rate) / double.parse(cnt_comment))
          .toStringAsFixed(1);
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 2.0, bottom: 20),
          child: CustomPaint(
            painter: SpotItemShadowPainter(),
            child: ClipPath(
              clipper: SpotItemClipper(),
              child: Container(
                width: double.infinity,
                height: 120.0,
                padding:
                    EdgeInsets.only(left: 120, top: 8, right: 8, bottom: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, kPrimaryColor.withOpacity(0.3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spot_name,
                      style: TourlaoText.bold(
                          color: Colors.white, fontSize: fontMd),
                    ),
                    Text(
                      spot_desc,
                      style: TourlaoText.medium(
                          color: Colors.white, fontSize: fontSm),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 18.0,
                        ),
                        SizedBox(
                          width: offsetXSm,
                        ),
                        Text(
                          rate,
                          style: TourlaoText.medium(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          width: 110.0,
          height: 110.0,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(offsetBase),
            border: Border.all(color: Colors.white),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(offsetBase),
            child: CachedNetworkImage(
              imageUrl:
                  'https://tourlao.laodev.info/uploads/spot/${spot_imgs != null ? spot_imgs.split('/')[0] : 'image_url'}',
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage('assets/images/landing.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Image.asset(
                'assets/images/landing.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        for (var i = 0; i < 3; i++) ...{
          Positioned(
            right: 22 + 32 * 1.5 * i,
            top: 99,
            child: Column(
              children: [
                Text(
                  actionTexts[i],
                  style: TourlaoText.medium(
                    fontSize: fontXSm,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 4.0,
                ),
                InkWell(
                  onTap: () {
                    switch (i) {
                      case 0:
                        if (like != null) like();
                        break;
                      case 1:
                        if (comment != null) comment();
                        break;
                      case 2:
                        if (share != null) share();
                        break;
                    }
                  },
                  child: Container(
                    width: 28.0,
                    height: 28.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.white, actionColors[i]],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(
                      actionIcons[i],
                      color: Colors.white,
                      size: 14.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        },
      ],
    );
  }
}

Path spotItemPath({
  @required Size size,
}) {
  const radius = 20.0;
  const avatar = 110.0;
  const avatarSm = 32.0;

  var path = Path();
  path.moveTo(0, size.height);
  path.lineTo(size.width - radius - avatarSm * 4, size.height);
  path.arcToPoint(
    Offset(size.width - radius - avatarSm * 3, size.height),
    radius: Radius.circular(avatarSm * 0.5),
    rotation: pi,
    clockwise: true,
  );
  path.lineTo(size.width - radius - avatarSm * 2.5, size.height);
  path.arcToPoint(
    Offset(size.width - radius - avatarSm * 1.5, size.height),
    radius: Radius.circular(avatarSm * 0.5),
    rotation: pi,
    clockwise: true,
  );
  path.lineTo(size.width - radius - avatarSm, size.height);
  path.arcToPoint(
    Offset(size.width - radius, size.height),
    radius: Radius.circular(avatarSm * 0.5),
    rotation: pi,
    clockwise: true,
  );
  path.quadraticBezierTo(
      size.width, size.height, size.width, size.height - radius);
  path.lineTo(size.width, radius);
  path.quadraticBezierTo(size.width, 0, size.width - radius, 0);
  path.lineTo(avatar + radius, 0);
  path.quadraticBezierTo(avatar, 0, avatar, radius);
  path.lineTo(avatar, size.height - radius * 2);
  path.quadraticBezierTo(
      avatar, size.height - radius, avatar - radius, size.height - radius);
  path.lineTo(radius, size.height - radius);
  path.quadraticBezierTo(0, size.height - radius, 0, size.height);
  path.close();

  return path;
}

class SpotItemClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = spotItemPath(size: size);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}

class SpotItemShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = spotItemPath(size: size);
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
