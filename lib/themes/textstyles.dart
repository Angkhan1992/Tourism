import 'package:flutter/material.dart';
import 'package:tourlao/themes/colors.dart';
import 'package:tourlao/utils/constants.dart';

import 'dimens.dart';

const kTextStyleMedium = TextStyle(
  fontFamily: kFontFamily,
  color: kTextBlackColor,
  fontWeight: FontWeight.w400,
);

const kTextStyleSemiBold = TextStyle(
  fontFamily: kFontFamily,
  color: kTextBlackColor,
  fontWeight: FontWeight.w600,
);

const kTextStyleBold = TextStyle(
  fontFamily: kFontFamily,
  color: kTextBlackColor,
  fontWeight: FontWeight.w700,
);

class TourlaoText {
  static TextStyle medium({
    double fontSize = fontBase,
    Color color = kTextBlackColor,
  }) {
    return kTextStyleMedium.copyWith(
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle semiBold({
    double fontSize = fontBase,
    Color color = kTextBlackColor,
  }) {
    return kTextStyleSemiBold.copyWith(
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle bold({
    double fontSize = fontBase,
    Color color = kTextBlackColor,
  }) {
    return kTextStyleBold.copyWith(
      fontSize: fontSize,
      color: color,
    );
  }
}