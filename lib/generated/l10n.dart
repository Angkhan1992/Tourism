// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Tour Laos Today`
  String get tour_laos_today {
    return Intl.message(
      'Tour Laos Today',
      name: 'tour_laos_today',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Re-Password`
  String get rePassword {
    return Intl.message(
      'Re-Password',
      name: 'rePassword',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message(
      'Full Name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `Email is empty`
  String get emailEmpty {
    return Intl.message(
      'Email is empty',
      name: 'emailEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Email is not matched`
  String get emailNotMatch {
    return Intl.message(
      'Email is not matched',
      name: 'emailNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Remember`
  String get remember {
    return Intl.message(
      'Remember',
      name: 'remember',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `SIGN IN`
  String get signIn {
    return Intl.message(
      'SIGN IN',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Password is empty`
  String get passwordEmpty {
    return Intl.message(
      'Password is empty',
      name: 'passwordEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Password length should be more 6 characters`
  String get passwordLess {
    return Intl.message(
      'Password length should be more 6 characters',
      name: 'passwordLess',
      desc: '',
      args: [],
    );
  }

  /// `Visit TourLao`
  String get visitTourLao {
    return Intl.message(
      'Visit TourLao',
      name: 'visitTourLao',
      desc: '',
      args: [],
    );
  }

  /// `You don't have account yet?`
  String get haveNotAccount {
    return Intl.message(
      'You don\'t have account yet?',
      name: 'haveNotAccount',
      desc: '',
      args: [],
    );
  }

  /// `SIGN UP`
  String get signup {
    return Intl.message(
      'SIGN UP',
      name: 'signup',
      desc: '',
      args: [],
    );
  }

  /// `Agree`
  String get agree {
    return Intl.message(
      'Agree',
      name: 'agree',
      desc: '',
      args: [],
    );
  }

  /// `Term & Privacy Policy`
  String get termPrivacy {
    return Intl.message(
      'Term & Privacy Policy',
      name: 'termPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Username is empty`
  String get emptyName {
    return Intl.message(
      'Username is empty',
      name: 'emptyName',
      desc: '',
      args: [],
    );
  }

  /// `Verify code is empty`
  String get emptyCode {
    return Intl.message(
      'Verify code is empty',
      name: 'emptyCode',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to TourLao`
  String get welcomeTourLao {
    return Intl.message(
      'Welcome to TourLao',
      name: 'welcomeTourLao',
      desc: '',
      args: [],
    );
  }

  /// `Password is not matched`
  String get notMatchPass {
    return Intl.message(
      'Password is not matched',
      name: 'notMatchPass',
      desc: '',
      args: [],
    );
  }

  /// `Server Error! Please try after some delay`
  String get serverError {
    return Intl.message(
      'Server Error! Please try after some delay',
      name: 'serverError',
      desc: '',
      args: [],
    );
  }

  /// `Success Register!`
  String get successRegister {
    return Intl.message(
      'Success Register!',
      name: 'successRegister',
      desc: '',
      args: [],
    );
  }

  /// `Please read term and privacy and check`
  String get agreeRegister {
    return Intl.message(
      'Please read term and privacy and check',
      name: 'agreeRegister',
      desc: '',
      args: [],
    );
  }

  /// `Tourlao`
  String get home {
    return Intl.message(
      'Tourlao',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Favorite`
  String get favorite {
    return Intl.message(
      'Favorite',
      name: 'favorite',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get setting {
    return Intl.message(
      'Settings',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Top 10 Tourist`
  String get top10Place {
    return Intl.message(
      'Top 10 Tourist',
      name: 'top10Place',
      desc: '',
      args: [],
    );
  }

  /// `Found`
  String get found {
    return Intl.message(
      'Found',
      name: 'found',
      desc: '',
      args: [],
    );
  }

  /// `places`
  String get places {
    return Intl.message(
      'places',
      name: 'places',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Tomorrow`
  String get tomorrow {
    return Intl.message(
      'Tomorrow',
      name: 'tomorrow',
      desc: '',
      args: [],
    );
  }

  /// `Getting Data from server...`
  String get getData {
    return Intl.message(
      'Getting Data from server...',
      name: 'getData',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Verify Code`
  String get verifyCode {
    return Intl.message(
      'Verify Code',
      name: 'verifyCode',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Waring`
  String get waring {
    return Intl.message(
      'Waring',
      name: 'waring',
      desc: '',
      args: [],
    );
  }

  /// `Information`
  String get information {
    return Intl.message(
      'Information',
      name: 'information',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Processing..., Please try that later.`
  String get processingWaring {
    return Intl.message(
      'Processing..., Please try that later.',
      name: 'processingWaring',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `Please select one country`
  String get emptyCountry {
    return Intl.message(
      'Please select one country',
      name: 'emptyCountry',
      desc: '',
      args: [],
    );
  }

  /// `Country List`
  String get countryList {
    return Intl.message(
      'Country List',
      name: 'countryList',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Change Email`
  String get changeEmail {
    return Intl.message(
      'Change Email',
      name: 'changeEmail',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePass {
    return Intl.message(
      'Change Password',
      name: 'changePass',
      desc: '',
      args: [],
    );
  }

  /// `Login with Face ID`
  String get loginFaceID {
    return Intl.message(
      'Login with Face ID',
      name: 'loginFaceID',
      desc: '',
      args: [],
    );
  }

  /// `Login with Touch ID`
  String get loginTouchID {
    return Intl.message(
      'Login with Touch ID',
      name: 'loginTouchID',
      desc: '',
      args: [],
    );
  }

  /// `Enable Face ID`
  String get enableFaceID {
    return Intl.message(
      'Enable Face ID',
      name: 'enableFaceID',
      desc: '',
      args: [],
    );
  }

  /// `Enable Touch ID`
  String get enableTouchID {
    return Intl.message(
      'Enable Touch ID',
      name: 'enableTouchID',
      desc: '',
      args: [],
    );
  }

  /// `SignIn more easily after Face ID register`
  String get signEasyFace {
    return Intl.message(
      'SignIn more easily after Face ID register',
      name: 'signEasyFace',
      desc: '',
      args: [],
    );
  }

  /// `SignIn more easily after Touch ID register`
  String get signEasyTouch {
    return Intl.message(
      'SignIn more easily after Touch ID register',
      name: 'signEasyTouch',
      desc: '',
      args: [],
    );
  }

  /// `Set Face ID`
  String get setFaceID {
    return Intl.message(
      'Set Face ID',
      name: 'setFaceID',
      desc: '',
      args: [],
    );
  }

  /// `Set Touch ID`
  String get setTouchID {
    return Intl.message(
      'Set Touch ID',
      name: 'setTouchID',
      desc: '',
      args: [],
    );
  }

  /// `Not now`
  String get notNow {
    return Intl.message(
      'Not now',
      name: 'notNow',
      desc: '',
      args: [],
    );
  }

  /// `Choose Method`
  String get chooseMethod {
    return Intl.message(
      'Choose Method',
      name: 'chooseMethod',
      desc: '',
      args: [],
    );
  }

  /// `From Gallery`
  String get fromGallery {
    return Intl.message(
      'From Gallery',
      name: 'fromGallery',
      desc: '',
      args: [],
    );
  }

  /// `From Camera`
  String get fromCamera {
    return Intl.message(
      'From Camera',
      name: 'fromCamera',
      desc: '',
      args: [],
    );
  }

  /// `Permission Denied`
  String get permissionDenied {
    return Intl.message(
      'Permission Denied',
      name: 'permissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `Please choose avatar image`
  String get chooseAvatarImage {
    return Intl.message(
      'Please choose avatar image',
      name: 'chooseAvatarImage',
      desc: '',
      args: [],
    );
  }

  /// `Successful updated profile`
  String get successUpdateProfile {
    return Intl.message(
      'Successful updated profile',
      name: 'successUpdateProfile',
      desc: '',
      args: [],
    );
  }

  /// `New Email`
  String get newEmail {
    return Intl.message(
      'New Email',
      name: 'newEmail',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `If you didn't get any email yet?`
  String get notGetEmail {
    return Intl.message(
      'If you didn\'t get any email yet?',
      name: 'notGetEmail',
      desc: '',
      args: [],
    );
  }

  /// `Resend Code`
  String get resendCode {
    return Intl.message(
      'Resend Code',
      name: 'resendCode',
      desc: '',
      args: [],
    );
  }

  /// `These emails are same. Please input other email`
  String get sameEmail {
    return Intl.message(
      'These emails are same. Please input other email',
      name: 'sameEmail',
      desc: '',
      args: [],
    );
  }

  /// `Your email was already changed successfully.`
  String get changeEmailResult {
    return Intl.message(
      'Your email was already changed successfully.',
      name: 'changeEmailResult',
      desc: '',
      args: [],
    );
  }

  /// `Your password was already changed successfully.`
  String get changePassResult {
    return Intl.message(
      'Your password was already changed successfully.',
      name: 'changePassResult',
      desc: '',
      args: [],
    );
  }

  /// `Failed a social account sign, Please use other way or account`
  String get errorSocialSign {
    return Intl.message(
      'Failed a social account sign, Please use other way or account',
      name: 'errorSocialSign',
      desc: '',
      args: [],
    );
  }

  /// `You need to login for this feature`
  String get requestLogin {
    return Intl.message(
      'You need to login for this feature',
      name: 'requestLogin',
      desc: '',
      args: [],
    );
  }

  /// `You added a comment successfully`
  String get successComment {
    return Intl.message(
      'You added a comment successfully',
      name: 'successComment',
      desc: '',
      args: [],
    );
  }

  /// `You set a like successfully`
  String get successLike {
    return Intl.message(
      'You set a like successfully',
      name: 'successLike',
      desc: '',
      args: [],
    );
  }

  /// `Your favorite list is empty`
  String get emptyFav {
    return Intl.message(
      'Your favorite list is empty',
      name: 'emptyFav',
      desc: '',
      args: [],
    );
  }

  /// `Spot Comment`
  String get spotComment {
    return Intl.message(
      'Spot Comment',
      name: 'spotComment',
      desc: '',
      args: [],
    );
  }

  /// `Please add your feeling for this spot.`
  String get spotCommentDesc {
    return Intl.message(
      'Please add your feeling for this spot.',
      name: 'spotCommentDesc',
      desc: '',
      args: [],
    );
  }

  /// `The comment content is empty.`
  String get emptyComment {
    return Intl.message(
      'The comment content is empty.',
      name: 'emptyComment',
      desc: '',
      args: [],
    );
  }

  /// `You add a review successfully`
  String get addCommentSuccess {
    return Intl.message(
      'You add a review successfully',
      name: 'addCommentSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Reviews`
  String get reviews {
    return Intl.message(
      'Reviews',
      name: 'reviews',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message(
      'City',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `Province`
  String get province {
    return Intl.message(
      'Province',
      name: 'province',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Contacts`
  String get contacts {
    return Intl.message(
      'Contacts',
      name: 'contacts',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Fax`
  String get fax {
    return Intl.message(
      'Fax',
      name: 'fax',
      desc: '',
      args: [],
    );
  }

  /// `Google Map`
  String get googleMap {
    return Intl.message(
      'Google Map',
      name: 'googleMap',
      desc: '',
      args: [],
    );
  }

  /// `Recent Reviews`
  String get recentReview {
    return Intl.message(
      'Recent Reviews',
      name: 'recentReview',
      desc: '',
      args: [],
    );
  }

  /// `Show All`
  String get showAll {
    return Intl.message(
      'Show All',
      name: 'showAll',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Tourlao`
  String get notiRegister {
    return Intl.message(
      'Welcome to Tourlao',
      name: 'notiRegister',
      desc: '',
      args: [],
    );
  }

  /// `You login to Tourlao`
  String get notiLogin {
    return Intl.message(
      'You login to Tourlao',
      name: 'notiLogin',
      desc: '',
      args: [],
    );
  }

  /// `You added like to spot`
  String get notiLike {
    return Intl.message(
      'You added like to spot',
      name: 'notiLike',
      desc: '',
      args: [],
    );
  }

  /// `You remove like from spot`
  String get notiUnlike {
    return Intl.message(
      'You remove like from spot',
      name: 'notiUnlike',
      desc: '',
      args: [],
    );
  }

  /// `You added comment to spot`
  String get notiComment {
    return Intl.message(
      'You added comment to spot',
      name: 'notiComment',
      desc: '',
      args: [],
    );
  }

  /// `Not existed your notifications`
  String get emptyNoti {
    return Intl.message(
      'Not existed your notifications',
      name: 'emptyNoti',
      desc: '',
      args: [],
    );
  }

  /// `Your content is empty`
  String get emptyContent {
    return Intl.message(
      'Your content is empty',
      name: 'emptyContent',
      desc: '',
      args: [],
    );
  }

  /// `Local Auth`
  String get localAuth {
    return Intl.message(
      'Local Auth',
      name: 'localAuth',
      desc: '',
      args: [],
    );
  }

  /// `You can login more easily using Local Auth`
  String get localAuthSetting {
    return Intl.message(
      'You can login more easily using Local Auth',
      name: 'localAuthSetting',
      desc: '',
      args: [],
    );
  }

  /// `Your device is not support this feature`
  String get localDisableSetting {
    return Intl.message(
      'Your device is not support this feature',
      name: 'localDisableSetting',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `You can choose primary language with EN / ລາວ.`
  String get languageSetting {
    return Intl.message(
      'You can choose primary language with EN / ລາວ.',
      name: 'languageSetting',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `You can share TourLao appstore links to your friends.`
  String get shareSetting {
    return Intl.message(
      'You can share TourLao appstore links to your friends.',
      name: 'shareSetting',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message(
      'Contact Us',
      name: 'contactUs',
      desc: '',
      args: [],
    );
  }

  /// `You can commit some your questions or problems.`
  String get contactUsSetting {
    return Intl.message(
      'You can commit some your questions or problems.',
      name: 'contactUsSetting',
      desc: '',
      args: [],
    );
  }

  /// `Application version`
  String get applicationVersion {
    return Intl.message(
      'Application version',
      name: 'applicationVersion',
      desc: '',
      args: [],
    );
  }

  /// `Build Number`
  String get buildNumber {
    return Intl.message(
      'Build Number',
      name: 'buildNumber',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `We just received your message successfully`
  String get faqContent {
    return Intl.message(
      'We just received your message successfully',
      name: 'faqContent',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
      Locale.fromSubtags(languageCode: 'la'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}