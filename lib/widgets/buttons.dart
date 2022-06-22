import 'package:flutter/material.dart';
import 'package:tourlao/themes/colors.dart';
import 'package:tourlao/themes/dimens.dart';
import 'package:tourlao/themes/textstyles.dart';
import 'package:tourlao/widgets/commons.dart';

class TourlaoButton extends StatelessWidget {
  final Color btnColor;
  final Color textColor;
  final double borderWidth;
  final String btnText;
  final Function onPressed;
  final Widget child;
  final Color focusColor;
  final Color splashColor;
  final Color hoverColor;
  final double height;
  final bool isLoading;
  final EdgeInsets margin;

  const TourlaoButton({
    Key key,
    this.btnText,
    this.child,
    this.focusColor,
    this.splashColor,
    this.hoverColor,
    this.height = dimenButtonHeight,
    this.btnColor = kPrimaryColor,
    this.borderWidth = 0.0,
    this.textColor = Colors.white,
    this.isLoading = false,
    this.margin = EdgeInsets.zero,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var actionColor = isLoading ? btnColor.withOpacity(0.75) : btnColor;
    return Container(
      margin: margin,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(offsetSm),
        border: Border.all(
          width: borderWidth,
          color: actionColor,
        ),
      ),
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(offsetSm),
        child: RaisedButton(
          focusColor: focusColor,
          splashColor: splashColor,
          hoverColor: hoverColor,
          elevation: 0.0,
          color: borderWidth > 0 ? Colors.white : actionColor,
          onPressed: onPressed,
          child: isLoading
              ? SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      borderWidth == 0 ? Colors.white : kButtonColor,
                    ),
                  ),
                )
              : child == null
                  ? Text(
                      btnText,
                      style: TourlaoText.semiBold(
                        fontSize: fontMd,
                        color: borderWidth > 0 ? actionColor : textColor,
                      ),
                    )
                  : child,
        ),
      ),
    );
  }
}

class TourlaoButtonWidget extends Container {
  TourlaoButtonWidget({
    @required String title,
    Color color = kPrimaryColor,
    double width = double.infinity,
    bool isLoading = false,
  }) : super(
          height: 48.0,
          width: width,
          padding: EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(color: color),
            color: color.withOpacity(0.5),
          ),
          alignment: Alignment.center,
          child: isLoading
              ? ProcessingWidget()
              : Text(
                  title,
                  style: TourlaoText.semiBold(
                    color: Colors.white,
                  ),
                ),
        );
}
