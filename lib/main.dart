import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tourlao/screens/main_screen.dart';
import 'package:tourlao/themes/colors.dart';
import 'package:tourlao/themes/textstyles.dart';

import 'generated/l10n.dart';
import 'themes/dimens.dart';
import 'utils/constants.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TourLao',
      debugShowCheckedModeBanner: false,
      theme: getThemeData(),
      home: MainScreen(),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }

  ThemeData getThemeData() {
    return ThemeData(
      fontFamily: kFontFamily,
      brightness: Brightness.light,
      primaryColor: kPrimaryColor,
      secondaryHeaderColor: kSecondaryColor,
      scaffoldBackgroundColor: kScaffoldColor,
      accentColor: kPrimaryColor,
      backgroundColor: kPrimaryColor,
      hintColor: kHintColor,
      focusColor: kPrimaryColor,
      textTheme: TextTheme(
        headline1: TourlaoText.semiBold(fontSize: fontXLg),
        headline2: TourlaoText.semiBold(fontSize: fontLg),
        headline3: TourlaoText.bold(fontSize: fontXMd),
        headline4: TourlaoText.bold(fontSize: fontMd),
        headline5: TourlaoText.bold(fontSize: fontBase),
        headline6: TourlaoText.bold(fontSize: fontSm),
        subtitle1: TourlaoText.semiBold(fontSize: fontSm),
        subtitle2: TourlaoText.medium(fontSize: fontSm),
        bodyText1: TourlaoText.medium(fontSize: fontMd),
        bodyText2: kTextStyleMedium,
        caption: kTextStyleMedium,
        button: kTextStyleSemiBold,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: kButtonColor,
        titleTextStyle: TourlaoText.bold(fontSize: fontXMd),
        centerTitle: true,
      ),
      dividerTheme: DividerThemeData(
        color: kDividerColor,
        thickness: 0.5,
      ),
    );
  }
}
