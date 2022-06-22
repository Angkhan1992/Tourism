import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tourlao/generated/l10n.dart';
import 'package:tourlao/model/spot_model.dart';
import 'package:tourlao/providers/dialog_provider.dart';
import 'package:tourlao/providers/loading_provider.dart';
import 'package:tourlao/providers/navigator_provider.dart';
import 'package:tourlao/providers/network_provider.dart';
import 'package:tourlao/screens/product/spot_detail_screen.dart';
import 'package:tourlao/themes/dimens.dart';
import 'package:tourlao/utils/constants.dart';
import 'package:tourlao/utils/params.dart';
import 'package:tourlao/widgets/comment.dart';
import 'package:tourlao/widgets/commons.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<SpotModel> _favSpots = [];

  @override
  void initState() {
    super.initState();

    Timer.run(() => _getData());
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: kAppbarHeight,
        ),
        if (_favSpots.isEmpty)
          EmptyWidget(
            Params.currentModel.usr_email == null
                ? S.current.requestLogin
                : S.current.emptyFav,
          ),
        if (_favSpots.isNotEmpty)
          for (var spot in _favSpots) ...{
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: offsetBase,
                vertical: offsetXSm,
              ),
              child: InkWell(
                onTap: () => NavigatorProvider.of(context).pushToWidget(
                  screen: SpotDetailScreen(
                    spot: spot,
                  ),
                ),
                child: spot.getListItem(
                  share: () => spot.share(),
                  comment: () => _comment(spot),
                  like: () => _like(spot),
                ),
              ),
            ),
          },
        SizedBox(
          height: kBottomBarHeight + offsetXMd,
        ),
      ],
    );
  }

  void _getData() async {
    if (Params.currentModel.usr_id == null) {
      return;
    }
    var res = await NetworkProvider.of(context).post(
      Constants.apiFavSpot,
      {
        'usr_id': Params.currentModel.usr_id,
      },
      isProgress: true,
    );
    if (res['ret'] == 10000) {
      print('[Fav] spots ${res['result']}');
      _favSpots.clear();
      _favSpots =
          (res['result'] as List).map((e) => SpotModel.fromJson(e)).toList();
    }
    setState(() {});
  }

  void _comment(SpotModel spot) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CommentWidget(
          spot: spot,
          submit: (res) {
            Navigator.of(context).pop();
            if (res['rate'] != null) {
              setState(() {
                spot.rate = (int.parse(spot.rate) + res['rate']).toString();
                spot.cnt_comment = (int.parse(spot.cnt_comment) + 1).toString();
              });
            }
          },
        );
      },
    );
  }

  void _like(SpotModel spot) async {
    LoadingProvider.of(context).show();
    var res = await spot.like();
    LoadingProvider.of(context).hide();
    if (res['ret'] == 10000) {
      DialogProvider.of(context).showSnackBar(
        S.current.successComment,
      );
      _favSpots.remove(spot);
      setState(() {});
    } else {
      DialogProvider.of(context).showSnackBar(
        res['result'],
        type: SnackBarType.ERROR,
      );
    }
  }
}
