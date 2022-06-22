import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tourlao/generated/l10n.dart';
import 'package:tourlao/model/category_model.dart';
import 'package:tourlao/model/spot_model.dart';
import 'package:tourlao/providers/dialog_provider.dart';
import 'package:tourlao/providers/navigator_provider.dart';
import 'package:tourlao/providers/network_provider.dart';
import 'package:tourlao/screens/product/spot_detail_screen.dart';
import 'package:tourlao/themes/colors.dart';
import 'package:tourlao/themes/dimens.dart';
import 'package:tourlao/utils/constants.dart';
import 'package:tourlao/utils/params.dart';
import 'package:tourlao/widgets/appbar.dart';
import 'package:tourlao/widgets/comment.dart';
import 'package:tourlao/widgets/commons.dart';

class CategoryScreen extends StatefulWidget {
  final CategoryModel model;

  const CategoryScreen({Key key, @required this.model}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<SpotModel> _spots = [];

  ValueNotifier<CategoryScreenEvent> _event;

  @override
  void initState() {
    super.initState();
    _event = ValueNotifier(CategoryScreenEvent.NONE);
    Timer.run(() {
      _getData();
    });
  }

  void _getData() async {
    _event.value = CategoryScreenEvent.ACTION;
    var res = await NetworkProvider.of(context).post(
      Constants.apiGetSpot,
      {
        'cat_id': widget.model.id,
        'usr_id': Params.currentModel.usr_id == null
            ? '0'
            : Params.currentModel.usr_id,
      },
    );
    if (res['ret'] == 10000) {
      print('[Spot] spots ${res['result']}');
      _spots.clear();
      _spots =
          (res['result'] as List).map((e) => SpotModel.fromJson(e)).toList();
    }
    _event.value = CategoryScreenEvent.NONE;
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: ValueListenableBuilder<CategoryScreenEvent>(
        valueListenable: _event,
        builder: (context, event, view) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              toolbarHeight: 0,
              backgroundColor: kPrimaryColor,
            ),
            body: Stack(
              children: [
                _spots.isEmpty
                    ? Column(
                        children: [
                          SizedBox(
                            height: kAppbarHeight,
                          ),
                          EmptyWidget(S.current.getData),
                        ],
                      )
                    : ListView(
                        children: [
                          SizedBox(
                            height: kAppbarHeight,
                          ),
                          for (var spot in _spots) ...{
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: offsetBase,
                                vertical: offsetXSm,
                              ),
                              child: InkWell(
                                onTap: () =>
                                    NavigatorProvider.of(context).pushToWidget(
                                  screen: SpotDetailScreen(
                                    spot: spot,
                                  ),
                                ),
                                child: spot.getListItem(
                                  share: () => _share(spot),
                                  comment: () => _comment(spot),
                                  like: () => _like(spot),
                                ),
                              ),
                            ),
                          },
                        ],
                      ),
                _headerView(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _headerView() {
    return TourlaoAppBar(
      titleWidget: TitleWidget(
        icon: _event.value == CategoryScreenEvent.NONE
            ? SvgPicture.asset(
          widget.model.image,
          color: Colors.white,
        )
            : ProcessingWidget(),
        title: widget.model.name,
      ),
      prefix: InkWell(
        onTap: () {
          if (_event.value != CategoryScreenEvent.NONE) {
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

  void _share(SpotModel model) async {
    if (_event.value != CategoryScreenEvent.NONE) {
      kShowProcessingDialog(context);
      return;
    }
    model.share();
  }

  void _comment(SpotModel model) async {
    if (_event.value != CategoryScreenEvent.NONE) {
      kShowProcessingDialog(context);
      return;
    }
    if (Params.currentModel.usr_email == null) {
      DialogProvider.of(context).showSnackBar(
        S.current.requestLogin,
        type: SnackBarType.INFO,
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (context) {
        return CommentWidget(
          spot: model,
          submit: (res) {
            Navigator.of(context).pop();
            if (res['rate'] != null) {
              setState(() {
                model.rate = (int.parse(model.rate) + res['rate']).toString();
                model.cnt_comment =
                    (int.parse(model.cnt_comment) + 1).toString();
              });
            }
          },
        );
      },
    );
  }

  void _like(SpotModel model) async {
    if (_event.value != CategoryScreenEvent.NONE) {
      kShowProcessingDialog(context);
      return;
    }
    if (Params.currentModel.usr_email == null) {
      DialogProvider.of(context).showSnackBar(
        S.current.requestLogin,
        type: SnackBarType.INFO,
      );
      return;
    }
    _event.value = CategoryScreenEvent.ACTION;
    var res = await model.like();
    if (res['ret'] == 10000) {
      DialogProvider.of(context).showSnackBar(
        S.current.successComment,
      );
      if (res['msg'] == 'liked') {
        model.is_like = 'true';
        model.cnt_like = '${int.parse(model.cnt_like) + 1}';
      } else {
        model.is_like = 'false';
        model.cnt_like = '${int.parse(model.cnt_like) - 1}';
      }
    } else {
      DialogProvider.of(context).showSnackBar(
        res['result'],
        type: SnackBarType.ERROR,
      );
    }
    _event.value = CategoryScreenEvent.NONE;
  }

  void _filter() {
    if (_event.value != CategoryScreenEvent.NONE) {
      kShowProcessingDialog(context);
      return;
    }
  }
}

enum CategoryScreenEvent {
  NONE,
  ACTION,
}
