import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tourlao/generated/l10n.dart';
import 'package:tourlao/model/category_model.dart';
import 'package:tourlao/model/product_model.dart';
import 'package:tourlao/providers/json_provider.dart';
import 'package:tourlao/providers/local_auth_provider.dart';
import 'package:tourlao/providers/navigator_provider.dart';
import 'package:tourlao/providers/network_provider.dart';
import 'package:tourlao/screens/product/category_screen.dart';
import 'package:tourlao/themes/colors.dart';
import 'package:tourlao/themes/dimens.dart';
import 'package:tourlao/themes/textstyles.dart';
import 'package:tourlao/utils/constants.dart';
import 'package:tourlao/widgets/commons.dart';
import 'package:tourlao/widgets/texts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductModel> _top10 = [];
  List<CategoryModel> _categories = [];

  var _loadedCategory = false;

  @override
  void initState() {
    super.initState();

    Timer.run(() {
      _getTopData();
      _getCategories();
    });
  }

  void _getTopData() async {
    var resTop = await JsonProvider.loadAssetTop10();
    _top10 = resTop.map((e) => ProductModel.fromJson(e)).toList();

    setState(() {});
  }

  void _getCategories() async {
    var res =
        await NetworkProvider.of(context).post(Constants.apiGetCategory, {});
    if (res['ret'] == 10000) {
      _categories.clear();
      _categories = (res['result'] as List)
          .map((e) => CategoryModel.fromServerJson(e))
          .toList();
    }

    _loadedCategory = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: kAppbarHeight,
          ),
          SubTitleText(
            title: S.current.top10Place,
          ),
          CarouselSlider(
            options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 7),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                height:
                    (MediaQuery.of(context).size.width - offsetBase * 2) / 1.6 +
                        offsetBase),
            items: [
              for (var product in _top10) ...{
                product.getTopWidget(context),
              }
            ],
          ),
          SizedBox(
            height: offsetBase,
          ),
          SubTitleText(
            title: S.current.categories,
            isLoaded: _loadedCategory,
          ),
          if (_categories.isEmpty) EmptyWidget(S.current.getData),
          if (_categories.isNotEmpty)
            for (var category in _categories) ...{
              InkWell(
                onTap: () => NavigatorProvider.of(context).pushToWidget(
                  screen: CategoryScreen(
                    model: category,
                  ),
                ),
                child: category.getListWidget(),
              ),
            },
          SizedBox(
            height: offsetBase,
          ),
          SubTitleText(
            title: S.current.other,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: offsetSm),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 180.0,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 40.0,
                            color: kPrimaryColor,
                            alignment: Alignment.center,
                            child: Text(
                              'Sponsor',
                              style: TourlaoText.semiBold(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              child: Image.asset(
                                'assets/images/sponser_01.png',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: offsetXSm,
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 180.0,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 40.0,
                            color: kPrimaryColor,
                            alignment: Alignment.center,
                            child: Text(
                              'Weather',
                              style: TourlaoText.semiBold(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              color: Colors.blue,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    S.current.today,
                                    style: TourlaoText.medium(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '22 °C',
                                    style: TourlaoText.bold(
                                      fontSize: fontXMd,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    S.current.tomorrow,
                                    style: TourlaoText.medium(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '20 °C',
                                    style: TourlaoText.bold(
                                      fontSize: fontXMd,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: offsetXSm,
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 180.0,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 40.0,
                            color: kPrimaryColor,
                            alignment: Alignment.center,
                            child: Text(
                              'Laos Map',
                              style: TourlaoText.semiBold(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              color: Colors.white,
                              child: Image.asset(
                                'assets/images/lao_map.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  flex: 2,
                ),
              ],
            ),
          ),
          SizedBox(
            height: kBottomBarHeight + offsetXMd,
          ),
        ],
      ),
    );
  }
}
