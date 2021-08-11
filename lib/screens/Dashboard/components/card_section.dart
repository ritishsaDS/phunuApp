import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/screens/Articles/articles.dart';
import 'package:vietnamese/screens/calander/calander_screen.dart';
import 'package:vietnamese/screens/notes/notesScreen.dart';
import 'package:vietnamese/screens/settings/settings.dart';
import 'dart:convert';

import '../../lunar.dart';

class CardSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenHeight(20)),
      child: Container(
          // height: getProportionateScreenHeight(200),
          width: SizeConfig.screenWidth,
          color: Colors.white,
          child: Column(
            children: [TopRow(), BottomRow()],
          )),
    );
  }
}

class TopRow extends StatefulWidget {
  const TopRow({
    Key key,
  }) : super(key: key);

  @override
  _TopRowState createState() => _TopRowState();
}

class _TopRowState extends State<TopRow> {
  DateTime selectedDate = DateTime.now();
  var formatter;
  String formattedDate;
  @override
  void initState() {
    var now = new DateTime.now();
    formatter = new DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
    print(formattedDate);
    print(json.encode({
      "registration_ids": "tokens",
      "collapse_key": "type_a",
      "notification": {
        "body": "Body of Your Notification",
        "title": "Title of Your Notification"
      }
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CardButton(
            title: 'Lịch',
            iconUrl: 'assets/icons/calender.png',
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Lunar()));
            }),
        CardButton(
          title: 'Nhật ký ',
          iconUrl: 'assets/icons/notes.png',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotesScreen(),
            ),
          ),
        ),
      ],
    );
  }

  getdate() {
    showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021, 4),
      lastDate: DateTime.parse(formattedDate),
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
  }
}

class BottomRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CardButton(
          title: 'Bài',
          iconUrl: 'assets/icons/articles.png',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ArticleScreen()),
          ),
        ),
        CardButton(
          title: 'Cài đặt',
          iconUrl: 'assets/icons/seetings.png',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingScreen()),
          ),
        ),
      ],
    );
  }
}

class CardButton extends StatelessWidget {
  const CardButton({
    Key key,
    @required this.iconUrl,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);
  final String iconUrl;
  final String title;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: getProportionateScreenHeight(0),
        ),
        child: Container(
          height: getProportionateScreenHeight(90),
          width: SizeConfig.screenWidth * 0.5 - 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              image: AssetImage(
                'assets/images/dashboard/home_button.png',
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(getProportionateScreenHeight(10)),
                height: getProportionateScreenHeight(40),
                width: getProportionateScreenHeight(40),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.1),
                        blurRadius: 4.0,
                        spreadRadius: 4.0,
                      )
                    ]),
                child: Image.asset(iconUrl),
              ),
              WidthBox(getProportionateScreenWidth(10)),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: getProportionateScreenHeight(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
