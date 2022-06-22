import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tourlao/themes/dimens.dart';
import 'package:tourlao/themes/textstyles.dart';

class SubTitleText extends Container {
  SubTitleText({
    String title,
    bool isLoaded = true,
  }) : super(
          margin: const EdgeInsets.symmetric(
              horizontal: offsetBase, vertical: offsetSm),
          padding:
              EdgeInsets.symmetric(horizontal: offsetBase, vertical: offsetXSm),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(offsetXMd),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: isLoaded? Text(
            title,
            style: TourlaoText.semiBold(
              color: Colors.white,
            ),
          ) : CupertinoActivityIndicator(radius: 12.0,),
        );
}
