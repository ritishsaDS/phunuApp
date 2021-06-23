import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vietnamese/common/Api.dart';
import 'package:vietnamese/screens/Dashboard/dashboard.dart';
import 'package:vietnamese/screens/Login/login.dart';
import 'package:vietnamese/screens/lunar.dart';
import 'package:vietnamese/screens/signup/signUp.dart';
import 'common/constants.dart';
import 'common/theme.dart';
import 'package:intl/date_symbol_data_local.dart';

final Map<DateTime, List> _holidays = {
  DateTime(2020, 12, 25): ['Christmas Day'],
  DateTime(2021, 1, 1): ['New Year\'s Day'],
  DateTime(2021, 1, 6): ['Epiphany'],
  DateTime(2021, 2, 14): ['Valentine\'s Day'],
};

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = false;
  bool isError = false;
  @override
  void initState() {
   _getId();
    // _mockCheckForSession();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Vietnamese Women',
        theme: theme(),
        debugShowCheckedModeBanner: false,
        home: DashboardScreen());
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
        setState(() {
          isError = false;
          isLoading = false;
          print('setstate');
        });
      } else {
        print("bssddsdjkb" + response.statusCode.toString());
      //  showToast("Mismatch Credentials");
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
    } 
    else if(loginwithserver['data']['email'] == null){
       prefs.setString("user_type", loginwithserver['data']['user_type']);

      prefs.setInt("login_count", loginwithserver['data']['login_count']);
      prefs.setString("deviceid", deviceid);
      // prefs.setInt("password", loginwithserver['data']['password']);
      prefs.setString("token", loginwithserver['access_token']);

    }else {
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
}
