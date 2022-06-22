import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tourlao/generated/l10n.dart';
import 'package:tourlao/providers/local_auth_provider.dart';
import 'package:tourlao/providers/navigator_provider.dart';
import 'package:tourlao/screens/auth/profile_screen.dart';
import 'package:tourlao/screens/main/favorite_screen.dart';
import 'package:tourlao/screens/main/home_screen.dart';
import 'package:tourlao/screens/notification_screen.dart';
import 'package:tourlao/screens/main/setting_screen.dart';
import 'package:tourlao/themes/colors.dart';
import 'package:tourlao/themes/dimens.dart';
import 'package:tourlao/themes/textstyles.dart';
import 'package:tourlao/utils/constants.dart';
import 'package:tourlao/widgets/appbar.dart';
import 'package:tourlao/widgets/bottom_widget.dart';
import 'package:tourlao/widgets/commons.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _selectedTap = 0;
  var _bottomBarTitle = [
    S.current.home,
    S.current.favorite,
    S.current.setting,
  ];

  List<Widget> _screens = [
    HomeScreen(),
    FavoriteScreen(),
    SettingScreen(),
  ];

  LocalAuthProvider _localAuth;

  @override
  void initState() {
    super.initState();
    _localAuth = LocalAuthProvider.instance();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      backImage: 'assets/images/landing_0${_selectedTap + 1}.jpg',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: kPrimaryColor,
        ),
        body: Stack(
          children: [
            _screens[_selectedTap],
            _headerView(),
            Align(
              alignment: Alignment.bottomCenter,
              child: _bottomView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerView() {
    return TourlaoAppBar(
      titleWidget: Text(
        _bottomBarTitle[_selectedTap],
        style: TourlaoText.bold(
          fontSize: fontXMd,
          color: Colors.white,
        ),
      ),
      prefix: InkWell(
        onTap: () => NavigatorProvider.of(context).pushToWidget(
          screen: ProfileScreen(
            authProvider: _localAuth,
          ),
        ),
        child: SvgPicture.asset(
          'assets/icons/ic_profile.svg',
          color: Colors.white,
        ),
      ),
      suffix: InkWell(
        onTap: () => NavigatorProvider.of(context).pushToWidget(
          screen: NotificationScreen(),
        ),
        child: SvgPicture.asset(
          'assets/icons/ic_notification.svg',
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _bottomView() {
    var bottomIcons = [
      Icon(
        Icons.home,
        color: Colors.white,
      ),
      Icon(
        Icons.favorite,
        color: Colors.white,
      ),
      Icon(
        Icons.settings,
        color: Colors.white,
      ),
    ];
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 17.0),
          child: ClipPath(
            clipper: BottomBarClipper(_selectedTap),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                height: kBottomBarHeight,
                color: kPrimaryColor.withOpacity(0.3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (var i = 0; i < 3; i++) ...{
                      i == _selectedTap
                          ? Container(
                              width: 42,
                            )
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedTap = i;
                                });
                              },
                              child: Container(
                                width: 42,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    bottomIcons[i],
                                    Text(
                                      _bottomBarTitle[i],
                                      style: TourlaoText.bold(
                                        fontSize: fontXSm,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                    },
                  ],
                ),
              ),
            ),
          ),
        ),
        _activeButton(),
      ],
    );
  }

  Widget _activeButton() {
    var bottomIcons = [
      Icon(
        Icons.home,
        color: Colors.white,
        size: 32.0,
      ),
      Icon(
        Icons.favorite,
        color: Colors.white,
        size: 32.0,
      ),
      Icon(
        Icons.settings,
        color: Colors.white,
        size: 32.0,
      ),
    ];

    var width = MediaQuery.of(context).size.width;
    switch (_selectedTap) {
      case 0:
        return Positioned(
          left: 37.0 * MediaQuery.of(context).size.width / 420.0,
          child: _buttonWidget(bottomIcons[_selectedTap]),
        );
      case 1:
        return Positioned(
          left: (width - (kBottomBarHeight - 3)) / 2,
          child: _buttonWidget(bottomIcons[_selectedTap]),
        );
      case 2:
        return Positioned(
          right: 37.0 * MediaQuery.of(context).size.width / 420.0,
          child: _buttonWidget(bottomIcons[_selectedTap]),
        );
    }
    return Positioned(
      left: 37.0,
      child: _buttonWidget(bottomIcons[0]),
    );
  }

  Widget _buttonWidget(Widget child) {
    return Container(
      width: kBottomBarHeight - 3,
      height: kBottomBarHeight - 3,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.white, kPrimaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: child,
      ),
    );
  }
}
