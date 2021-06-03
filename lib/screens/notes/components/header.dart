import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';

class Header extends StatefulWidget {
  const Header({
    Key key,
  }) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  String today;
  @override
  void initState() {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd/MM/yyyy');
    today = formatter.format(now);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: getProportionateScreenHeight(60),
        width: SizeConfig.screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: getProportionateScreenHeight(25),
                  width: getProportionateScreenHeight(25),
                  child: Image.asset(
                    'assets/icons/calender.png',
                    fit: BoxFit.contain,
                  ),
                ),
                WidthBox(getProportionateScreenWidth(40)),
                Text(
                  "$today",
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                WidthBox(getProportionateScreenWidth(90))
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
