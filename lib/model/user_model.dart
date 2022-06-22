import 'package:flutter/cupertino.dart';
import 'package:tourlao/providers/network_provider.dart';
import 'package:tourlao/utils/constants.dart';

class UserModel {
  String usr_id;
  String usr_uid;
  String usr_name;
  String usr_email;
  String usr_pw;
  String usr_photo;
  String usr_country;
  String usr_phone;
  String usr_type;
  String usr_status;
  String usr_token;
  String create_at;
  String update_at;
  String del_flg;

  UserModel({
    this.usr_id,
    this.usr_uid,
    this.usr_name,
    this.usr_email,
    this.usr_pw,
    this.usr_photo,
    this.usr_country,
    this.usr_phone,
    this.usr_type,
    this.usr_status,
    this.usr_token,
    this.create_at,
    this.update_at,
    this.del_flg,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      usr_id: json["usr_id"],
      usr_uid: json["usr_uid"],
      usr_name: json["usr_name"],
      usr_email: json["usr_email"],
      usr_pw: json["usr_pw"],
      usr_photo: json["usr_photo"],
      usr_country: json["usr_country"],
      usr_phone: json["usr_phone"],
      usr_type: json["usr_type"],
      usr_status: json["usr_status"],
      usr_token: json["usr_token"],
      create_at: json["create_at"],
      update_at: json["update_at"],
      del_flg: json["del_flg"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "usr_id": this.usr_id,
      "usr_uid": this.usr_uid,
      "usr_name": this.usr_name,
      "usr_email": this.usr_email,
      "usr_pw": this.usr_pw,
      "usr_photo": this.usr_photo,
      "usr_country": this.usr_country,
      "usr_phone": this.usr_phone,
      "usr_type": this.usr_type,
      "usr_status": this.usr_status,
      "usr_token": this.usr_token,
      "create_at": this.create_at,
      "update_at": this.update_at,
      "del_flg": this.del_flg,
    };
  }

  Map<String, dynamic> toSingUpJson(String code) {
    return {
      "usr_name": this.usr_name,
      "usr_email": this.usr_email,
      "usr_pw": this.usr_pw,
      "code": code,
    };
  }

  Future<dynamic> register(String code) async {
    var res = await NetworkProvider.of(null).post(
      Constants.apiRegister,
      toSingUpJson(code),
    );
    return res;
  }

  static Future<dynamic> login({
    @required String email,
    @required String pass,
  }) async {
    var res = await NetworkProvider.of(null).post(
      Constants.apiLogin,
      {
        'usr_email': email,
        'usr_pw': pass,
      },
    );
    return res;
  }
}
