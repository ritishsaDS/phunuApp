import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/Api.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/components/bottom.dart';
import 'package:http/http.dart' as http;
import 'package:vietnamese/screens/Dashboard/dashboard.dart';
import 'package:vietnamese/screens/Login/login.dart';
import 'package:vietnamese/screens/notes/alerts/period_ended.dart';
import 'package:vietnamese/screens/settings/PinAndRegister/pin_register_screen.dart';
import 'package:vietnamese/screens/settings/alerts/cycle_length.dart';
import 'package:vietnamese/screens/settings/components/genral_list_tile.dart';
import 'package:vietnamese/screens/settings/components/privacy_policy.dart';

import 'alerts/period_length.dart';
import 'components/pregnent_tile.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isLoading = false;
  String token;
  bool isError;
  var mensturllength;
  var perioddate;
  bool switchVal = false;
  String startdate = "28";
  String enddate = "20";
  String formattedDate;
  Widget _widget;
  var login;
  @override
  void initState() {
    getSettings();
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    formattedDate = formatter.format(now);
    print(formattedDate);
    getdetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                child: isLoading
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: SizeConfig.screenHeight / 2,
                          ),
                          Center(
                            child: CircularProgressIndicator(
                              backgroundColor: kPrimaryColor,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          BottomTabs(5, true),
                          HeightBox(
                            getProportionateScreenHeight(20),
                          ),
                          GenralListTile(
                            title: 'Period Length',
                            tileType: TileType.subtext,
                            subtitle: '($startdate Days)',
                            onTap: () async {
                              perioddate = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CycleLenghtAlert());
                              print(perioddate);
                              setState(() {
                                if (perioddate == null) {
                                  startdate = "28";
                                } else {
                                  startdate = perioddate;
                                }
                              });
                              print("BCSJJJnnjnj");
                            },
                          ),
                          GenralListTile(
                            title: 'Menstrual Period',
                            tileType: TileType.subtext,
                            subtitle: '($enddate Days)',
                            onTap: () async {
                              mensturllength = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      PeriodLenghtAlert());
                              setState(() {
                                print(mensturllength);
                                if (mensturllength == null) {
                                  enddate = "20";
                                } else {
                                  enddate = mensturllength;
                                }
                              });
                            },
                          ),
                          Padding(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                          inactiveThumbColor:
                                              kPrimaryLightColor,
                                          onChanged: (val) {
                                            setState(() {
                                              switchVal = val;
                                            });
                                          }),
                                    ],
                                  ),
                                  switchVal == true
                                      ? Container(
                                          height:
                                              getProportionateScreenHeight(100),
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                getProportionateScreenWidth(25),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Start of pregnancy',
                                                //style: subTitle,
                                              ),
                                              Container(
                                                height:
                                                    getProportionateScreenHeight(
                                                        40),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      getProportionateScreenWidth(
                                                          10),
                                                ),
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: kPrimaryColor),
                                                  borderRadius:
                                                      BorderRadius.circular(26),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${formattedDate.replaceAll("-", "/").replaceAll("00:00:00.000", "")}",

                                                      /// style: date,
                                                    ),
                                                    AlertIcon(
                                                        iconPath:
                                                            "assets/icons/calender.png",
                                                        onTap: () {
                                                          getdate();
                                                        })
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                          GenralListTile(
                              title: 'Back up And Restore',
                              onTap: () {
                                backup();
                              }),
                          GenralListTile(
                              title: 'Pin And Register',
                              onTap: () {
                                if (login == null) {
                                  showAlertDialog(context);
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PinRegisterScreen(),
                                      ));
                                }
                              }),
                          GenralListTile(title: 'Report Bug', onTap: null),
                          GenralListTile(
                              title: 'Suggest Features', onTap: null),
                          GenralListTile(
                            title: 'Share',
                            onTap: share,
                          ),
                          GenralListTile(
                              title: 'Update Settings',
                              onTap: () {
                                updateSetting();
                              }),
                          GenralListTile(
                              title: 'Erase Personal Data',
                              onTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.clear();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DashboardScreen()));
                              }),
                          GenralListTile(
                            title: 'Privacy Policy',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PrivacyPolicy(),
                              ),
                            ),
                          ),
                          login == null
                              ? Container()
                              : GenralListTile(
                                  title: login == null ? 'Login' : "Logout",
                                  onTap: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    print(prefs.getString("email"));
                                    setState(() {
                                      prefs.remove("email");
                                      getdetail();
                                    });
                                    // Navigator.pushReplacement(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => LoginScreen()));
                                  }),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  dynamic settingfromserver = new List();
  Future<void> getSettings() async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    print(token);
    try {
      final response = await http.post(getSetting, headers: {
        'Authorization': 'Bearer $token',
      });
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        settingfromserver = responseJson;
        print(settingfromserver);

        setState(() {
          isError = false;
          isLoading = false;
          print('setstate');
        });
      } else {
        print("bjkb" + response.statusCode.toString());

        setState(() {
          isError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print("uhdfuhdfuh");
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  Future<void> updateSetting() async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    print(token);
    try {
      final response = await http.post(updatesetings, headers: {
        'Authorization': 'Bearer $token',
      }, body: {
        "is_pregnency": switchVal.toString(),
        "period_length": startdate,
        "menstural_period": enddate
      });
      print(response.statusCode.toString());
      print(perioddate.toString());
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        settingfromserver = responseJson;
        print(settingfromserver);
        showToast("Settings  Updated Succesfully");
        Navigator.pop(context);
        setState(() {
          isError = false;
          isLoading = false;
          print('setstate');
        });
      } else {
        print("bjkb" + response.statusCode.toString());

        setState(() {
          isError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print("uhdfuhdfuh");
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  Future<void> getdetail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      login = preferences.getString("email");
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = Container(
      decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(
            15.0,
          ),
          color: kPrimaryColor),
      child: FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "Cancel",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.all(0),
      //  backgroundColor: kPrimaryColor,

      content: Container(
        height: SizeConfig.screenHeight / 5,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              child: Center(
                child: Text(
                  "You Have to Login First",
                  style: TextStyle(
                      color: kPrimaryColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: 'Example share text',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title');
  }

  dynamic backuplist = List();
  Future<void> backup() async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    print(token);
    try {
      final response = await http.post(
        backupapi,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print(response.statusCode.toString());
      print(perioddate.toString());
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        backuplist = responseJson;
        print(backuplist);
        showToast("Bakcup  Updated Succesfully");
        Navigator.pop(context);
        setState(() {
          isError = false;
          isLoading = false;
          print('setstate');
        });
      } else {
        print("bjkb" + response.statusCode.toString());

        setState(() {
          isError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print("uhdfuhdfuh");
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }
}
