import 'package:flutter/material.dart';
import 'package:tourlao/themes/colors.dart';

bool isShowing = false;

class LoadingProvider {
  final BuildContext context;

  LoadingProvider(this.context);

  static LoadingProvider of(context) {
    return LoadingProvider(context);
  }

  bool hide() {
    if (context == null) {
      return true;
    }
    isShowing = false;
    Navigator.of(context).pop(true);
    return true;
  }

  bool show() {
    if (context == null) {
      return true;
    }
    isShowing = true;
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                kPrimaryColor,
              ),
            ),
          );
        },
        useRootNavigator: false);
    return true;
  }
}
