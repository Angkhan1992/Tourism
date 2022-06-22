import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xff006FC0);
const kSecondaryColor = Color(0xff006FC0);
const Color kScaffoldColor = Color(0xFFF8F8F8);
const Color kHintColor = Color(0xFFAAB2BA);
const Color kDividerColor = Color(0xFFDEDEDE);
const Color kButtonColor = Color(0xff006FC0);

const kTextBlackColor = Color(0xff232323);
const kTextWhiteColor = Color(0xffFFFFFF);

class TourlaoColor {
  static Color buttonColor({double opacity}) {
    if (opacity < 0 || opacity > 1) return kButtonColor;
    return kButtonColor.withOpacity(opacity);
  }

  static Color secondaryColor({double opacity}) {
    if (opacity < 0 || opacity > 1) return kSecondaryColor;
    return kSecondaryColor.withOpacity(opacity);
  }
}