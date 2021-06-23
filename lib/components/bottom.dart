import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vietnamese/components/icons.dart';
import 'package:vietnamese/screens/calander/calander_screen.dart';
import 'package:vietnamese/screens/lunar.dart';
import 'package:vietnamese/screens/notes/notesScreen.dart';

import '../common/constants.dart';
import '../common/size_config.dart';
import '../screens/Articles/articles.dart';
import '../screens/Dashboard/dashboard.dart';
import '../screens/settings/settings.dart';

class BottomTabs extends StatefulWidget {
  int index;
  bool showCat;

  BottomTabs(this.index, this.showCat);

  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(65),
      width: SizeConfig.screenWidth,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Wrap(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    color: kSecondaryColor.withOpacity(0.4),
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          Align(
            child: Container(
              alignment: Alignment.topCenter,
              height: getProportionateScreenHeight(65),
              width: MediaQuery.of(context).size.width,
              color: kSecondaryColor.withOpacity(0.4),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                        onTap: () {
                          if (widget.index == 3) {
                            return;
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DashboardScreen(),
                                ));
                          }
                        },
                        child: Container(
                          //  margin: EdgeInsets.only(top: 5, bottom: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Center(
                                    child: Image.asset(
                                  'assets/icons/home_white.png',
                                  height: 25,
                                )),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Home",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                              )
                            ],
                          ),
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                        onTap: () {
                          //Navigator.popUntil(context, StoreDetail(null));
                          if (widget.index == 1) {
                            // return;
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Lunar(),
                                ));
                          }
                        },
                        child: Container(
                          //  margin: EdgeInsets.only(top: 5, bottom: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                  child: Icon(
                                MyFlutterApp.calender_icon,
                                color: widget.index == 1
                                    ? kPrimaryColor
                                    : Colors.white,
                              )),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Calendar",
                                style: TextStyle(
                                    color: widget.index == 1
                                        ? kPrimaryColor
                                        : Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                              )
                            ],
                          ),
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                        onTap: () {
                          //Navigator.popUntil(context, StoreDetail(null));
                          if (widget.index == 2) {
                            // return;
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotesScreen(),
                                ));
                          }
                        },
                        child: Container(
                          //  margin: EdgeInsets.only(top: 5, bottom: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: (widget.index == 2
                                    ? Icon(
                                        MyFlutterApp.notes_icon,
                                        color: kPrimaryColor,
                                      )
                                    : Icon(
                                        MyFlutterApp.notes_icon,
                                        color: Colors.white,
                                      )),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Notes",
                                style: TextStyle(
                                    color: widget.index == 2
                                        ? kPrimaryColor
                                        : Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                              )
                            ],
                          ),
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                        onTap: () {
                          if (widget.index == 5) {
                            return;
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingScreen(),
                                ));
                          }
                          //isLoggedIn();
                        },
                        child: Container(
                          //  margin: EdgeInsets.only(top: 5, bottom: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Center(
                                    child: Icon(
                                  MyFlutterApp.seetings_icon,
                                  color: widget.index == 5
                                      ? kPrimaryColor
                                      : Colors.white,
                                )),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Settings",
                                style: TextStyle(
                                    color: widget.index == 5
                                        ? kPrimaryColor
                                        : Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                              )
                            ],
                          ),
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                        onTap: () {
                          if (widget.index == 4) {
                            return;
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ArticleScreen(),
                                ));
                          }
                        },
                        child: Container(
                          //  margin: EdgeInsets.only(top: 5, bottom: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Center(
                                    child: Icon(
                                  MyFlutterApp.articles_icon,
                                  color: widget.index == 4
                                      ? kPrimaryColor
                                      : Colors.white,
                                )),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Articles",
                                style: TextStyle(
                                    color: widget.index == 4
                                        ? kPrimaryColor
                                        : Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                              )
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
