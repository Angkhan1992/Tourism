import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tourlao/generated/l10n.dart';
import 'package:tourlao/model/user_model.dart';
import 'package:tourlao/providers/dialog_provider.dart';
import 'package:tourlao/providers/navigator_provider.dart';
import 'package:tourlao/providers/network_provider.dart';
import 'package:tourlao/providers/perf_provider.dart';
import 'package:tourlao/screens/success_screen.dart';
import 'package:tourlao/themes/colors.dart';
import 'package:tourlao/themes/dimens.dart';
import 'package:tourlao/themes/textstyles.dart';
import 'package:tourlao/utils/constants.dart';
import 'package:tourlao/utils/extensions.dart';
import 'package:tourlao/utils/params.dart';
import 'package:tourlao/widgets/appbar.dart';
import 'package:tourlao/widgets/buttons.dart';
import 'package:tourlao/widgets/commons.dart';
import 'package:tourlao/widgets/textfields.dart';

class ChangePassScreen extends StatefulWidget {
  const ChangePassScreen({Key key}) : super(key: key);

  @override
  _ChangePassScreenState createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> {
  ValueNotifier<ChangePassState> _event;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  var _code = '';
  var _pass = '';
  var _repass = '';

  var _isObSecure = true;
  var _isReObSecure = true;

  @override
  void initState() {
    super.initState();
    _event = ValueNotifier(ChangePassState.NONE);
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      backImage: 'assets/images/landing_03.jpg',
      child: ValueListenableBuilder<ChangePassState>(
        valueListenable: _event,
        builder: (context, event, widget) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              _autoValidate = AutovalidateMode.always;
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                toolbarHeight: 0,
                backgroundColor: kPrimaryColor,
              ),
              body: Stack(
                children: [
                  _contentView(),
                  _headerView(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _headerView() {
    return TourlaoAppBar(
      titleWidget: TitleWidget(
        icon: _event.value == ChangePassState.NONE
            ? Icon(
          Icons.lock_outline,
          color: Colors.white,
        )
            : ProcessingWidget(),
        title: S.current.changePass,
      ),
      prefix: InkWell(
        onTap: () {
          if (_event.value != ChangePassState.NONE) {
            kShowProcessingDialog(context);
            return;
          }
          Navigator.of(context).pop();
        },
        child: SvgPicture.asset(
          'assets/icons/ic_arrow_back.svg',
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _contentView() {
    return Form(
      key: _formKey,
      autovalidateMode: _autoValidate,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: offsetBase, vertical: offsetXMd),
        child: Column(
          children: [
            SizedBox(
              height: kAppbarHeight,
            ),
            TourlaoTextField(
              hintText: S.current.verifyCode,
              prefixIcon: Icon(
                Icons.code,
                color: Colors.white,
              ),
              onSaved: (code) {
                _code = code;
              },
              validator: (code) {
                return code.validateCode;
              },
            ),
            SizedBox(
              height: offsetBase,
            ),
            TourlaoTextField(
              hintText: S.current.password,
              keyboardType: TextInputType.visiblePassword,
              obscureText: _isObSecure,
              prefixIcon: Icon(
                Icons.lock_outline,
                color: Colors.white,
              ),
              validator: (pass) {
                return pass.validatePassword;
              },
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: offsetBase, vertical: offsetSm),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isObSecure = !_isObSecure;
                    });
                  },
                  child: SvgPicture.asset(
                    _isObSecure
                        ? 'assets/icons/ic_eye.svg'
                        : 'assets/icons/ic_eye_off.svg',
                    color: Colors.white,
                  ),
                ),
              ),
              onSaved: (pass) {
                _pass = pass;
              },
            ),
            SizedBox(
              height: offsetBase,
            ),
            TourlaoTextField(
              hintText: S.current.rePassword,
              keyboardType: TextInputType.visiblePassword,
              obscureText: _isReObSecure,
              prefixIcon: Icon(
                Icons.lock_outline,
                color: Colors.white,
              ),
              validator: (repass) {
                return repass.validatePassword;
              },
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: offsetBase, vertical: offsetSm),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isReObSecure = !_isReObSecure;
                    });
                  },
                  child: SvgPicture.asset(
                    _isReObSecure
                        ? 'assets/icons/ic_eye.svg'
                        : 'assets/icons/ic_eye_off.svg',
                    color: Colors.white,
                  ),
                ),
              ),
              onSaved: (repass) {
                _repass = repass;
              },
            ),
            SizedBox(
              height: offsetBase,
            ),
            InkWell(
              onTap: () => _submit(),
              child: TourlaoButtonWidget(
                title: S.current.submit,
                isLoading: _event.value == ChangePassState.SUBMIT,
              ),
            ),
            Spacer(),
            Text(
              S.current.notGetEmail,
              style: TourlaoText.medium(
                color: Colors.white,
              ),
            ),
            _event.value == ChangePassState.NOTRECEIVE
                ? ProcessingWidget()
                : InkWell(
                    onTap: () => _resend(),
                    child: _event.value == ChangePassState.NOTRECEIVE
                        ? ProcessingWidget()
                        : Text(
                            S.current.resendCode,
                            style: TourlaoText.bold(
                              fontSize: fontXMd,
                              color: Colors.white,
                            ).copyWith(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                  ),
            SizedBox(
              height: offsetXLg,
            ),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    if (_event.value != ChangePassState.NONE) {
      kShowProcessingDialog(context);
      return;
    }
    _formKey.currentState.save();
    _autoValidate = AutovalidateMode.always;

    if (_pass != _repass) {
      DialogProvider.of(context).showSnackBar(
        S.current.notMatchPass,
        type: SnackBarType.ERROR,
      );
      return;
    }

    _event.value = ChangePassState.SUBMIT;
    var res = await NetworkProvider.of(context).post(
      Constants.apiChangePass,
      {
        'usr_id': Params.currentModel.usr_id,
        'email': Params.currentModel.usr_email,
        'pass': _pass,
        'code': _code,
      },
    );
    if (res['ret'] == 10000) {
      Params.currentModel = UserModel.fromJson(res['result']);
      await PrefProvider().setPass(_pass);
      NavigatorProvider.of(context).pushToWidget(
        screen: SuccessScreen(
          desc: S.current.changePassResult,
          iconData: Icons.lock_outline,
          title: S.current.changePass,
        ),
        replace: true,
      );
    } else {
      DialogProvider.of(context).showSnackBar(
        res['result'],
        type: SnackBarType.ERROR,
      );
    }
    _event.value = ChangePassState.NONE;
  }

  void _resend() async {
    if (_event.value != ChangePassState.NONE) {
      kShowProcessingDialog(context);
      return;
    }

    _event.value = ChangePassState.NOTRECEIVE;
    var res = await kSendCode(Params.currentModel.usr_email);
    if (res == null) {
      kShowSeverErrorDialog(context);
    } else {
      DialogProvider.of(context).showSnackBar(res);
    }
    _event.value = ChangePassState.NONE;
  }
}

enum ChangePassState {
  NONE,
  SUBMIT,
  NOTRECEIVE,
}
