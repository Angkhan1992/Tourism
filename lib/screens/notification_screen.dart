import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tourlao/generated/l10n.dart';
import 'package:tourlao/model/notification_model.dart';
import 'package:tourlao/providers/network_provider.dart';
import 'package:tourlao/themes/colors.dart';
import 'package:tourlao/themes/dimens.dart';
import 'package:tourlao/themes/textstyles.dart';
import 'package:tourlao/utils/constants.dart';
import 'package:tourlao/utils/params.dart';
import 'package:tourlao/widgets/appbar.dart';
import 'package:tourlao/widgets/commons.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> _models = [];

  @override
  void initState() {
    super.initState();
    Timer.run(() => _getData());
  }

  void _getData() async {
    if (Params.currentModel.usr_email == null) return;
    var res = await NetworkProvider.of(context).post(Constants.apiGetNotification, {
      'usr_id' : Params.currentModel.usr_id,
    });
    if (res['ret'] == 10000) {
      _models.clear();
      _models = (res['result'] as List).map((e) => NotificationModel.fromJson(e)).toList();
      _models.sort((a, b) => b.created_at.compareTo(a.created_at));
      print('[Noti] ${_models.length}');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      backImage: 'assets/images/landing_02.jpg',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: kPrimaryColor,
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                SizedBox(
                  height: kAppbarHeight,
                ),
                if (_models.isEmpty)
                  EmptyWidget(
                    Params.currentModel.usr_email == null
                        ? S.current.requestLogin
                        : S.current.emptyNoti,
                  ),
                if (_models.isNotEmpty)
                  for (var noti in _models) ...{
                    noti.getItem(),
                  }
              ],
            ),
            _headerView(),
          ],
        ),
      ),
    );
  }

  Widget _headerView() {
    return TourlaoAppBar(
      titleWidget: TitleWidget(
        icon: Icon(
          Icons.notifications_none,
          color: Colors.white,
        ),
        title: S.current.notification,
      ),
      prefix: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: SvgPicture.asset(
          'assets/icons/ic_arrow_back.svg',
          color: Colors.white,
        ),
      ),
    );
  }
}
