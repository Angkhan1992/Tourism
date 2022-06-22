import 'package:flutter/material.dart';
import 'package:tourlao/providers/navigator_provider.dart';
import 'package:tourlao/screens/main_screen.dart';
import 'package:tourlao/themes/colors.dart';
import 'package:tourlao/themes/dimens.dart';
import 'package:tourlao/themes/textstyles.dart';
import 'package:tourlao/utils/params.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      print('[User] ${Params.currentModel.toJson()}');
      NavigatorProvider.of(context).pushToWidget(screen: MainScreen(), replace: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 150.0,
              height: 150.0,
            ),
            SizedBox(
              height: offsetBase,
            ),
            Text(
              'TourLao Today',
              style:
                  TourlaoText.bold(fontSize: fontXLg, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
