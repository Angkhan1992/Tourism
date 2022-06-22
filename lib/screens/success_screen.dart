import 'package:flutter/material.dart';
import 'package:tourlao/themes/colors.dart';
import 'package:tourlao/themes/dimens.dart';
import 'package:tourlao/themes/textstyles.dart';
import 'package:tourlao/widgets/commons.dart';

class SuccessScreen extends StatefulWidget {
  final String title;
  final String desc;
  final IconData iconData;

  const SuccessScreen({
    Key key,
    @required this.title,
    @required this.desc,
    @required this.iconData,
  }) : super(key: key);

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () => Navigator.of(context).pop(true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: offsetBase),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120.0,
                height: 120.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white30,
                  border: Border.all(color: Colors.white),
                ),
                child: Center(
                  child: Icon(
                    widget.iconData,
                    color: Colors.white,
                    size: 56.0,
                  ),
                ),
              ),
              SizedBox(
                height: offsetXLg,
              ),
              Text(
                widget.title,
                style: TourlaoText.bold(
                  fontSize: fontLg,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: offsetSm,
              ),
              Text(
                widget.desc,
                style: TourlaoText.medium(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
