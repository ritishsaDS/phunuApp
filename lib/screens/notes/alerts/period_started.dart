import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/components/common_button.dart';

class PeriodStartedAlert extends StatefulWidget {
  @override
  _PeriodStartedAlertState createState() => _PeriodStartedAlertState();
}

class _PeriodStartedAlertState extends State<PeriodStartedAlert> {
  String formattedDate;
  @override
  void initState() {
    var now = new DateTime.now();
    var formatter = new DateFormat('MM/dd/yyyy');
    formattedDate = formatter.format(now);
    print(formattedDate);
    super.initState();
  }

  final TextStyle title = TextStyle(
    fontSize: getProportionateScreenHeight(18),
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  final TextStyle subTitle = TextStyle(
    fontSize: getProportionateScreenHeight(16),
    color: kPrimaryColor,
  );

  final TextStyle date =
      TextStyle(fontSize: getProportionateScreenHeight(12), color: kTextColor);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        width: SizeConfig.screenWidth,
        height: getProportionateScreenHeight(190),
        //padding: EdgeInsets.all(getProportionateScreenHeight(10)),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),

        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(context),
              buildTitle(),
              Divider(),
              buildButton(context)
            ],
          ),
        ),
      ),
    );
  }

  buildHeader(context) {
    return Container(
      height: getProportionateScreenHeight(35),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        color: kPrimaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Period Started',
            style: title,
          ),
          IconButton(
              icon: Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: getProportionateScreenHeight(20),
              ),
              onPressed: () => Navigator.of(context).pop())
        ],
      ),
    );
  }

  buildTitle() {
    return Container(
      height: getProportionateScreenHeight(100),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(25),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Date of period start',
            style: subTitle,
          ),
          Container(
            height: getProportionateScreenHeight(40),
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(10),
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: kPrimaryColor),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$formattedDate',
                  style: date,
                ),
                AlertIcon(
                  iconPath: 'assets/icons/calender.png',
                  onTap: null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildButton(context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CommonButton(
            title: 'Cancel',
            onTap: () => Navigator.of(context).pop(),
          ),
          CommonButton(
            title: 'Confirm',
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class AlertIcon extends StatelessWidget {
  AlertIcon({Key key, @required this.iconPath, @required this.onTap})
      : super(key: key);
  final String iconPath;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 20),
              padding: EdgeInsets.all(getProportionateScreenHeight(10)),
              height: getProportionateScreenHeight(35),
              width: getProportionateScreenHeight(35),
              child: Image.asset(iconPath),
            ),
          ],
        ),
      ),
    );
  }
}
