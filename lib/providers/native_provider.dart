import 'package:flutter/services.dart';
import 'package:tourlao/utils/constants.dart';

class NativeProvider {
  static var platform_apple_sign =
      const MethodChannel('$PACKAGENAME/apple_sign');

  static Future<String> initAppleSign() async {
    print('init [APPLE]]');
    final result = await platform_apple_sign.invokeMethod('init', '');
    print('[APPLE] response:' + String.fromCharCodes(result));
    return String.fromCharCodes(result);
  }
}
