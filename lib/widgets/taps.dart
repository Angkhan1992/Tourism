import 'package:flutter/material.dart';
import 'package:tourlao/themes/colors.dart';
import 'package:tourlao/themes/textstyles.dart';

class ProfileTapWidget extends Expanded {
  ProfileTapWidget({
    @required String title,
    @required bool selected,
    @required Function() onTap,
  }) : super(
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(22.0),
              ),
              alignment: Alignment.center,
              child: Text(
                title,
                style: TourlaoText.bold(
                  color: selected ? kPrimaryColor : Colors.white,
                ),
              ),
            ),
          ),
        );
}
