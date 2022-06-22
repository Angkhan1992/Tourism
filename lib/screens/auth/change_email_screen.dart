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

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({Key key}) : super(key: key);

  @override
  _ChangeEmailScreenState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  ValueNotifier<ChangeEmailState> _event;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  var _code = '';
  var _email = '';

  @override
  void initState() {
    super.initState();
    _event = ValueNotifier(ChangeEmailState.NONE);
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      backImage: 'assets/images/landing_03.jpg',
      child: ValueListenableBuilder<ChangeEmailState>(
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
        icon: _event.value == ChangeEmailState.NONE
            ? Icon(
                Icons.email_outlined,
                color: Colors.white,
              )
            : ProcessingWidget(),
        title: S.current.changeEmail,
      ),
      prefix: InkWell(
        onTap: () {
          if (_event.value != ChangeEmailState.NONE) {
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
              hintText: S.current.newEmail,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Colors.white,
              ),
              validator: (email) {
                return email.validateEmail;
              },
              onSaved: (email) {
                _email = email.toLowerCase().trim();
              },
            ),
            SizedBox(
              height: offsetXMd,
            ),
            InkWell(
              onTap: () => _submit(),
              child: TourlaoButtonWidget(
                title: S.current.submit,
                isLoading: _event.value == ChangeEmailState.SUBMIT,
              ),
            ),
            Spacer(),
            Text(
              S.current.notGetEmail,
              style: TourlaoText.medium(
                color: Colors.white,
              ),
            ),
            _event.value == ChangeEmailState.NOTRECEIVE
                ? ProcessingWidget()
                : InkWell(
                    onTap: () => _resend(),
                    child: _event.value == ChangeEmailState.NOTRECEIVE
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
    if (_event.value != ChangeEmailState.NONE) {
      kShowProcessingDialog(context);
      return;
    }
    _formKey.currentState.save();
    _autoValidate = AutovalidateMode.always;
    if (!_formKey.currentState.validate()) {
      return;
    }
    if (_email == Params.currentModel.usr_email) {
      DialogProvider.of(context).showSnackBar(
        S.current.sameEmail,
        type: SnackBarType.ERROR,
      );
      return;
    }
    _event.value = ChangeEmailState.SUBMIT;
    var res = await NetworkProvider.of(context).post(
      Constants.apiChangeEmail,
      {
        'usr_id': Params.currentModel.usr_id,
        'old': Params.currentModel.usr_email,
        'new': _email,
        'code': _code,
      },
    );
    if (res['ret'] == 10000) {
      Params.currentModel = UserModel.fromJson(res['result']);
      await PrefProvider().setEmail(Params.currentModel.usr_email);
      NavigatorProvider.of(context).pushToWidget(
        screen: SuccessScreen(
          desc: S.current.changeEmailResult,
          iconData: Icons.email_outlined,
          title: S.current.changeEmail,
        ),
        replace: true,
      );
    } else {
      DialogProvider.of(context).showSnackBar(
        res['result'],
        type: SnackBarType.ERROR,
      );
    }
    _event.value = ChangeEmailState.NONE;
  }

  void _resend() async {
    if (_event.value != ChangeEmailState.NONE) {
      kShowProcessingDialog(context);
      return;
    }

    _event.value = ChangeEmailState.NOTRECEIVE;
    var res = await kSendCode(Params.currentModel.usr_email);
    if (res == null) {
      kShowSeverErrorDialog(context);
    } else {
      DialogProvider.of(context).showSnackBar(res);
    }
    _event.value = ChangeEmailState.NONE;
  }
}

enum ChangeEmailState {
  NONE,
  SUBMIT,
  NOTRECEIVE,
}
