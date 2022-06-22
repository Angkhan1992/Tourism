import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourlao/model/user_model.dart';
import 'package:tourlao/utils/constants.dart';
import 'package:tourlao/utils/extensions.dart';


class PrefProvider {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String> getToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(Constants.keyToken) ?? '';
  }

  Future setToken(String token) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(Constants.keyToken, token);
  }

  Future<UserModel> getUser() async {
    final SharedPreferences prefs = await _prefs;
    var userData = prefs.getString(Constants.keyUserData) ?? '';
    if (userData.isEmpty) return null;
    return UserModel.fromJson(jsonDecode(userData));
  }

  Future setUser(UserModel user) async {
    print('[SAVE] user ==> ${user.toJson()}');
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(Constants.keyUserData, jsonEncode(user.toJson()));
  }

  Future<bool> isBioAuth() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(Constants.keyBioAuth);
  }

  Future<void> removeBioAuth() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(Constants.keyBioAuth);
  }

  Future<void> setBioAuth(bool isAuth) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(Constants.keyBioAuth, isAuth);
  }

  Future<bool> isBioEnabled() async {
    final SharedPreferences prefs = await _prefs;
    var res = prefs.getBool(Constants.keyBioEnable);
    return res == null? true : res;
  }

  Future<void> setBioEnabled(bool isEnabled) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(Constants.keyBioEnable, isEnabled);
  }

  Future<String> getEmail() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(Constants.keyEmail);
  }

  Future setEmail(String email) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(Constants.keyEmail, email);
  }

  Future<String> getPass() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(Constants.keyPass);
  }

  Future setPass(String pass) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(Constants.keyPass, pass);
  }

  Future<DateTime> getBioTime() async {
    final SharedPreferences prefs = await _prefs;
    var time = prefs.getString(Constants.keyBioTime);
    if (time == null) return DateTime.now();
    return time.getFullDate;
  }

  Future setBioTime(DateTime time) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(Constants.keyPass, time.getFullTime);
  }

  Future<String> getLang() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(Constants.keyLang)??'EN';
  }

  Future setLang(String lang) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(Constants.keyLang, lang);
  }
}
