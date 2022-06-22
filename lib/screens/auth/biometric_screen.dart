import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tourlao/generated/l10n.dart';
import 'package:tourlao/providers/local_auth_provider.dart';
import 'package:tourlao/providers/perf_provider.dart';
import 'package:tourlao/themes/colors.dart';
import 'package:tourlao/themes/dimens.dart';
import 'package:tourlao/themes/textstyles.dart';
import 'package:tourlao/utils/params.dart';
import 'package:tourlao/widgets/buttons.dart';

class BiometricScreen extends StatefulWidget {
  final LocalAuthProvider localProvider;
  final String password;

  const BiometricScreen({
    Key key,
    @required this.localProvider,
    @required this.password,
  }) : super(key: key);

  @override
  _BiometricScreenState createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        toolbarHeight: 0,
        elevation: 0,
        brightness: Brightness.dark,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 120.0,
                    height: 120.0,
                    padding: EdgeInsets.all(offsetLg),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      color: Colors.white30,
                    ),
                    child: SvgPicture.asset(
                      widget.localProvider.availableType() == BiometricType.face
                          ? 'assets/icons/ic_face_id.svg'
                          : 'assets/icons/ic_touch_id.svg',
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: offsetXLg,
                  ),
                  Text(
                    widget.localProvider.availableType() == BiometricType.face
                        ? S.current.enableFaceID
                        : S.current.enableTouchID,
                    style: TourlaoText.bold(
                      fontSize: fontLg,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: offsetSm,
                  ),
                  Text(
                    widget.localProvider.availableType() == BiometricType.face
                        ? S.current.signEasyFace
                        : S.current.signEasyTouch,
                    style: TourlaoText.medium(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: offsetXLg,
                  ),
                  InkWell(
                    onTap: () => _onClickEnable(),
                    child: TourlaoButtonWidget(
                      width: 250.0,
                      title: widget.localProvider.availableType() ==
                              BiometricType.face
                          ? S.current.setFaceID
                          : S.current.setTouchID,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: offsetXLg,
          ),
          InkWell(
            onTap: () => _onClickNotNow(),
            child: Text(
              S.current.notNow,
              style: TourlaoText.medium(
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
    );
  }

  void _onClickEnable() async {
    var res = await widget.localProvider.authenticateWithBiometrics();
    if (res != null && res) {
      await PrefProvider().setBioAuth(true);
      await PrefProvider().setEmail(Params.currentModel.usr_email);
      await PrefProvider().setPass(widget.password);
    } else {
      await PrefProvider().setBioAuth(false);
      await PrefProvider().setBioTime(DateTime.now());
    }
    Navigator.of(context).pop();
  }

  void _onClickNotNow() async {
    await PrefProvider().setBioAuth(false);
    await PrefProvider().setBioTime(DateTime.now());
    Navigator.of(context).pop();
  }
}
