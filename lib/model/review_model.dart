import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tourlao/themes/dimens.dart';
import 'package:tourlao/themes/textstyles.dart';
import 'package:tourlao/utils/extensions.dart';

class ReviewModel {
  String id;
  String content;
  String rate;
  String usr_id;
  String usr_name;
  String usr_photo;
  String spot_id;
  String created_at;

  ReviewModel({
    this.id,
    this.content,
    this.rate,
    this.usr_id,
    this.usr_name,
    this.usr_photo,
    this.spot_id,
    this.created_at,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json["id"],
      content: json["content"],
      rate: json["rate"],
      usr_id: json["usr_id"],
      usr_name: json["usr_name"],
      usr_photo: json["usr_photo"],
      spot_id: json["spot_id"],
      created_at: json["created_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "rm_id": this.id,
      "rm_commnet": this.content,
      "rm_rate": this.rate,
      "usr_id": this.usr_id,
      "usr_name": this.usr_name,
      "usr_photo": this.usr_photo,
      "spot_id": this.spot_id,
      "updated_at": this.created_at,
    };
  }

  Widget getWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: offsetSm),
      padding: EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetSm),
      decoration: BoxDecoration(
        color: Colors.white30,
        border: Border.all(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(offsetBase),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var i = 0; i < 5; i++) ...{
                Icon(
                  int.parse(rate) > i ? Icons.star : Icons.star_outline,
                  color: Colors.yellow,
                  size: 18.0,
                ),
              },
              Spacer(),
              Text(
                created_at.currentTime,
                style:
                    TourlaoText.medium(color: Colors.white, fontSize: fontSm),
              ),
            ],
          ),
          SizedBox(
            height: offsetSm,
          ),
          Row(
            children: [
              Container(
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.0),
                  child: CachedNetworkImage(
                    imageUrl: usr_photo.isEmpty ? 'http' : usr_photo,
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
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.white),
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
              SizedBox(
                width: offsetBase,
              ),
              Text(
                usr_name,
                style: TourlaoText.bold(color: Colors.white, fontSize: fontMd),
              ),
            ],
          ),
          SizedBox(
            height: offsetSm,
          ),
          Text(
            content,
            style: TourlaoText.medium(color: Colors.white, fontSize: fontSm),
          ),
        ],
      ),
    );
  }
}
