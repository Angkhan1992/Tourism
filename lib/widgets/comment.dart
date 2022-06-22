import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tourlao/generated/l10n.dart';
import 'package:tourlao/model/spot_model.dart';
import 'package:tourlao/providers/dialog_provider.dart';
import 'package:tourlao/screens/auth/profile_screen.dart';
import 'package:tourlao/themes/dimens.dart';
import 'package:tourlao/themes/textstyles.dart';
import 'package:tourlao/utils/constants.dart';
import 'package:tourlao/widgets/buttons.dart';
import 'package:tourlao/widgets/commons.dart';
import 'package:tourlao/widgets/textfields.dart';
import 'package:tourlao/utils/extensions.dart';

class CommentWidget extends StatefulWidget {
  final SpotModel spot;
  final Function(dynamic) submit;

  const CommentWidget({
    Key key,
    this.spot,
    this.submit,
  }) : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  var topWidth = 224.0;
  var _comment = '';
  var _review = 5;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  ValueNotifier<CommentEvent> _event;

  @override
  void initState() {
    super.initState();
    _event = ValueNotifier(CommentEvent.NONE);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.of(context).pop();
      },
      child: ValueListenableBuilder<CommentEvent>(
        valueListenable: _event,
        builder: (context, event, widget) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: InkWell(
                  onTap: () {},
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: offsetXMd, horizontal: offsetBase),
                        child: CustomPaint(
                          painter: SignBackPainter(
                            topWidth: topWidth,
                          ),
                          child: ClipPath(
                            clipper: SignBackClipper(
                              topWidth: topWidth,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: offsetBase,
                                vertical: 56,
                              ),
                              width: double.infinity,
                              color: Colors.white30,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    S.current.spotCommentDesc,
                                    style: TourlaoText.medium(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: offsetBase,
                                      vertical: offsetSm,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        for (var i = 0; i < 5; i++) ...{
                                          Padding(
                                            padding: EdgeInsets.all(offsetSm),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _review = i + 1;
                                                });
                                              },
                                              child: Icon(
                                                _review > i
                                                    ? Icons.star
                                                    : Icons.star_outline,
                                                color: Colors.yellow,
                                                size: 32,
                                              ),
                                            ),
                                          ),
                                        }
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: offsetSm,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: offsetSm),
                                    child: Form(
                                      key: _formKey,
                                      autovalidateMode: _autoValidate,
                                      child: TourlaoTextField(
                                        textInputAction: TextInputAction.done,
                                        hintText: S.current.spotComment,
                                        isMemo: true,
                                        validator: (comment) {
                                          return comment.validateComment;
                                        },
                                        onSaved: (comment) {
                                          _comment = comment;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 48.0,
                            width: topWidth - 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.0),
                              border: Border.all(color: Colors.white),
                              color: Colors.white30,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 2.0,
                                ),
                                _event.value == CommentEvent.ADD
                                    ? ProcessingWidget()
                                    : Container(
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Colors.purple
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.rate_review_outlined,
                                          color: Colors.white,
                                          size: 18.0,
                                        ),
                                      ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      S.current.spotComment,
                                      style: TourlaoText.bold(
                                        fontSize: fontMd,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 2.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: InkWell(
                            onTap: () => _submit(),
                            child: TourlaoButtonWidget(
                              width: 280.0,
                              title: S.current.submit,
                              isLoading: _event.value == CommentEvent.ADD,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _submit() async {
    if (_event.value != CommentEvent.NONE) {
      kShowProcessingDialog(context);
      return;
    }

    _formKey.currentState.save();
    _autoValidate = AutovalidateMode.always;

    if (!_formKey.currentState.validate()) {
      return;
    }

    _event.value = CommentEvent.ADD;
    var res = await widget.spot.comment(_comment, _review.toString());
    var result = {};
    if (res['ret'] == 10000) {
      DialogProvider.of(context).showSnackBar(S.current.addCommentSuccess);
      result = {
        'content': _comment,
        'rate': _review,
      };
    }
    _event.value = CommentEvent.NONE;
    widget.submit(result);
  }
}

enum CommentEvent {
  NONE,
  ADD,
}
