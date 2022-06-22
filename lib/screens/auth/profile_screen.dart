import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tourlao/generated/l10n.dart';
import 'package:tourlao/model/user_model.dart';
import 'package:tourlao/providers/dialog_provider.dart';
import 'package:tourlao/providers/json_provider.dart';
import 'package:tourlao/providers/local_auth_provider.dart';
import 'package:tourlao/providers/native_provider.dart';
import 'package:tourlao/providers/navigator_provider.dart';
import 'package:tourlao/providers/network_provider.dart';
import 'package:tourlao/providers/perf_provider.dart';
import 'package:tourlao/screens/auth/biometric_screen.dart';
import 'package:tourlao/screens/auth/change_email_screen.dart';
import 'package:tourlao/screens/auth/change_pass_screen.dart';
import 'package:tourlao/themes/colors.dart';
import 'package:tourlao/themes/dimens.dart';
import 'package:tourlao/themes/textstyles.dart';
import 'package:tourlao/utils/constants.dart';
import 'package:tourlao/utils/params.dart';
import 'package:tourlao/widgets/appbar.dart';
import 'package:tourlao/widgets/buttons.dart';
import 'package:tourlao/widgets/commons.dart';
import 'package:tourlao/widgets/taps.dart';
import 'package:tourlao/widgets/textfields.dart';
import 'package:tourlao/utils/extensions.dart';

class ProfileScreen extends StatefulWidget {
  final LocalAuthProvider authProvider;

  const ProfileScreen({
    Key key,
    @required this.authProvider,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _isLogin = true;
  ValueNotifier<ProfileEvent> _event;

  GlobalKey<FormState> _formLoginKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formRegisterKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formProfileKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  var _isObSecure = true;
  var _isReObSecure = true;
  var _isEditing = false;

  var _name = '';
  var _email = '';
  var _country = '';
  var _avatar = '';
  var _code = '';
  var _pass = '';
  var _repass = '';

  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _codeController = TextEditingController();
  var _passController = TextEditingController();
  var _repassController = TextEditingController();
  var _countryController = TextEditingController();
  var _countryData = {};

  LocalAuthState _bioStatus;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    print('[User] ${Params.currentModel.toJson()}');
    _event = ValueNotifier(ProfileEvent.NONE);
    Timer.run(() => _getData());

    _countryController.addListener(() {
      _autoValidate = AutovalidateMode.disabled;
    });
  }

  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
    _emailController.dispose();
    _codeController.dispose();
    _passController.dispose();
    _repassController.dispose();
    _countryController.dispose();
  }

  void _pickImage({
    bool isCamera = true,
  }) async {
    Navigator.of(context).pop();
    var _image = await _picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
    );

