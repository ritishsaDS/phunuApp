import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vietnamese/common/Api.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/components/logo.dart';
import 'package:vietnamese/screens/Dashboard/dashboard.dart';

import 'login_background.dart';
import 'package:http/http.dart' as http;

class PinField extends StatefulWidget {
  dynamic email;
  dynamic message;
  PinField({this.email, this.message});
  @override
  _PinFieldState createState() => _PinFieldState();
}

class _PinFieldState extends State<PinField> {
  TextEditingController pincontroller = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool isLoading = false;
  String pass;
  bool isError = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    pincontroller.dispose();
    focusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Stack(
      children: [
        LoginBackground(),
        Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: getProportionateScreenHeight(350),
                    ),
                    Center(
                      child: Text(
                        widget.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    PinCodeFields(
                      length: 4,
                      keyboardType: TextInputType.number,
                      borderColor: Colors.white,
                      controller: pincontroller,
                      focusNode: focusNode,
                      onComplete: (result) {
                        // Your logic with code
                        print(result);
                        setState(() {
                          pass = result;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        signin();
                      },
                      child: Container(
                        height: getProportionateScreenHeight(50),
                        width: getProportionateScreenWidth(120),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: kPrimaryLightColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 12.0,
                              spreadRadius: 1.0,
                              offset: Offset(6.0, 6.0),
                            ),
                          ],
                        ),
                        child: isLoading
                            ? CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              )
                            : Text(
                                "SIGNIN",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    )
                  ]),
            )),
        Positioned(
          top: getProportionateScreenHeight(100),
          left: getProportionateScreenWidth(20),
          child: Logo(),
        ),
        Positioned(
          top: getProportionateScreenHeight(40),
          left: getProportionateScreenWidth(20),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: kPrimaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    ));
  }

  dynamic loginwithserver = new List();
  signin() async {
    setState(() {
      isLoading = true;
    });
    print(pass);
    try {
      final response = await http.post(login, body: {
        "email": widget.email,
        "password": pass,
      });
      print("bjkb" + response.statusCode.toString());
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        loginwithserver = responseJson;
        // print(loginwithserver['data']['email']);
        print(loginwithserver);

        // showToast("");
        savedata();
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

  Future<void> savedata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("email", loginwithserver['data']['email']);
    prefs.setString("password", pass);
    prefs.setString("token", loginwithserver['access_token']);
    //prefs.setString('email', emailController.text);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => DashboardScreen()));
  }
}
