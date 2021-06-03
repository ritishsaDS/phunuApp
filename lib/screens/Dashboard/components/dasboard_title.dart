import 'package:flutter/material.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';

class DashboardTitle extends StatefulWidget {
  DashboardTitle({this.day});
  dynamic day;
  @override
  _DashboardTitleState createState() => _DashboardTitleState();
}

class _DashboardTitleState extends State<DashboardTitle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(15),
        vertical: getProportionateScreenHeight(20),
      ),
      child: Stack(
        children: [
          Container(
            height: getProportionateScreenHeight(140),
            width: SizeConfig.screenWidth,
            child: Image.asset(
              'assets/images/dashboard/header_big.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            height: getProportionateScreenHeight(140),
            width: SizeConfig.screenWidth,
            child: Column(
              children: [
                Header(day: widget.day),
                Footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
        vertical: getProportionateScreenHeight(0),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Has your period ended yet?',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class Header extends StatefulWidget {
  Header({
    this.day,
    Key key,
  }) : super(key: key);
  dynamic day;
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(10),
        vertical: getProportionateScreenHeight(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Period Day',
            style: TextStyle(
              color: Colors.white,
              fontSize: getProportionateScreenHeight(24),
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            height: getProportionateScreenHeight(40),
            width: getProportionateScreenWidth(40),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/dashboard/number_count.png',
                ),
                fit: BoxFit.fill,
              ),
            ),
            child: Center(
              child: Text(
                widget.day.toString() != null
                    ? widget.day.toString().replaceAll("-", "")
                    : "",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: getProportionateScreenHeight(24),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
