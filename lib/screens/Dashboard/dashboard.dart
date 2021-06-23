import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/Api.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/screens/Dashboard/components/adArea.dart';
import 'package:vietnamese/screens/Dashboard/components/appBar.dart';
import 'package:vietnamese/screens/Dashboard/components/card_section.dart';
import 'package:vietnamese/screens/Dashboard/components/dasboard_title.dart';
import 'package:vietnamese/screens/Dashboard/components/dashboard_date.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var formatter;
  String formattedDate;
  bool isLoading = false;
  String token;
  bool isError;
  var getnext = "       ";
  var getfertile = "       ";
  var periodno = "3";
  DateTime selectedDate = DateTime.now();

  DateTime end;
  @override
  void initState() {
    _getId();

    var now = new DateTime.now();
    formatter = new DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
    print(formattedDate);
    // getDay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          Container(
            child: isLoading
                ? Column(children: [
                    CommonAppBar(),
                    DashboardDate(),
                    //  DashboardTitle(),
                    DashboardDate(),
                    CardSection(),
                  ])
                : Column(
                    children: [
                      CommonAppBar(),
                      DashboardTitle(day: periodno),

                      BodyContent(
                        title: 'Next Period Date',
                        date: getnext
                            .toString()
                            .replaceAll("-", "/")
                            .substring(5),
                      ),
                      HeightBox(getProportionateScreenHeight(10)),
                      BodyContent(
                        title: 'Fertile Window Starts',
                        date:  getfertile
                            .toString()
                            .replaceAll("-", "/")
                            .substring(5),
                      ),

                      // DashboardDate(),
                      CardSection(),
                      Spacer(),
                      AdArea()
                    ],
                  ),
          ),
        ],
      )),
    );
  }

  void getalert() async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString("alert");
    var alert;
    alert = prefs.getString("alert");
    print(alert);

    if (alert == null) {
      showAlertDialog(context);
    } else {
      getNextperiod();
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
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          if (selectedDate == null) {
            return Text("Plese Select Date first");
          } else {
            sendperioddate(selectedDate);
          }
          // Navigator.pop(context);
        },
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
                  "Please Select Your Date",
                  style: TextStyle(
                      color: kPrimaryColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(color: kPrimaryColor),
                    borderRadius: BorderRadius.circular(
                      15.0,
                    ),
                  ),
                  child: Center(
                      child: Text(
                    "Period Just Start \n Click Here",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kPrimaryColor),
                  ))),
              onTap: () {
                getdate();
              },
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
      initialDate: selectedDate,
      firstDate: DateTime(2021, 4),
      lastDate: DateTime(2022, 5),
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
    if (pickedDate != null && pickedDate != selectedDate)
      setState(() async {
        selectedDate = pickedDate;
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("selected", selectedDate.toString());
        print(selectedDate);
        // getenddate();
      });
  }

  getenddate() async {
    final DateTime enddate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021, 4),
      lastDate: DateTime(2022, 5),
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
    if (enddate != null && enddate != selectedDate)
      setState(() async {
        end = enddate;
        print(end);
      });
  }

  dynamic settingfromserver = new List();
  Future<void> sendperioddate(date) async {
    // isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    print("ddffd" + token);
    try {
      final response = await http.post(getperiodsdate, headers: {
        'Authorization': 'Bearer $token',
      }, body: {
        "start_date": date.toString(),
       
      });
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        settingfromserver = responseJson;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("alert", "true");
        prefs.setString("startdate", date.toString());
        Navigator.pop(context);
        // print("lvnsdlm l" + settingfromserver);
        getNextperiod();
        setState(() {
          isError = false;
          isLoading = true;
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
      print(e);
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      print(iosDeviceInfo.identifierForVendor);
      await signin(iosDeviceInfo.identifierForVendor);
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      print(androidDeviceInfo.androidId);
      await signin(androidDeviceInfo.androidId);
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  dynamic firstloginlist = new List();
  dynamic loginwithserver = new List();
  signin(deviceid) async {
    print(deviceid);
    try {
      final response = await http.post(firstlogin, body: {
        "device_id": deviceid,
        "pin": "1234",
      });
      //print("bjkb" + response.statusCode.toString());
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        firstloginlist = responseJson;
        // print(loginwithserver['data']['email']);
        print(firstloginlist);
        loginasguest(deviceid);
        // showToast("");
        // savedata();
        setState(() {
          isError = false;
          isLoading = false;
          print('setstate');
        });
      } else {
        print("bjkb" + response.statusCode.toString());
        showToast("Mismatch Credentials");
        setState(() {
          isError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  Future<void> loginasguest(deviceid) async {
    try {
      final response = await http.post(login, body: {
        "device_id": deviceid,
        "password": "1234",
      });
      //print("bjkb" + response.statusCode.toString());
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        loginwithserver = responseJson;
        // print(loginwithserver['data']['email']);
        print(loginwithserver);
        // loginasguest(deviceid);
        // showToast("");
        savedata(deviceid);
        gettoken();
        getalert();
        setState(() {
          isError = false;
          isLoading = false;
          print('setstate');
        });
      } else {
        print("bjkb" + response.statusCode.toString());
        showToast("Mismatch Credentials");
        setState(() {
          isError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  Future<void> savedata(deviceid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (loginwithserver['data']['login_count'] == null) {
      prefs.setString("user_type", loginwithserver['data']['user_type']);

      //  prefs.setInt("login_count", loginwithserver['data']['login_count']);
      prefs.setString("deviceid", deviceid);
      // prefs.setInt("password", loginwithserver['data']['password']);
      prefs.setString("token", loginwithserver['access_token']);
    } else if (loginwithserver['data']['email'] == null) {
      prefs.setString("user_type", loginwithserver['data']['user_type']);

      prefs.setInt("login_count", loginwithserver['data']['login_count']);
      prefs.setString("deviceid", deviceid);
      // prefs.setInt("password", loginwithserver['data']['password']);
      prefs.setString("token", loginwithserver['access_token']);
    } else {
      prefs.setString("email", loginwithserver['data']['email']);
      prefs.setString("user_type", loginwithserver['data']['user_type']);

      prefs.setInt("login_count", loginwithserver['data']['login_count']);
      prefs.setString("deviceid", deviceid);
      // prefs.setInt("password", loginwithserver['data']['password']);
      prefs.setString("token", loginwithserver['access_token']);
      //prefs.setString('email', emailController.text);
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>DashboardScreen()));
    }
  }

  dynamic nextfromserver = new List();
  Future<void> getNextperiod() async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    print(token);
    try {
      final response = await http.post(
        nexperiod,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        nextfromserver = responseJson;
        print(nextfromserver);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs.getString("nextdate") == null) {
          prefs.setString(
              "nextdate", nextfromserver['data']['next_period_date']);
          prefs.setString(
              "fertilewindow", settingfromserver['fertile_window_starts']);
          getnext = prefs.getString("nextdate");
          getfertile = prefs.getString("fertilewindow");

          print(getnext);
          getDay();
        } else {
          getnext = prefs.getString("nextdate");
           getfertile = prefs.getString("fertilewindow");
          getDay();
        }

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
      print(e);
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  Future<void> getDay() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var select = preferences.getString("selected");
    print("toays dayt" + select.toString().substring(8, 10));
    print("toays dayt" + formattedDate.toString().substring(8, 10));
    print(
        "${DateTime.parse(formattedDate).difference(DateTime.parse(select)).inDays}");
    periodno = (DateTime.parse(formattedDate)
            .difference(DateTime.parse(select))
            .inDays)
        .toString();
  }

  Future<void> gettoken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
  }
}

class BodyContent extends StatelessWidget {
  const BodyContent({Key key, @required this.title, @required this.date})
      : super(key: key);

  final String title;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(15),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
              vertical: getProportionateScreenHeight(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: kPrimaryColor, fontWeight: FontWeight.w600),
                ),
                Text(
                  date == null ? "" : date,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
