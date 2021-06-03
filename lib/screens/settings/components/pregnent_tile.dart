import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/screens/notes/alerts/period_started.dart';

class PregnentTile extends StatefulWidget {
  PregnentTile({this.is_pregnency});
  dynamic is_pregnency;
  @override
  _PregnentTileState createState() => _PregnentTileState();
}

class _PregnentTileState extends State<PregnentTile> {
  bool switchVal = false;
  String formattedDate;

  final TextStyle subTitle = TextStyle(
    fontSize: getProportionateScreenHeight(16),
    color: kPrimaryColor,
  );
  final TextStyle date =
      TextStyle(fontSize: getProportionateScreenHeight(12), color: kTextColor);
  @override
  void initState() {
    print(widget.is_pregnency);
    if (widget.is_pregnency == "no") {
      switchVal = false;
    } else {
      switchVal = true;
    }
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    formattedDate = formatter.format(now);
    print(formattedDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _widget;
    if (switchVal == true) {
      _widget = Container(
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
              'Start of pregnancy',
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
                    "${formattedDate.replaceAll("-", "/").replaceAll("00:00:00.000", "")}",
                    style: date,
                  ),
                  AlertIcon(
                      iconPath: "assets/icons/calender.png",
                      onTap: () => getdate())
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      _widget = Container();
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: getProportionateScreenHeight(10),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(10),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenHeight(11)),
        decoration: BoxDecoration(
            border: Border.all(color: kPrimaryColor),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'I\'m Pregnant!',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                    value: switchVal,
                    inactiveThumbColor: kPrimaryLightColor,
                    onChanged: (val) {
                      setState(() {
                        switchVal = val;
                      });
                    }),
              ],
            ),
            _widget
          ],
        ),
      ),
    );
  }

  getdate() async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021, 4),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFFDE439A),
            accentColor: Color(0xFFDE439A),
            colorScheme: ColorScheme.light(primary: Color(0xFFDE439A)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    if (pickedDate != null && pickedDate != formattedDate)
      setState(() {
        formattedDate = pickedDate.toString();
        print(formattedDate);
      });
  }
}
