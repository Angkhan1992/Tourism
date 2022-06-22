import 'package:flutter/material.dart';
import 'package:tourlao/themes/borders.dart';
import 'package:tourlao/themes/colors.dart';
import 'package:tourlao/themes/dimens.dart';
import 'package:tourlao/themes/textstyles.dart';

class TourlaoTextField extends TextFormField {
  TourlaoTextField({
    Key key,
    String hintText,
    Widget prefixIcon,
    Widget suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    Function(String) onSaved,
    Function(String) validator,
    Function(String) onSubmitted,
    Function() onTap,
    bool obscureText = false,
    bool readOnly = false,
    bool circleConner = false,
    bool isMemo = false,
    TextEditingController controller,
  }) : super(
          controller: controller,
          keyboardAppearance: Brightness.light,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          obscureText: obscureText,
          cursorColor: Colors.white,
          readOnly: readOnly,
          maxLines: isMemo ? 5 : 1,
          minLines: isMemo ? 5 : 1,
          style: TourlaoText.medium(
            fontSize: fontBase,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            contentPadding:
                isMemo ? EdgeInsets.all(offsetBase) : EdgeInsets.zero,
            hintText: hintText,
            hintStyle: TourlaoText.medium(
              fontSize: fontBase,
              color: Colors.white54,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: circleConner
                ? textFieldOutBorder.copyWith(
                    borderRadius: BorderRadius.all(Radius.circular(60.0)))
                : textFieldOutBorder,
            enabledBorder: circleConner
                ? textFieldOutBorder.copyWith(
                    borderRadius: BorderRadius.all(Radius.circular(60.0)))
                : textFieldOutBorder,
            focusedBorder: circleConner
                ? textFieldOutBorder.copyWith(
                    borderRadius: BorderRadius.all(Radius.circular(60.0)))
                : textFieldOutBorder,
            errorBorder: circleConner
                ? textFieldErrorOutBorder.copyWith(
                    borderRadius: BorderRadius.all(Radius.circular(60.0)))
                : textFieldErrorOutBorder,
            disabledBorder: circleConner
                ? textFieldDisableOutBorder.copyWith(
                    borderRadius: BorderRadius.all(Radius.circular(60.0)))
                : textFieldDisableOutBorder,
            focusedErrorBorder: circleConner
                ? textFieldDisableOutBorder.copyWith(
                    borderRadius: BorderRadius.all(Radius.circular(60.0)))
                : textFieldDisableOutBorder,
          ),
          onSaved: onSaved,
          validator: validator,
          onTap: onTap,
          onFieldSubmitted: onSubmitted,
        );
}
