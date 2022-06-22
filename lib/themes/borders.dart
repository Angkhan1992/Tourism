import 'package:flutter/material.dart';
import 'package:tourlao/themes/colors.dart';

import 'dimens.dart';

OutlineInputBorder textFieldOutBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.white, width: 1.0),
  borderRadius: BorderRadius.all(Radius.circular(offsetSm)),
);

OutlineInputBorder textFieldDisableOutBorder = OutlineInputBorder(
  borderSide: BorderSide(color: kHintColor, width: 1.0),
  borderRadius: BorderRadius.all(Radius.circular(offsetSm)),
);

OutlineInputBorder textFieldErrorOutBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.red, width: 1.0),
  borderRadius: BorderRadius.all(Radius.circular(offsetSm)),
);