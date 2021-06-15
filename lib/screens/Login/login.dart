import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vietnamese/common/Api.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/components/logo.dart';
import 'package:vietnamese/screens/Dashboard/dashboard.dart';
import 'package:vietnamese/screens/Login/components/login_body.dart';
import 'components/login_background.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool isError = false;
  @override
  void initState() {
   // _getId();
    // _mockCheckForSession();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Stack(
        children: [
          LoginBackground(),
          LoginBody(),
          Positioned(
            top: getProportionateScreenHeight(50),
            left: getProportionateScreenWidth(20),
            child: Logo(),
          ),
        ],
      ),
    );
  }

  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 1), () {});
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');

    runApp(
        MaterialApp(home: email == null ? LoginScreen() : DashboardScreen()));
    return true;
  }

  

  
  //print("osnanl" + usernameString);
  // bool isvalid = EmailValidator.validate(usernameString);

}