    if (_image != null) {
      setState(() {
        _avatar = _image.path;
      });
    }
  }

  void _initFields() {
    _nameController.text = '';
    _emailController.text = '';
    _codeController.text = '';
    _passController.text = '';
    _repassController.text = '';
    _countryController.text = '';
    _isObSecure = true;
    _isReObSecure = true;
    _autoValidate = AutovalidateMode.disabled;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      backImage: 'assets/images/landing_02.jpg',
      child: ValueListenableBuilder<ProfileEvent>(
        valueListenable: _event,
        builder: (context, event, widget) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              _autoValidate = AutovalidateMode.always;
            },
            child: Scaffold(
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
        icon: _event.value == ProfileEvent.NONE
            ? SvgPicture.asset(
                'assets/icons/ic_profile.svg',
                color: Colors.white,
              )
            : ProcessingWidget(),
        title: S.current.profile,
      ),
      prefix: InkWell(
        onTap: () {
          if (_event.value != ProfileEvent.NONE) {
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
      suffix: Params.currentModel.usr_id != null
          ? InkWell(
              onTap: () {
                setState(() {
                  _isEditing = !_isEditing;
                });
              },
              child: Icon(
                !_isEditing ? Icons.edit_rounded : Icons.check,
                color: Colors.white,
              ),
            )
          : null,
    );
  }

  Widget _contentView() {
    return Params.currentModel.usr_email != null
        ? _profileForm()
        : ListView(
            children: [
              SizedBox(
                height: kAppbarHeight,
              ),
              Image.asset(
                'assets/images/logo.png',
                width: 120.0,
                height: 120.0,
              ),
              SizedBox(
                height: offsetXLg,
              ),
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: offsetXMd, horizontal: offsetBase),
                    child: CustomPaint(
                      painter: SignBackPainter(),
                      child: ClipPath(
                        clipper: SignBackClipper(),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: offsetBase,
                            vertical: 56,
                          ),
                          width: double.infinity,
                          color: Colors.white24,
                          child: _isLogin ? _loginForm() : _registerForm(),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 48.0,
                      width: 280.0,
                      padding: EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(color: Colors.white),
                        color: Colors.white24,
                      ),
                      child: Row(
                        children: [
                          ProfileTapWidget(
                            onTap: () {
                              _isLogin = true;
                              _initFields();
                            },
                            selected: _isLogin,
                            title: S.current.signIn,
                          ),
                          ProfileTapWidget(
                            onTap: () {
                              _isLogin = false;
                              _initFields();
                            },
                            selected: !_isLogin,
                            title: S.current.signup,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: () => _onClick(),
                        child: TourlaoButtonWidget(
                          width: 280.0,
                          title: _isLogin ? S.current.signIn : S.current.signup,
                          isLoading: _event.value == ProfileEvent.SIGN,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: offsetXMd,),
            ],
          );
  }

  Widget _loginForm() {
    return Form(
      key: _formLoginKey,
      autovalidateMode: _autoValidate,
      child: Column(
        children: [
          TourlaoTextField(
            controller: _emailController,
            hintText: S.current.email,
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
            height: offsetBase,
          ),
          TourlaoTextField(
            controller: _passController,
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
            height: offsetSm,
          ),
          Row(
            children: [
              Spacer(),
              Text(
                S.current.forgotPassword,
                style: TourlaoText.medium(fontSize: fontSm, color: Colors.white)
                    .copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          SizedBox(
            height: offsetXLg,
          ),
          if (_bioStatus != null && _bioStatus == LocalAuthState.AUTH)
            InkWell(
              onTap: () => _getData(),
              child: widget.authProvider.availableType() == BiometricType.face
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_face_id.svg',
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: offsetBase,
                        ),
                        Text(
                          S.current.loginFaceID,
                          style: TourlaoText.semiBold(color: Colors.white),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_touch_id.svg',
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: offsetBase,
                        ),
                        Text(
                          S.current.loginTouchID,
                          style: TourlaoText.semiBold(color: Colors.white),
                        ),
                      ],
                    ),
            ),
          SizedBox(
            height: offsetXLg,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _event.value == ProfileEvent.APPLE
                  ? ProcessingWidget()
                  : InkWell(
                      onTap: () => _loginWithApple(),
                      child: SvgPicture.asset(
                        'assets/icons/ic_apple.svg',
                        width: 48.0,
                        height: 48.0,
                      ),
                    ),
              SizedBox(
                width: offsetXLg,
              ),
              _event.value == ProfileEvent.FACEBOOK
                  ? ProcessingWidget()
                  : InkWell(
                      onTap: () => _loginWithFacebook(),
                      child: SvgPicture.asset(
                        'assets/icons/ic_facebook.svg',
                        width: 48.0,
                        height: 48.0,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _registerForm() {
    return Form(
      key: _formRegisterKey,
      autovalidateMode: _autoValidate,
      child: Column(
        children: [
          TourlaoTextField(
            controller: _nameController,
            hintText: S.current.fullName,
            prefixIcon: Icon(
              Icons.account_circle_outlined,
              color: Colors.white,
            ),
            onSaved: (name) {
              _name = name;
            },
            validator: (name) {
              return name.validateName;
            },
          ),
          SizedBox(
            height: offsetBase,
          ),
          TourlaoTextField(
            controller: _emailController,
            hintText: S.current.email,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(
              Icons.email_outlined,
              color: Colors.white,
            ),
            onSaved: (email) {
              _email = email.toLowerCase().trim();
            },
            validator: (email) {
              return email.validateEmail;
            },
          ),
          SizedBox(
            height: offsetBase,
          ),
          Row(
            children: [
              Expanded(
                child: TourlaoTextField(
                  controller: _codeController,
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
              ),
              SizedBox(
                width: offsetBase,
              ),
              InkWell(
                onTap: () => _sendCode(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: offsetBase,
                    vertical: offsetSm,
                  ),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.5),
                    border: Border.all(color: kPrimaryColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: _event.value == ProfileEvent.SENDCODE
                      ? ProcessingWidget(
                          size: 18.0,
                        )
                      : Text(
                          S.current.send,
                          style: TourlaoText.bold(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: offsetBase,
          ),
          TourlaoTextField(
            controller: _passController,
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
            controller: _repassController,
            hintText: S.current.rePassword,
            keyboardType: TextInputType.visiblePassword,
            obscureText: _isReObSecure,
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
        ],
      ),
    );
  }

  Widget _profileForm() {
    return Container(
      padding: EdgeInsets.only(
        top: offsetXLg,
        left: offsetBase,
        right: offsetBase,
        bottom: offsetXMd,
      ),
      child: Column(
        children: [
          SizedBox(
            height: offsetXLg,
          ),
          Container(
            width: 120.0,
            height: 120.0,
            child: Stack(
              children: [
                Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60.0),
                    child: _avatar.contains('http')
                        ? CachedNetworkImage(
                            imageUrl: _avatar,
                            height: double.infinity,
                            placeholder: (context, url) => Stack(
                              children: [
                                EmptyAvatar(),
                                Center(
                                  child: ProcessingWidget(),
                                ),
                              ],
                            ),
                            errorWidget: (context, url, error) => EmptyAvatar(),
                            fit: BoxFit.cover,
                          )
                        : _avatar.isEmpty
                            ? EmptyAvatar()
                            : Image.file(
                                File(_avatar),
                                fit: BoxFit.cover,
                              ),
                  ),
                ),
                if (_isEditing)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () => _showImagePicker(),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.white, kPrimaryColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.camera_sharp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: offsetXMd,
          ),
          Form(
            key: _formProfileKey,
            autovalidateMode: _autoValidate,
            child: Column(
              children: [
                TourlaoTextField(
                  controller: _nameController,
                  hintText: S.current.fullName,
                  readOnly: !_isEditing,
                  prefixIcon: Icon(
                    Icons.account_circle_outlined,
                    color: Colors.white,
                  ),
                  validator: (name) {
                    return name.validateName;
                  },
                  onSaved: (name) {
                    _name = name;
                  },
                ),
                SizedBox(
                  height: offsetBase,
                ),
                TourlaoTextField(
                  controller: _emailController,
                  hintText: S.current.email,
                  readOnly: true,
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
                  height: offsetBase,
                ),
                TourlaoTextField(
                  controller: _countryController,
                  hintText: S.current.country,
                  readOnly: true,
                  prefixIcon: Icon(
                    Icons.language,
                    color: Colors.white,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                  validator: (country) {
                    return country.validateCountry;
                  },
                  onSaved: (country) {
                    _country = country;
                  },
                  onTap: () {
                    if (_isEditing) {
                      _showCountryPicker();
                    }
                  },
                ),
                SizedBox(
                  height: offsetBase,
                ),
              ],
            ),
          ),
          if (_isEditing) ...{
            InkWell(
              onTap: () => _updateProfile(),
              child: TourlaoButtonWidget(
                title: S.current.update,
                isLoading: _event.value == ProfileEvent.UPDATE,
              ),
            ),
            SizedBox(
              height: offsetXLg,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _changeEmail(),
                    child: TourlaoButtonWidget(
                      title: S.current.changeEmail,
                      color: Colors.pink,
                      isLoading: _event.value == ProfileEvent.EMAIL,
                    ),
                  ),
                ),
                SizedBox(
                  width: offsetBase,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => _changePass(),
                    child: TourlaoButtonWidget(
                      title: S.current.changePass,
                      color: Colors.purple,
                      isLoading: _event.value == ProfileEvent.PASSWORD,
                    ),
                  ),
                ),
              ],
            ),
          }
        ],
      ),
    );
  }

  void _onClick() async {
    if (_event.value != ProfileEvent.NONE) {
      kShowProcessingDialog(context);
      return;
    }

    _autoValidate = AutovalidateMode.always;
    if (_isLogin) {
      _formLoginKey.currentState.save();
      if (!_formLoginKey.currentState.validate()) {
        return;
      }
      _event.value = ProfileEvent.SIGN;
      var res = await UserModel.login(email: _email, pass: _pass);
      if (res['ret'] == 10000) {
        Params.currentModel = UserModel.fromJson(res['result']);
        _checkBiometric();
      } else {
        DialogProvider.of(context).showSnackBar(
          res['result'],
          type: SnackBarType.ERROR,
        );
      }
      _event.value = ProfileEvent.NONE;
    } else {
      _formRegisterKey.currentState.save();
      if (!_formRegisterKey.currentState.validate()) {
        return;
      }
      if (_pass != _repass) {
        DialogProvider.of(context).showSnackBar(
          S.current.notMatchPass,
          type: SnackBarType.ERROR,
        );
        return;
      }
      UserModel user = UserModel();
      user.usr_email = _email;
      user.usr_name = _name;
      user.usr_pw = _pass;

      _event.value = ProfileEvent.SIGN;
      var res = await user.register(_code);
      if (res['ret'] == 10000) {
        Params.currentModel = UserModel.fromJson(res['result']);
        _checkBiometric();
      } else {
        DialogProvider.of(context).showSnackBar(
          res['result'],
          type: SnackBarType.ERROR,
        );
      }
      _event.value = ProfileEvent.NONE;
    }
  }

  void _checkBiometric() async {
    if (_bioStatus == LocalAuthState.NONE) {
      NavigatorProvider.of(context).pushToWidget(
        screen: BiometricScreen(
          localProvider: widget.authProvider,
          password: _pass,
        ),
        pop: (v) => _getData(),
      );
    } else if (_bioStatus == LocalAuthState.NOAUTH) {
      var savedTime = await PrefProvider().getBioTime();
      var currentTime = DateTime.now();
      if (currentTime.isAfter(savedTime.add(Duration(days: 3)))) {
        NavigatorProvider.of(context).pushToWidget(
          screen: BiometricScreen(
            localProvider: widget.authProvider,
            password: _pass,
          ),
          pop: (v) => _getData(),
        );
      } else {
        _getData();
      }
    } else {
      _getData();
    }
  }

  void _sendCode() async {
    if (_event.value != ProfileEvent.NONE) {
      kShowProcessingDialog(context);
      return;
    }

    _formRegisterKey.currentState.save();
    if (_email.validateEmail != null) {
      DialogProvider.of(context).showSnackBar(
        S.current.emailNotMatch,
        type: SnackBarType.INFO,
      );
      return;
    }
    _event.value = ProfileEvent.SENDCODE;
    var _isSendCode = await kSendCode(_email);
    if (_isSendCode == null) {
      kShowSeverErrorDialog(context);
    } else {
      DialogProvider.of(context).showSnackBar(_isSendCode);
    }
    _event.value = ProfileEvent.NONE;
  }

  void _getData() async {
    if (Params.currentModel.usr_email != null) {
      _countryData = await JsonProvider.loadAssetCountry();
      _nameController.text = Params.currentModel.usr_name;
      _emailController.text = Params.currentModel.usr_email;
      _countryController.text = Params.currentModel.usr_country;
      _avatar = Params.currentModel.usr_photo;

      setState(() {});
    } else {
      _bioStatus = await widget.authProvider.getState();
      print('[Local Auth] enabled : $_bioStatus');
      if (_bioStatus == LocalAuthState.AUTH) {
        await Future.delayed(Duration(milliseconds: 300));
        var bioResult = await widget.authProvider.authenticateWithBiometrics();
        if (bioResult != null && bioResult) {
          var email = await PrefProvider().getEmail();
          var pass = await PrefProvider().getPass();
          if (email == null || pass == null) {
            await PrefProvider().removeBioAuth();
          }
          _event.value = ProfileEvent.SIGN;
          var res = await UserModel.login(email: email, pass: pass);
          if (res['ret'] == 10000) {
            Params.currentModel = UserModel.fromJson(res['result']);
            _event.value = ProfileEvent.NONE;
            _getData();
          }
        } else {
          setState(() {});
        }
      }
    }
  }

  void _showImagePicker() async {
    var permission = await checkImagePermission();
    if (permission) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(offsetXMd),
                topRight: Radius.circular(offsetXMd),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 4),
                  height: 4,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.0),
                    color: kHintColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    S.current.chooseMethod,
                    style: TourlaoText.bold(fontSize: fontXMd),
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: () => _pickImage(isCamera: false),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Spacer(),
                              Icon(Icons.image_outlined),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: offsetBase,
                        ),
                        Expanded(
                          child: Text(
                            S.current.fromGallery,
                            style: TourlaoText.semiBold(fontSize: fontMd),
                          ),
                          flex: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _pickImage(isCamera: true),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Spacer(),
                              Icon(Icons.camera_alt_outlined),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: offsetBase,
                        ),
                        Expanded(
                          child: Text(
                            S.current.fromCamera,
                            style: TourlaoText.semiBold(fontSize: fontMd),
                          ),
                          flex: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: offsetXMd,
                ),
              ],
            ),
          );
        },
      );
    } else {
      DialogProvider.of(context).showSnackBar(
        S.current.permissionDenied,
        type: SnackBarType.INFO,
      );
    }
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(offsetXMd),
                topRight: Radius.circular(offsetXMd),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 4),
                  height: 4,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.0),
                    color: kHintColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    S.current.countryList,
                    style: TourlaoText.bold(fontSize: fontXMd),
                  ),
                ),
                Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var key in _countryData.keys) ...{
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              _countryController.text = _countryData[key];
                              setState(() {});
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: offsetSm),
                              child: Text(
                                '${_countryData[key]} ($key)',
                                style: TourlaoText.medium(
                                  fontSize: fontMd,
                                ),
                              ),
                            ),
                          ),
                        },
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: offsetXMd,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateProfile() async {
    if (_event.value != ProfileEvent.NONE) {
      kShowProcessingDialog(context);
      return;
    }
    _autoValidate = AutovalidateMode.always;
    _formProfileKey.currentState.save();
    if (!_formProfileKey.currentState.validate()) {
      return;
    }
    if (_avatar.isEmpty) {
      DialogProvider.of(context).showSnackBar(
        S.current.chooseAvatarImage,
        type: SnackBarType.INFO,
      );
      return;
    }

    _event.value = ProfileEvent.UPDATE;
    var request = MultipartRequest(
        "POST",
        Uri.parse(
            '${(PRODUCTTEST || kReleaseMode) ? RELEASEBASEURL : DEBUGBASEURL}/tourlao_update_profile'));
    request.fields['usr_id'] = Params.currentModel.usr_id;
    request.fields['usr_name'] = _name;
    request.fields['usr_country'] = _country;
    if (!_avatar.contains('http')) {
      var pic = await MultipartFile.fromPath("avatar", _avatar);
      request.files.add(pic);
    }
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print('[RESPONSE] ===> $responseString');
    try {
      var jsonData = json.decode(responseString);
      if (jsonData['ret'] == 10000) {
        Params.currentModel = UserModel.fromJson(jsonData['result']);
        DialogProvider.of(context).showSnackBar(
          S.current.successUpdateProfile,
        );
        setState(() {
          _isEditing = false;
        });
      } else {
        DialogProvider.of(context).showSnackBar(
          jsonData['msg'],
          type: SnackBarType.ERROR,
        );
      }
    } catch (e) {
      DialogProvider.of(context).showSnackBar(
        e.toString(),
        type: SnackBarType.ERROR,
      );
    }
    _event.value = ProfileEvent.NONE;
  }

  void _changeEmail() async {
    if (_event.value != ProfileEvent.NONE) {
      kShowProcessingDialog(context);
      return;
    }
    _event.value = ProfileEvent.EMAIL;
    var _isSendCode = await kSendCode(Params.currentModel.usr_email);
    if (_isSendCode == null) {
      kShowSeverErrorDialog(context);
    } else {
      DialogProvider.of(context).showSnackBar(_isSendCode);
      NavigatorProvider.of(context).pushToWidget(
        screen: ChangeEmailScreen(),
        pop: (v) => _getData(),
      );
    }
    _event.value = ProfileEvent.NONE;
  }

  void _changePass() async {
    if (_event.value != ProfileEvent.NONE) {
      kShowProcessingDialog(context);
      return;
    }
    _event.value = ProfileEvent.PASSWORD;
    var _isSendCode = await kSendCode(Params.currentModel.usr_email);
    if (_isSendCode == null) {
      kShowSeverErrorDialog(context);
    } else {
      DialogProvider.of(context).showSnackBar(_isSendCode);
      NavigatorProvider.of(context).pushToWidget(
        screen: ChangePassScreen(),
        pop: (v) => _getData(),
      );
    }
    _event.value = ProfileEvent.NONE;
  }

  void _loginWithApple() async {
    if (_event.value != ProfileEvent.NONE) {
      kShowProcessingDialog(context);
      return;
    }

    if (Platform.isAndroid) {
      String redirectionUri = 'https://tourlao.laodev.info/Auth/apple_sign';
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: 'example-nonce',
        state: 'example-state',
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'tourlao',
          redirectUri: Uri.parse(
            redirectionUri,
          ),
        ),
      );
      try {
        Map<String, dynamic> payload = Jwt.parseJwt(credential.identityToken);
        String email = payload['email'] as String;
        var param = {
          'usr_name': email.split('@').first,
          'usr_email': email,
          'usr_type': '2',
        };
        _socialLogin(param);
      } catch (e) {
        DialogProvider.of(context).showSnackBar(
          S.current.errorSocialSign,
          type: SnackBarType.ERROR,
        );
      }
    } else {
      var resp = await NativeProvider.initAppleSign();
      if (resp == "Not found any auth") {
        DialogProvider.of(context).showSnackBar(
          S.current.errorSocialSign,
          type: SnackBarType.ERROR,
        );
        return;
      }

      Map<String, dynamic> payload = Jwt.parseJwt(resp);
      print('[APPLE] sign: ${jsonEncode(payload)}');
      String email = payload['email'] as String;

      var param = {
        'usr_name': email.split('@').first,
        'usr_email': email,
        'usr_type': '2',
      };
      _socialLogin(param);
    }
  }

  void _loginWithFacebook() async {
    if (_event.value != ProfileEvent.NONE) {
      kShowProcessingDialog(context);
      return;
    }

    final LoginResult result = await FacebookAuth.instance.login(
      permissions: [
        'public_profile',
        'email',
      ],
    );
    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.i.getUserData(
        fields: "name,email,picture.width(200),birthday,friends,gender,link",
      );
      print('[Facebook] user : $userData');
      var param = {
        'usr_name': userData['name'].toString(),
        'usr_email': userData['email'].toString(),
        'usr_type': '3',
      };
      _socialLogin(param);
    } else {
      print(result.status);
      print(result.message);
      DialogProvider.of(context).showSnackBar(
        result.message,
        type: SnackBarType.INFO,
      );
    }
  }

  void _socialLogin(Map<String, String> param) async {
    print('[Social Login] info : $param');
    _event.value = ProfileEvent.APPLE;
    if (param['usr_type'] == '3') {
      _event.value = ProfileEvent.FACEBOOK;
    }
    var res =
        await NetworkProvider.of(context).post(Constants.apiSocialLogin, param);
    if (res['ret'] == 10000) {
      Params.currentModel = UserModel.fromJson(res['result']);
      _getData();
    } else {
      DialogProvider.of(context).showSnackBar(
        res['result'],
        type: SnackBarType.ERROR,
      );
    }
    _event.value = ProfileEvent.NONE;
  }
}

