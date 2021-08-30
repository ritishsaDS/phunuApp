import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:intl/intl.dart';
import 'package:mailto/mailto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/Api.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/components/bottom.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:http/http.dart' as http;
import 'package:vietnamese/screens/Dashboard/dashboard.dart';
import 'package:vietnamese/screens/Login/login.dart';
import 'package:vietnamese/screens/notes/alerts/period_ended.dart';
import 'package:vietnamese/screens/notes/Mailtoclass.dart';
import 'package:vietnamese/screens/settings/PinAndRegister/pin_register_screen.dart';
import 'package:vietnamese/screens/settings/alerts/cycle_length.dart';
import 'package:vietnamese/screens/settings/components/genral_list_tile.dart';
import 'package:vietnamese/screens/settings/components/privacy_policy.dart';
import 'package:vietnamese/screens/settings/suggestfeatures.dart';
import 'package:vietnamese/screens/signup/signUp.dart';

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
  var pregnancy;
  var perioddate;
  bool switchVal = false;
  String startdate = "28";
  String enddate = "4";
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
                            title: 'Chu kỳ kinh',
                            tileType: TileType.subtext,
                            subtitle: '($startdate ngày)',
                            onTap: () async {
                              perioddate = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CycleLenghtAlert(day:startdate));
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
                            title: 'Số ngày đèn đỏ',
                            tileType: TileType.subtext,
                            subtitle: '($enddate ngày)',
                            onTap: () async {
                              mensturllength = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      PeriodLenghtAlert(day:enddate));
                              setState(() {
                                print(mensturllength);
                                if (mensturllength == null) {
                                  enddate = "4";
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
                                        'Tôi có thai!',
                                        style: TextStyle(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Switch(
                                          value: switchVal,
                                          inactiveThumbColor:
                                              kPrimaryLightColor,
                                          onChanged: (val) async {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            setState(() {
                                              switchVal = val;

                                              prefs.setBool(
                                                  "pregnancy", switchVal);
                                              print(prefs.getBool("pregnancy"));
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
                                                'Bắt đầu mang thai',
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
                              title: 'Lưu và phục hồi',
                              onTap: () {
                                backup();
                              }),
                          GenralListTile(
                              title: 'Khóa bằng PIN',
                              onTap: () {
                                if (login == null) {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => PinRegisterScreen()));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PinRegisterScreen(),
                                      ));
                                }
                              }),
                          GenralListTile(
                              title: 'Báo cáo lỗi',
                              onTap: () async{
                                final url = Mailto(
                                  to: [
                                    'Phunuvietapplication@gmail.com',

                                  ],

                                  subject: 'Báo cáo lỗi cho Phụ Nữ Việt',
                                  body:
                                  ''
                                ).toString();
                                if (await canLaunch(url) != null) {
                                await launch(url);
                                } else {
                                showCupertinoDialog(
                                context: context,
                                builder: MailClientOpenErrorDialog(url: url).build,
                                );
                                }
                                // openEmailApp(context,"Báo cáo lỗi cho Phụ Nữ Việt");
                                   // _modalBottomSheetMenu(  "Report Bug",
                                   //          "Báo cáo lỗi cho Phụ Nữ Việt",);
                                
                              }),
                          GenralListTile(
                              title: 'Đề nghị với PNV',
                              onTap: () async{
                                final url = Mailto(
                                    to: [
                                      'Phunuvietapplication@gmail.com',

                                    ],

                                    subject: 'Đề nghị chức năng với app Phụ Nữ Việ',
                                    body:
                                    ''
                                ).toString();
                                if (await canLaunch(url) != null) {
                                await launch(url);
                                } else {
                                showCupertinoDialog(
                                context: context,
                                builder: MailClientOpenErrorDialog(url: url).build,
                                );
                                }
                                // openEmailApp(context,"Đề nghị chức năng với app Phụ Nữ Việ");
                                // // _modalBottomSheetMenu( "Suggest Features",
                                //            "Đề nghị chức năng với app Phụ Nữ Việ",);
                                //  openEmailApp(context);
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => suggestfeatures(
                                //             title: "Suggest Features",
                                //             subject: "Đề nghị chức năng app",
                                //             email: login)));
                              }),
                          GenralListTile(
                            title: 'Chia sẻ',
                            onTap: share,
                          ),
                          GenralListTile(
                              title: 'Cập nhật các thay đổi',
                              onTap: () {
                                updateSetting();
                              }),
                          GenralListTile(
                              title: 'Xóa mọi thông tin',
                              onTap: () async {
                                showdialogforerase(context);


                              }),
                          GenralListTile(
                            title: 'Chính sách riêng tư',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PrivacyPolicy(),
                              ),
                            ),
                          ),
                          // login == null
                          //     ? Container()
                          //     : GenralListTile(
                          //         title:
                          //             login == null ? 'Login' : "Đã đăng xuấ",
                          //         onTap: () async {
                          //           SharedPreferences prefs =
                          //               await SharedPreferences.getInstance();
                          //           print(prefs.getString("email"));
                          //           setState(() {
                          //             prefs.remove("email");
                          //             getdetail();
                          //           });
                          //           // Navigator.pushReplacement(
                          //           //     context,
                          //           //     MaterialPageRoute(
                          //           //         builder: (context) => LoginScreen()));
                          //         }),
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
    pregnancy = prefs.getBool("pregnancy");
    print(pregnancy);
    if (pregnancy == true) {
      switchVal = true;
    } else {
      switchVal = false;
    }
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
        showToast("PNV đã lưu cài đặt của bạn");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SettingScreen()));
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
    if (preferences.getString("cyclelength") != null) {
      setState(() {
        startdate = preferences.getString("cyclelength");
      });
    } else {
      startdate = "28";
    }
    if (preferences.getString("periodlength") != null) {
      setState(() {
        enddate = preferences.getString("periodlength");
      });
    } else {
      enddate = "4";
    }
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
          "bỏ",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    Widget register = Container(
      decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(
            15.0,
          ),
          color: kPrimaryColor),
      child: FlatButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignUpScreen()));
        },
        child: Text(
          "Đăng ký",
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
                  "Trước tiên, bạn phải đăng nhập",
                  style: TextStyle(
                      color: kPrimaryColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [okButton, register],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  showdialogforerase(BuildContext context) {
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
          "Đừng xóa",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    Widget register = Container(
      decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(
            15.0,
          ),
          color: kPrimaryColor),
      child: FlatButton(
        onPressed: () async {

          erasedata();
        },
        child: Text(
          "Xóa",
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
                  "Bạn chắc chắn muốn xóa hết thông tin?",
                  style: TextStyle(
                      color: kPrimaryColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [okButton, register],
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
        formattedDate=DateTime.parse(formattedDate).day.toString()+"/"+DateTime.parse(formattedDate).month.toString()+"/"+DateTime.parse(formattedDate).year.toString();
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
        showToast("Đã cập nhật BackUp thành công");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingScreen()));
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
  Future<void> erasedata() async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    print(token);
    try {
      final response = await http.post(
        Erasedataapi,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print(response.statusCode.toString());
      print(perioddate.toString());
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        SharedPreferences prefs =
        await SharedPreferences.getInstance();
       prefs.remove("alert");
       prefs.remove("nextperiod");
       prefs.remove("fertilewindow");
        print("erase");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SettingScreen()));
        showToast("Đã xóa mọi thông tin");
       /// Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingScreen()));
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
  Future<void> openEmailApp(BuildContext context,subject) async {
    List<String> tooo=['ritishs39@gmail.com'] ;
      final url = Mailto(

to: tooo,
        subject: "",
           ).toString();
      if (await canLaunch(url)) {
    await launch(url);
    } else {
    showCupertinoDialog(
    context: context,
    builder: MailClientOpenErrorDialog(url: url).build,
    );
    }

  }

  void _modalBottomSheetMenu(title,subject) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            height: 150.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: new Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Container(
                          child: Column(
                        children: [
                          MaterialButton(
                            onPressed: () {
                               Navigator.push(
                                    context,
                                     MaterialPageRoute(
                                         builder: (context) => suggestfeatures(
                                             title: title,
                                             subject: subject,
                                            email: login)));
                            },
                            color: Colors.white,
                            textColor: Colors.white,
                            child: Image.asset(
                              'assets/icons/home_white.png',
                              height: 30,
                            ),
                            padding: EdgeInsets.all(16),
                            shape: CircleBorder(),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Open in Phu Nu Viét",
                            style: TextStyle(
                                color: Colors.pinkAccent,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          )
                        ],
                      )),
                    ),
                    Container(
                        child: Column(
                      children: [
                        MaterialButton(
                          onPressed: () {
                            openEmailApp(context,subject);
                          },
                          color: Colors.white,
                          textColor: Colors.white,
                          child: Image.asset(
                            'assets/icons/gmail.png',
                            height: 30,
                          ),
                          padding: EdgeInsets.all(16),
                          shape: CircleBorder(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Open in Gmail",
                          style: TextStyle(
                              color: Colors.pinkAccent,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        )
                      ],
                    ))
                  ],
                ))),
          );
        });
  }
}
