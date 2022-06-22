import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tourlao/generated/l10n.dart';
import 'package:tourlao/model/review_model.dart';
import 'package:tourlao/themes/colors.dart';
import 'package:tourlao/utils/constants.dart';
import 'package:tourlao/widgets/appbar.dart';
import 'package:tourlao/widgets/commons.dart';

class RecentScreen extends StatefulWidget {
  final List<ReviewModel> reviews;

  const RecentScreen({
    Key key,
    @required this.reviews,
  }) : super(key: key);

  @override
  _RecentScreenState createState() => _RecentScreenState();
}

class _RecentScreenState extends State<RecentScreen> {
  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      backImage: 'assets/images/landing_03.jpg',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: kPrimaryColor,
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  SizedBox(
                    height: kAppbarHeight,
                  ),
                  for (var review in widget.reviews) ...{
                    review.getWidget(),
                  },
                ],
              ),
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
          Icons.rate_review_outlined,
          color: Colors.white,
        ),
        title: S.current.reviews,
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
