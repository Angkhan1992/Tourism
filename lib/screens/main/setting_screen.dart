import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share/share.dart';
import 'package:tourlao/generated/l10n.dart';
import 'package:tourlao/model/user_model.dart';
import 'package:tourlao/providers/local_auth_provider.dart';
import 'package:tourlao/providers/navigator_provider.dart';
import 'package:tourlao/providers/perf_provider.dart';
import 'package:tourlao/screens/auth/profile_screen.dart';
import 'package:tourlao/screens/contact_screen.dart';
import 'package:tourlao/themes/colors.dart';
import 'package:tourlao/themes/dimens.dart';
import 'package:tourlao/themes/textstyles.dart';
import 'package:tourlao/utils/constants.dart';
import 'package:tourlao/utils/params.dart';
import 'package:tourlao/widgets/buttons.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var _isLocalAuth = true;
  var _isLocalAuthStatus = true;
  LocalAuthProvider _localAuthProvider;
  var _isLangEN = true;

  @override
  void initState() {
    super.initState();
    _localAuthProvider = LocalAuthProvider.instance();
    Future.delayed(Duration(milliseconds: 300), () => _getData());
  }

  void _getData() async {
    var status = await _localAuthProvider.getState();
    if (status == LocalAuthState.UNSUPPORT) {
      _isLocalAuthStatus = false;
    } else {
      _isLocalAuth = status != LocalAuthState.DISABLE;
    }
    _isLangEN = (await PrefProvider().getLang()) == 'EN';

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var _settings = [
      {
        'title': S.current.localAuth,
        'detail': _isLocalAuthStatus
            ? S.current.localAuthSetting
            : S.current.localDisableSetting,
        'color': kPrimaryColor,
        'icon': SvgPicture.asset('assets/icons/ic_face_id.svg'),
        'future': _isLocalAuthStatus
            ? CupertinoSwitch(
                value: _isLocalAuth,
                onChanged: (value) async {
                  await PrefProvider().setBioEnabled(value);
                  setState(() {
                    _isLocalAuth = value;
                  });
                })
            : CupertinoSwitch(value: false, onChanged: (value) {}),
      },
      {
        'title': S.current.language,
        'detail': S.current.languageSetting,
        'color': Colors.purple,
        'icon': Icon(
          Icons.language,
          color: Colors.white,
          size: 20.0,
        ),
        'future': Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(offsetXSm),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () async {
                  await PrefProvider().setLang('EN');
                  setState(() {
                    _isLangEN = true;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: offsetSm,
                    vertical: offsetXSm,
                  ),
                  decoration: BoxDecoration(
                    color: _isLangEN ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(offsetXSm),
                  ),
                  child: Text(
                    'EN',
                    style: TourlaoText.bold(
                        color: _isLangEN ? Colors.black : Colors.white,
                        fontSize: fontSm),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await PrefProvider().setLang('ລາວ');
                  setState(() {
                    _isLangEN = false;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: offsetSm,
                    vertical: offsetXSm,
                  ),
                  decoration: BoxDecoration(
                    color: !_isLangEN ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(offsetXSm),
                  ),
                  child: Text(
                    'ລາວ',
                    style: TourlaoText.bold(
                        color: !_isLangEN ? Colors.black : Colors.white,
                        fontSize: fontSm),
                  ),
                ),
              ),
            ],
          ),
        ),
      },
      {
        'title': S.current.share,
        'detail': S.current.shareSetting,
        'color': Colors.pink,
        'icon': Icon(
          Icons.share,
          color: Colors.white,
          size: 20.0,
        ),
        'action': () =>
            Share.share('$APPNAME\n\n$kAppStoreLink\n$kGoogleStoreLink'),
      },
      {
        'title': S.current.contactUs,
        'detail': S.current.contactUsSetting,
        'color': Colors.green,
        'icon': Icon(
          Icons.help_outline,
          color: Colors.white,
          size: 20.0,
        ),
        'action': () =>
            NavigatorProvider.of(context).pushToWidget(screen: ContactScreen()),
      },
      {
        'title': S.current.information,
        'detail':
            '${S.current.applicationVersion}: 1.0\n${S.current.buildNumber}: 1',
        'color': Colors.blueAccent,
        'icon': Icon(
          Icons.settings,
          color: Colors.white,
          size: 20.0,
        ),
      }
    ];

    return Column(
      children: [
        SizedBox(
          height: kAppbarHeight,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var item in _settings) ...{
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: offsetBase,
                      vertical: offsetSm,
                    ),
                    child: InkWell(
                      onTap: item['action'],
                      child: Stack(
                        children: [
                          Positioned(
                            top: 14.0,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [Colors.white, item['color']],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.white30,
                                      blurRadius: 2.0,
                                      spreadRadius: 5.0),
                                ],
                              ),
                              child: item['icon'],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: CustomPaint(
                              painter: SettingPainter(),
                              child: ClipPath(
                                clipper: SettingClipper(),
                                child: Container(
                                  padding: EdgeInsets.only(
                                    left: offsetXLg,
                                    top: offsetSm,
                                    bottom: offsetSm,
                                    right: offsetSm,
                                  ),
                                  width: double.infinity,
                                  color: Colors.white30,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              item['title'],
                                              style: TourlaoText.semiBold(
                                                fontSize: fontMd,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: offsetSm,
                                            ),
                                            Text(
                                              item['detail'],
                                              style: TourlaoText.medium(
                                                color: Colors.white,
                                                fontSize: fontSm,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (item['future'] != null) ...{
                                        SizedBox(
                                          width: offsetXSm,
                                        ),
                                        item['future'],
                                      },
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                },
              ],
            ),
          ),
        ),
        SizedBox(
          height: offsetBase,
        ),
        Params.currentModel.usr_id == null
            ? InkWell(
                onTap: () => NavigatorProvider.of(context).pushToWidget(
                  screen: ProfileScreen(authProvider: _localAuthProvider),
                  pop: (v) => setState(() {}),
                ),
                child: TourlaoButtonWidget(
                  title: S.current.signIn,
                  width: 280.0,
                  color: kPrimaryColor,
                ),
              )
            : InkWell(
                onTap: () {
                  setState(() {
                    Params.currentModel = UserModel();
                  });
                },
                child: TourlaoButtonWidget(
                  title: S.current.logout,
                  width: 280.0,
                  color: Colors.red,
                ),
              ),
        SizedBox(
          height: kBottomBarHeight + offsetBase,
        ),
      ],
    );
  }
}

Path settingItemPath({
  @required Size size,
}) {
  const radius = 12.0;
  const iconLg = 44.0;

  var path = Path();
  path.moveTo(0, radius);
  path.arcToPoint(
    Offset(0, (radius + iconLg)),
    radius: Radius.circular(iconLg * 0.5),
    rotation: pi,
    clockwise: true,
  );
  path.lineTo(0, size.height - radius);
  path.quadraticBezierTo(
    0,
    size.height,
    radius,
    size.height,
  );
  path.lineTo(size.width - radius, size.height);
  path.quadraticBezierTo(
      size.width, size.height, size.width, size.height - radius);
  path.lineTo(size.width, radius);
  path.quadraticBezierTo(size.width, 0, size.width - radius, 0);
  path.lineTo(radius, 0);
  path.quadraticBezierTo(0, 0, 0, radius);
  path.close();

  return path;
}

class SettingClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = settingItemPath(size: size);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}

class SettingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = settingItemPath(size: size);
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
