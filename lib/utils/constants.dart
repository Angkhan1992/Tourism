import 'package:flutter/cupertino.dart';
import 'package:tourlao/generated/l10n.dart';
import 'package:tourlao/providers/dialog_provider.dart';
import 'package:tourlao/providers/network_provider.dart';

const APPNAME = 'Tourlao';
const PACKAGENAME = 'com.kygabyte.tourlao';

const PRODUCTTEST = false;
const RELEASEBASEURL = 'https://tourlao.laodev.info/Backend/';
const DEBUGBASEURL = 'https://tourlao.laodev.info/Backend/';

const kAppbarHeight = 75.0;
const kBottomBarHeight = 60.0;

const kAppStoreLink = 'https://apps.apple.com/us/app/tourlao/id1599618169';
const kGoogleStoreLink = 'https://play.google.com/store/apps/details?id=com.kygabyte.tourlao';
const kFontFamily = 'Muli';

class Constants {
  static String keyToken = 'key_token';
  static String keyUserData = 'key_user_data';
  static String keyBioAuth = 'key_bio_auth';
  static String keyBioEnable = 'key_bio_enable';
  static String keyBioTime = 'key_bio_time';
  static String keyEmail = 'key_email';
  static String keyPass = 'key_pass';
  static String keyLang = 'key_lang';

  static String apiLogin = 'tourlao_login';
  static String apiRegister = 'tourlao_register';
  static String apiGetCategory = 'tourlao_get_all_cat';
  static String apiGetSpot = 'tourlao_cat_spot';
  static String apiSendCode = 'tourlao_send_code';
  static String apiChangeEmail = 'tourlao_change_email';
  static String apiChangePass = 'tourlao_change_pass';
  static String apiSocialLogin = 'tourlao_social_login';
  static String apiSetLike = 'tourlao_set_like';
  static String apiSetComment = 'tourlao_set_comment';
  static String apiFavSpot = 'tourlao_fav_spot';
  static String apiGetComment = 'tourlao_get_comment';
  static String apiGetNotification = 'tourlao_get_noti';
  static String apiAddFaq = 'tourlao_add_faq';
}

void kShowProcessingDialog(BuildContext context) {
  DialogProvider.of(context).showSnackBar(
    S.current.processingWaring,
    type: SnackBarType.WARING,
  );
}

void kShowSeverErrorDialog(BuildContext context) {
  DialogProvider.of(context).showSnackBar(
    S.current.serverError,
    type: SnackBarType.ERROR,
  );
}

Future<String> kSendCode(String email) async {
  var res = await NetworkProvider.of(null).post(
    Constants.apiSendCode,
    {
      'email': email,
    },
  );
  if (res == null || res['ret'] == null) return null;
  return res['ret'] == 10000 ? res['result'] : null;
}