Path signBackPath({
  @required Size size,
  @required double topWidth,
  @required double bottomWidth,
}) {
  var radius = 20.0;
  var tapRadius = 26.0;

  var path = Path();
  path.moveTo(radius, 0);
  path.lineTo((size.width - topWidth) * 0.5, 0);
  path.arcToPoint(
    Offset((size.width - topWidth) * 0.5 + tapRadius, tapRadius),
    radius: Radius.circular(tapRadius),
    rotation: pi * 0.5,
    clockwise: false,
  );
  path.lineTo((size.width + topWidth) * 0.5 - tapRadius, tapRadius);
  path.arcToPoint(
    Offset((size.width + topWidth) * 0.5, 0),
    radius: Radius.circular(tapRadius),
    rotation: pi * 0.5,
    clockwise: false,
  );
  path.lineTo(size.width - radius, 0);
  path.quadraticBezierTo(size.width, 0, size.width, radius);
  path.lineTo(size.width, size.height - radius);
  path.quadraticBezierTo(
      size.width, size.height, size.width - radius, size.height);
  path.lineTo((size.width + bottomWidth) * 0.5, size.height);
  path.arcToPoint(
    Offset(
        (size.width + bottomWidth) * 0.5 - tapRadius, size.height - tapRadius),
    radius: Radius.circular(tapRadius),
    rotation: pi * 0.5,
    clockwise: false,
  );
  path.lineTo(
      (size.width - bottomWidth) * 0.5 + tapRadius, size.height - tapRadius);
  path.arcToPoint(
    Offset((size.width - bottomWidth) * 0.5, size.height),
    radius: Radius.circular(tapRadius),
    rotation: pi * 0.5,
    clockwise: false,
  );
  path.lineTo(radius, size.height);
  path.quadraticBezierTo(0, size.height, 0, size.height - radius);
  path.lineTo(0, radius);
  path.quadraticBezierTo(0, 0, radius, 0);
  path.close();

  return path;
}

class SignBackClipper extends CustomClipper<Path> {
  final double topWidth;
  final double bottomWidth;

  SignBackClipper({
    this.topWidth = 284,
    this.bottomWidth = 284,
  }) : super();

  @override
  getClip(Size size) {
    var path = signBackPath(
      size: size,
      topWidth: topWidth,
      bottomWidth: bottomWidth,
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}

class SignBackPainter extends CustomPainter {
  final double topWidth;
  final double bottomWidth;

  SignBackPainter({
    this.topWidth = 284,
    this.bottomWidth = 284,
  }) : super();

  @override
  void paint(Canvas canvas, Size size) {
    var path = signBackPath(
      size: size,
      topWidth: topWidth,
      bottomWidth: bottomWidth,
    );
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

enum ProfileEvent {
  NONE,
  SENDCODE,
  SIGN,
  UPDATE,
  EMAIL,
  PASSWORD,
  APPLE,
  FACEBOOK,
}
