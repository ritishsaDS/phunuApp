import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/components/common_button.dart';

class PeriodEndedAlert extends StatefulWidget {
  @override
  _PeriodEndedAlertState createState() => _PeriodEndedAlertState();
}

class _PeriodEndedAlertState extends State<PeriodEndedAlert> {
  String formattedDate;
  DateTime periodStartedDate;
  DateTime periodenddate;
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    getdetail();
    var now = new DateTime.now();
    var formatter = new DateFormat('MM/dd/yyyy');
    formattedDate = formatter.format(now);
    //getdetail();
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
            'Hết kinh',
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
            'Ngày hết kinh',
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
                  '${DateTime.parse(formattedDate).day.toString()+"/"+DateTime.parse(formattedDate).month.toString()+"/"+DateTime.parse(formattedDate).year.toString()}',
                  
                  style: date,
                ),
                AlertIcon(
                  iconPath: 'assets/icons/calender.png',
                  onTap: () {
                    enddate();
                  },
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
            title: 'Bỏ',
            onTap: () => Navigator.of(context).pop(),
          ),
          CommonButton(
            title: 'Ok',
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  enddate() async {
    periodenddate = await showDatePicker(
      context: context,
      initialDate:DateTime.parse(formattedDate) ,
      firstDate: DateTime(2021, 4),
      lastDate: DateTime(2021, 11),
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
    if (periodenddate != null && periodenddate != selectedDate)
      setState(() {
        selectedDate = periodenddate;
        formattedDate = selectedDate.toString();
        print(selectedDate);
      });
  }

  Future<void> getdetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("selecteddate") == null) {
    } else {
      setState(() {
        formattedDate = prefs.getString("selecteddate");
      });
    }
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
