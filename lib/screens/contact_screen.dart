import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tourlao/generated/l10n.dart';
import 'package:tourlao/providers/dialog_provider.dart';
import 'package:tourlao/providers/network_provider.dart';
import 'package:tourlao/themes/colors.dart';
import 'package:tourlao/themes/dimens.dart';
import 'package:tourlao/utils/constants.dart';
import 'package:tourlao/utils/params.dart';
import 'package:tourlao/widgets/appbar.dart';
import 'package:tourlao/widgets/buttons.dart';
import 'package:tourlao/widgets/commons.dart';
import 'package:tourlao/widgets/textfields.dart';
import 'package:tourlao/utils/extensions.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  ValueNotifier<ContactScreenState> _event;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  var _emailController = TextEditingController();

  var _email = '';
  var _title = '';
  var _content = '';

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _event = ValueNotifier(ContactScreenState.NONE);
    _emailController.text = Params.currentModel.usr_email;
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      backImage: 'assets/images/landing_03.jpg',
      child: ValueListenableBuilder<ContactScreenState>(
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

  Widget _contentView() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: offsetBase,
        vertical: offsetXMd,
      ),
      child: Column(
        children: [
          SizedBox(
            height: kAppbarHeight,
          ),
          Form(
            key: _formKey,
            autovalidateMode: _autoValidate,
            child: Column(
              children: [
                TourlaoTextField(
                  controller: _emailController,
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  hintText: 'Email',
                  validator: (email) {
                    return email.validateEmail;
                  },
                  onSaved: (email) {
                    _email = email;
                  },
                ),
                SizedBox(
                  height: offsetBase,
                ),
                TourlaoTextField(
                  prefixIcon: Icon(
                    Icons.title,
                    color: Colors.white,
                  ),
                  hintText: 'Title',
                  validator: (title) {
                    return title.validateContent;
                  },
                  onSaved: (title) {
                    _title = title;
                  },
                ),
                SizedBox(
                  height: offsetBase,
                ),
                TourlaoTextField(
                  hintText: 'Content',
                  isMemo: true,
                  validator: (content) {
                    return content.validateContent;
                  },
                  onSaved: (content) {
                    _content = content;
                  },
                ),
              ],
            ),
          ),
          Spacer(),
          InkWell(
            onTap: () => _submit(),
            child: TourlaoButtonWidget(
              title: S.current.submit,
              width: 280.0,
              isLoading: _event.value == ContactScreenState.SUBMIT,
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerView() {
    return TourlaoAppBar(
      titleWidget: TitleWidget(
        icon: _event.value == ContactScreenState.NONE
            ? Icon(
                Icons.help_outline,
                color: Colors.white,
              )
            : ProcessingWidget(),
        title: S.current.contactUs,
      ),
      prefix: InkWell(
        onTap: () {
          if (_event.value != ContactScreenState.NONE) {
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

  void _submit() async {
    if (_event.value != ContactScreenState.NONE) {
      kShowProcessingDialog(context);
      return;
    }
    _autoValidate = AutovalidateMode.always;
    _formKey.currentState.save();
    if (!_formKey.currentState.validate()) {
      return;
    }

    _event.value = ContactScreenState.SUBMIT;
    var res = await NetworkProvider.of(context).post(
      Constants.apiAddFaq,
      {
        'email' : _email,
        'title' : _title,
        'content' : _content,
      },
    );
    if (res['ret'] == 10000) {
      DialogProvider.of(context).showSnackBar(S.current.faqContent);
    }
    _event.value = ContactScreenState.NONE;
  }
}

enum ContactScreenState {
  NONE,
  SUBMIT,
}
