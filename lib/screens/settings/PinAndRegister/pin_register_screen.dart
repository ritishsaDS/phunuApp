import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/Api.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:http/http.dart' as http;
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/screens/settings/PinAndRegister/widgets/age_card.dart';
import 'package:vietnamese/screens/settings/PinAndRegister/widgets/pin_button.dart';
import 'package:vietnamese/screens/settings/PinAndRegister/widgets/pin_header.dart';
import 'package:vietnamese/screens/settings/PinAndRegister/widgets/pin_text_field.dart';

class PinRegisterScreen extends StatefulWidget {
  @override
  _PinRegisterScreenState createState() => _PinRegisterScreenState();
}

class _PinRegisterScreenState extends State<PinRegisterScreen> {
  String email;
  String pin;
  TextEditingController emailcontroller;
  TextEditingController passcontroller;
  TextEditingController provincecontroller;
  String pass;
  int selected = 0;
  String token;
  bool isError = false;
  bool isLoading = false;

  int _radioValue;
  String age = "Under 18";

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      print(_radioValue);
      switch (_radioValue) {
        case 0:
          age = "Under 18";
          break;
        case 1:
          age = " 18-25";
          break;
        case 2:
          age = "25-30";
          break;
        case 3:
          age = "30-40";
          break;
        case 4:
          age = "40=45";
          break;
        case 5:
          age = "50-55";
          break;
      }
    });
  }

  String province = "";
  @override
  void initState() {
    getuserdetail();

    //emailcontroller = TextEditingController(text: email);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  String text;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              PinHeaderBar(),
              HeightBox(
                getProportionateScreenHeight(20),
              ),
              // PinTextField(
              //   getText: email,
              //   hintText: email,
              //   suggestionText:
              //       'If you forgot your PIN,use email address to set new',
              // ),
              // PinTextField(
              //   hintText: 'Province*',
              //   suggestionText: 'Assistive Text',
              // ),
              Padding(
                padding: EdgeInsets.only(
                  left: getProportionateScreenWidth(10),
                  right: getProportionateScreenWidth(10),
                  bottom: getProportionateScreenHeight(10),
                ),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(10),
                          right: getProportionateScreenWidth(10),
                          bottom: getProportionateScreenHeight(10),
                        ),
                        child: TextField(
                          style: TextStyle(color: kPrimaryLightColor),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            isDense: true,
                            focusColor: kPrimaryLightColor,
                            hoverColor: kPrimaryLightColor,
                            hintStyle: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                            hintText: "Email",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 42, vertical: 20),
                            enabledBorder: outlineInputBorder,
                            focusedBorder: outlineInputBorder,
                            border: outlineInputBorder,
                          ),
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          controller: emailcontroller,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(10),
                          right: getProportionateScreenWidth(10),
                          bottom: getProportionateScreenHeight(10),
                        ),
                        child: TextField(
                          style: TextStyle(color: kPrimaryLightColor),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            isDense: true,
                            focusColor: kPrimaryLightColor,
                            hoverColor: kPrimaryLightColor,
                            hintStyle: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                            hintText: "Pin",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 42, vertical: 20),
                            enabledBorder: outlineInputBorder,
                            focusedBorder: outlineInputBorder,
                            border: outlineInputBorder,
                          ),
                          onChanged: (value) {
                            setState(() {
                              pass = value.toString();
                              //  pass = pin.toString();
                              print(pass.toString());
                            });
                          },
                          controller: passcontroller,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(10),
                          right: getProportionateScreenWidth(10),
                          bottom: getProportionateScreenHeight(10),
                        ),
                        child: TextField(
                          style: TextStyle(color: kPrimaryLightColor),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            isDense: true,
                            focusColor: kPrimaryLightColor,
                            hoverColor: kPrimaryLightColor,
                            hintStyle: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                            hintText: "Province",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 42, vertical: 20),
                            enabledBorder: outlineInputBorder,
                            focusedBorder: outlineInputBorder,
                            border: outlineInputBorder,
                          ),
                          onChanged: (value) {
                            setState(() {
                              province = value;
                            });
                            print(province);
                          },
                          controller: provincecontroller,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.1),
                            blurRadius: 16.0,
                            spreadRadius: 5.0,
                            offset: Offset(0, 0),
                          )
                        ],
                      ),
                      child: Age(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(10)),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            alignment: Alignment.center,
                            width: getProportionateScreenWidth(100),
                            height: getProportionateScreenHeight(30),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(10)),
                        child: GestureDetector(
                          onTap: () => updateprofile(),
                          child: Container(
                            alignment: Alignment.center,
                            width: getProportionateScreenWidth(100),
                            height: getProportionateScreenHeight(30),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),

              //  AgeCard(),
            ],
          ),
        ),
      ),
    );
  }

  dynamic settingfromserver = new List();
  Future<void> updateprofile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    setState(() {
      getageValue();
      print("kanklsn" + age.toString());
    });
    try {
      final response = await http.post(updateprofileonserver, headers: {
        'Authorization': 'Bearer $token',
      }, body: {
        'email': email,
        'pin': pin.toString(),
        "province": province,
        "age_range": age
      });
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        settingfromserver = responseJson;

        // prefs.setString("email", settingfromserver['data']['email']);
        prefs.setString("province", settingfromserver['data']['province']);
        prefs.setString("age_range", settingfromserver['data']['age_range']);
        //  prefs.setString("password", settingfromserver['pin']);
        // prefs.setString("province", settingfromserver['data']['province']);
        // prefs.setString("key", settingfromserver['data']['age_range']);
        print(settingfromserver);
        //  print(prefs.getInt('password'));
        //print(settingfromserver['pin'] + 0000);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => PinRegisterScreen()));
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
      print(e);
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  void getageValue() {
    if (_radioValue == 1) {
      age = "18-25";
    } else if (_radioValue == 2) {
      age = "26-35";
    } else if (_radioValue == 3) {
      age = "36-45";
    } else if (_radioValue == 4) {
      age = "46-55";
    } else if (_radioValue == 5) {
      age = "55+";
    } else {
      age = "Under 18";
    }
  }

  Widget Age() {
    return Container(
      width: SizeConfig.screenWidth,
      height: getProportionateScreenHeight(150),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
        vertical: getProportionateScreenHeight(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Age range*',
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.w600,
              fontSize: getProportionateScreenHeight(16),
            ),
          ),
          HeightBox(
            getProportionateScreenHeight(10),
          ),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.spaceBetween,
            runSpacing: getProportionateScreenHeight(5),
            spacing: getProportionateScreenWidth(70),
            children: [
              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  height: getProportionateScreenHeight(23),
                  width: getProportionateScreenWidth(23),
                  child: new Radio(
                    value: 0,
                    groupValue: _radioValue,
                    focusColor: (kPrimaryColor),
                    onChanged: _handleRadioValueChange,
                  ),
                ),
                new Text(
                  'Under 18',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ]),
              Container(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    height: getProportionateScreenHeight(23),
                    width: getProportionateScreenWidth(23),
                    child: new Radio(
                      value: 1,
                      groupValue: _radioValue,
                      focusColor: (kPrimaryColor),
                      onChanged: _handleRadioValueChange,
                    ),
                  ),
                  new Text('18 - 25',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )),
                ]),
              ),
              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  height: getProportionateScreenHeight(23),
                  width: getProportionateScreenWidth(23),
                  child: new Radio(
                    value: 2,
                    groupValue: _radioValue,
                    focusColor: (kPrimaryColor),
                    onChanged: _handleRadioValueChange,
                  ),
                ),
                new Text(
                  '26 - 35',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ]),
              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  height: getProportionateScreenHeight(23),
                  width: getProportionateScreenWidth(23),
                  child: new Radio(
                    value: 3,
                    groupValue: _radioValue,
                    focusColor: (kPrimaryColor),
                    onChanged: _handleRadioValueChange,
                  ),
                ),
                new Text(
                  '35 - 45',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ]),
              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  height: getProportionateScreenHeight(23),
                  width: getProportionateScreenWidth(23),
                  child: new Radio(
                    value: 4,
                    groupValue: _radioValue,
                    focusColor: (kPrimaryColor),
                    onChanged: _handleRadioValueChange,
                  ),
                ),
                new Text(
                  '46 - 55',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ]),
              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  height: getProportionateScreenHeight(23),
                  width: getProportionateScreenWidth(23),
                  child: new Radio(
                    value: 5,
                    focusColor: (kPrimaryColor),
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                ),
                new Text(
                  '55 +     ',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ]),

              // PinCheckBox(lable: 'Under 18', value: 1),
              // PinCheckBox(lable: '18 - 25', value: 2),
              // PinCheckBox(lable: '26 - 35', value: 3),
              // PinCheckBox(lable: '35 - 45', value: 4),
              // PinCheckBox(lable: '46 - 55', value: 5),
              // PinCheckBox(lable: '55 +     ', value: 6),
            ],
          ),
        ],
      ),
    );
  }

  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: kPrimaryColor),
    gapPadding: 10,
  );

  void getuserdetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      email = prefs.getString("email");
      // pin = prefs.getString("password");
      if (prefs.getString("province") == null) {
        setState(() {
          province = "";
        });
      } else {
        setState(() {
          province = prefs.getString("province");
          provincecontroller = TextEditingController(text: province);
        });
      }
      if (prefs.getString("age_range") == null) {
      } else {
        String age_value = prefs.getString("age_range");
        print(age_value);
      }
      emailcontroller = TextEditingController(text: email);
      passcontroller = TextEditingController(text: pin.toString());
      print(email);
    });
  }
}
