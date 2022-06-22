import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tourlao/providers/perf_provider.dart';

class LocalAuthProvider {
  LocalAuthentication auth;
  List<BiometricType> _availableBiometrics;
  bool _canCheckBiometrics;

  LocalAuthProvider();

  factory LocalAuthProvider.instance() {
    return LocalAuthProvider()..init();
  }

  Future<void> init() async {
    auth = LocalAuthentication();
    await _checkBiometrics();
    await _getAvailableBiometrics();
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    print('[Local Auth] canCheckBiometrics $canCheckBiometrics');
    this._canCheckBiometrics = canCheckBiometrics;
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    print('[Local Auth] availableBiometrics $availableBiometrics');
    this._availableBiometrics = availableBiometrics;
  }

  bool isEnabled() => _canCheckBiometrics;

  BiometricType availableType() {
    if (_availableBiometrics.contains(BiometricType.face))
      return BiometricType.face;
    if (_availableBiometrics.contains(BiometricType.fingerprint))
      return BiometricType.fingerprint;
    return null;
  }

  Future<bool> authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
          localizedReason:
              'Scan your fingerprint (or face or whatever) to authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);
    } on PlatformException catch (e) {
      print('[Local Auth] error ${e.message}');
      return null;
    }

    print('[Local Auth] auth : $authenticated');
    return authenticated;
  }

  Future<LocalAuthState> getState() async {
    if (!_canCheckBiometrics) return LocalAuthState.UNSUPPORT;
    if (availableType() == null) return LocalAuthState.UNSUPPORT;
    var enabled = await PrefProvider().isBioEnabled();
    if (!enabled) return LocalAuthState.DISABLE;
    var isBioAuth = await PrefProvider().isBioAuth();
    if (isBioAuth == null) return LocalAuthState.NONE;
    return isBioAuth? LocalAuthState.AUTH : LocalAuthState.NOAUTH;
  }
}

enum LocalAuthState {
  NONE,
  DISABLE,
  AUTH,
  NOAUTH,
  UNSUPPORT,
}
