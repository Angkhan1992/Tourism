import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tourlao/generated/l10n.dart';
import 'package:tourlao/model/review_model.dart';
import 'package:tourlao/model/spot_model.dart';
import 'package:tourlao/providers/dialog_provider.dart';
import 'package:tourlao/providers/loading_provider.dart';
import 'package:tourlao/providers/navigator_provider.dart';
import 'package:tourlao/providers/network_provider.dart';
import 'package:tourlao/providers/perf_provider.dart';
import 'package:tourlao/screens/product/recent_screen.dart';
import 'package:tourlao/themes/colors.dart';
import 'package:tourlao/themes/dimens.dart';
import 'package:tourlao/themes/textstyles.dart';
import 'package:tourlao/utils/constants.dart';
import 'package:tourlao/widgets/appbar.dart';
import 'package:tourlao/widgets/comment.dart';
import 'package:tourlao/widgets/commons.dart';
import 'package:tourlao/utils/extensions.dart';

class SpotDetailScreen extends StatefulWidget {
  final SpotModel spot;

  const SpotDetailScreen({
    Key key,
    @required this.spot,
  }) : super(key: key);

  @override
  _SpotDetailScreenState createState() => _SpotDetailScreenState();
}

class _SpotDetailScreenState extends State<SpotDetailScreen> {
  ValueNotifier<SpotDetailEvent> _event;

  List<ReviewModel> _reviews = [];
  var langIndex = 0;

  @override
  void initState() {
    super.initState();
    _event = ValueNotifier(SpotDetailEvent.NONE);

    Timer.run(() => _getComment());
  }

  void _getComment() async {
    langIndex = (await PrefProvider().getLang()) == 'EN' ? 0 : 1;
    var res = await NetworkProvider.of(context).post(
      Constants.apiGetComment,
      {'spot_id': widget.spot.spot_id},
    );
    if (res['ret'] == 10000) {
      _reviews.clear();
      _reviews =
          (res['result'] as List).map((e) => ReviewModel.fromJson(e)).toList();
      _reviews.sort((b, a) => a.created_at.compareTo(b.created_at));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      backImage: 'assets/images/landing_02.jpg',
      child: ValueListenableBuilder<SpotDetailEvent>(
        valueListenable: _event,
        builder: (context, event, view) {
          var spotImgs = widget.spot.spot_imgs;
          var actionColors = [
            Colors.pink,
            Colors.purple,
            kPrimaryColor,
          ];
          var actionIcons = [
            widget.spot.is_like == 'true'
                ? Icons.favorite
                : Icons.favorite_outline,
            Icons.comment,
            Icons.share_sharp,
          ];

          return Scaffold(
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
                      height: kAppbarHeight - offsetLg,
                    ),
                    Container(
                      width: double.infinity,
                      height: 250,
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://tourlao.laodev.info/uploads/spot/${spotImgs != null ? spotImgs.split('/')[0] : 'image_url'}',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  ExactAssetImage('assets/images/landing.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/landing.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: offsetBase,
                        vertical: offsetBase,
                      ),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    langIndex == 0
                                        ? widget.spot.spot_name_la
                                        : widget.spot.spot_name,
                                    style: TourlaoText.bold(
                                      color: Colors.white,
                                      fontSize: fontXMd,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius:
                                          BorderRadius.circular(offsetXSm),
                                    ),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              langIndex = 0;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: offsetSm,
                                              vertical: offsetXSm,
                                            ),
                                            decoration: BoxDecoration(
                                              color: langIndex == 0
                                                  ? Colors.white
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      offsetXSm),
                                            ),
                                            child: Text(
                                              'EN',
                                              style: TourlaoText.bold(
                                                  color: langIndex == 0
                                                      ? Colors.black
                                                      : Colors.white,
                                                  fontSize: fontSm),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              langIndex = 1;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: offsetSm,
                                              vertical: offsetXSm,
                                            ),
                                            decoration: BoxDecoration(
                                              color: langIndex == 1
                                                  ? Colors.white
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      offsetXSm),
                                            ),
                                            child: Text(
                                              'ລາວ',
                                              style: TourlaoText.bold(
                                                  color: langIndex == 1
                                                      ? Colors.black
                                                      : Colors.white,
                                                  fontSize: fontSm),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    widget.spot.getRate(),
                                    style: TourlaoText.medium(
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: offsetSm,
                                  ),
                                  for (var i = 0; i < 5; i++) ...{
                                    Icon(
                                      widget.spot.getRate() == '---'
                                          ? Icons.star
                                          : double.parse(
                                                      widget.spot.getRate()) >
                                                  (i + 0.45)
                                              ? Icons.star
                                              : Icons.star_outline,
                                      color: Colors.yellow,
                                      size: 18.0,
                                    ),
                                  },
                                ],
                              ),
                              Row(
                                children: [
                                  for (var i = 0; i < 3; i++) ...{
                                    InkWell(
                                      onTap: () {
                                        if (i == 0) _like();
                                        if (i == 1) _comment();
                                        if (i == 2) widget.spot.share();
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: offsetBase),
                                        width: i == 2 ? 32 : 80.0,
                                        height: 32.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(offsetBase),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white,
                                              actionColors[i]
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: 6,
                                            ),
                                            Icon(
                                              actionIcons[i],
                                              color: Colors.white,
                                              size: 18.0,
                                            ),
                                            if (i < 2) ...{
                                              SizedBox(
                                                width: offsetXSm,
                                              ),
                                              Expanded(
                                                child: Center(
                                                  child: Text(
                                                    i == 0
                                                        ? widget.spot
                                                            .getLikeCounter()
                                                        : widget.spot
                                                            .getCommentCounter(),
                                                    style: TourlaoText.medium(
                                                      color: Colors.white,
                                                      fontSize: fontSm,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            }
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: offsetBase,
                                    ),
                                  }
                                ],
                              ),
                              if (widget.spot.spot_desc.isNotEmpty)
                                Text(
                                  langIndex == 0
                                      ? widget.spot.spot_desc
                                      : widget.spot.spot_desc_la,
                                  style: TourlaoText.medium(
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(
                            height: offsetXMd,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.white,
                                    size: 18.0,
                                  ),
                                  SizedBox(
                                    width: offsetSm,
                                  ),
                                  Text(
                                    S.current.location,
                                    style: TourlaoText.bold(
                                      fontSize: fontXMd,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: offsetSm,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    S.current.address,
                                    style: TourlaoText.medium(
                                      fontSize: fontSm,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: offsetBase,
                                  ),
                                  Expanded(
                                    child: Text(
                                      (langIndex == 0
                                              ? widget.spot.spot_address
                                              : widget.spot.spot_address_la)
                                          .spotInformation,
                                      style: TourlaoText.semiBold(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: offsetSm,
                              ),
                              Row(
                                children: [
                                  Text(
                                    S.current.city,
                                    style: TourlaoText.medium(
                                      fontSize: fontSm,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: offsetBase,
                                  ),
                                  Text(
                                    (langIndex == 0
                                            ? widget.spot.spot_city
                                            : widget.spot.spot_city_la)
                                        .spotInformation,
                                    style: TourlaoText.semiBold(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: offsetSm,
                              ),
                              Row(
                                children: [
                                  Text(
                                    S.current.province,
                                    style: TourlaoText.medium(
                                      fontSize: fontSm,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: offsetBase,
                                  ),
                                  Text(
                                    (langIndex == 0
                                            ? widget.spot.spot_province
                                            : widget.spot.spot_province_la)
                                        .spotInformation,
                                    style: TourlaoText.semiBold(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: offsetSm,
                              ),
                              if (widget.spot.spot_lat != '0')
                                Text(
                                  S.current.googleMap,
                                  style: TourlaoText.semiBold(
                                    color: Colors.white,
                                  ).copyWith(
                                      decoration: TextDecoration.underline),
                                ),
                            ],
                          ),
                          SizedBox(
                            height: offsetXMd,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.contacts_outlined,
                                    color: Colors.white,
                                    size: 18.0,
                                  ),
                                  SizedBox(
                                    width: offsetSm,
                                  ),
                                  Text(
                                    S.current.contacts,
                                    style: TourlaoText.bold(
                                      fontSize: fontXMd,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: offsetSm,
                              ),
                              Row(
                                children: [
                                  Text(
                                    S.current.fullName,
                                    style: TourlaoText.medium(
                                      fontSize: fontSm,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: offsetBase,
                                  ),
                                  Text(
                                    widget.spot.con_name.spotInformation,
                                    style: TourlaoText.semiBold(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: offsetSm,
                              ),
                              Row(
                                children: [
                                  Text(
                                    S.current.address,
                                    style: TourlaoText.medium(
                                      fontSize: fontSm,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: offsetBase,
                                  ),
                                  Text(
                                    langIndex == 0
                                        ? '${widget.spot.con_city.spotInformation}, ${widget.spot.con_province.spotInformation}'
                                        : '${widget.spot.con_city_la.spotInformation}, ${widget.spot.con_province_la.spotInformation}',
                                    style: TourlaoText.semiBold(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: offsetSm,
                              ),
                              Row(
                                children: [
                                  Text(
                                    S.current.phone,
                                    style: TourlaoText.medium(
                                      fontSize: fontSm,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: offsetBase,
                                  ),
                                  Text(
                                    widget.spot.con_tel.spotInformation,
                                    style: TourlaoText.semiBold(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: offsetSm,
                              ),
                              Row(
                                children: [
                                  Text(
                                    S.current.fax,
                                    style: TourlaoText.medium(
                                      fontSize: fontSm,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: offsetBase,
                                  ),
                                  Text(
                                    widget.spot.con_fax.spotInformation,
                                    style: TourlaoText.semiBold(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: offsetXMd,
                          ),
                          if (_reviews.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.rate_review_outlined,
                                      color: Colors.white,
                                      size: 18.0,
                                    ),
                                    SizedBox(
                                      width: offsetSm,
                                    ),
                                    Text(
                                      S.current.recentReview,
                                      style: TourlaoText.bold(
                                        fontSize: fontXMd,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () => NavigatorProvider.of(context)
                                          .pushToWidget(
                                        screen: RecentScreen(reviews: _reviews),
                                      ),
                                      child: Text(
                                        '${S.current.showAll}',
                                        style: TourlaoText.medium(
                                          color: Colors.white,
                                        ).copyWith(
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: offsetSm,
                                ),
                                for (var i = 0;
                                    i < min(3, _reviews.length);
                                    i++) ...{
                                  _reviews[i].getWidget(),
                                },
                              ],
                            ),
                        ],
                      ),
                    ),
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

  void _like() async {
    LoadingProvider.of(context).show();
    var res = await widget.spot.like();
    LoadingProvider.of(context).hide();
    if (res['ret'] == 10000) {
      DialogProvider.of(context).showSnackBar(
        S.current.successComment,
      );
      widget.spot.is_like = (res['msg'] == 'liked').toString();
      setState(() {});
    } else {
      DialogProvider.of(context).showSnackBar(
        res['result'],
        type: SnackBarType.ERROR,
      );
    }
  }

  Widget _headerView() {
    return TourlaoAppBar(
      titleWidget: TitleWidget(
        icon: _event.value == SpotDetailEvent.NONE
            ? Icon(
          Icons.image_outlined,
          color: Colors.white,
        )
            : ProcessingWidget(),
        title: langIndex == 0
            ? widget.spot.spot_name
            : widget.spot.spot_name_la,
      ),
      prefix: InkWell(
        onTap: () {
          if (_event.value != SpotDetailEvent.NONE) {
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

  void _comment() async {
    await showDialog(
      context: context,
      builder: (context) {
        return CommentWidget(
          spot: widget.spot,
          submit: (res) {
            Navigator.of(context).pop();
            if (res['rate'] != null) {
              setState(() {
                widget.spot.rate =
                    (int.parse(widget.spot.rate) + res['rate']).toString();
                widget.spot.cnt_comment =
                    (int.parse(widget.spot.cnt_comment) + 1).toString();
              });
            }
          },
        );
      },
    );
  }
}

enum SpotDetailEvent {
  NONE,
  SHARE,
  COMMENT,
  LIKE,
}
