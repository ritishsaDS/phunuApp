import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/components/common_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vietnamese/common/Api.dart';

class PinButton extends StatefulWidget {
  dynamic email;
  dynamic pass;

  dynamic province;
  PinButton({this.email, this.pass, this.province});
  @override
  _PinButtonState createState() => _PinButtonState();
}

class _PinButtonState extends State<PinButton> {
  String token;
  bool isError = false;
  bool isLoading = false;

  int _radioValue = 0;
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

  @override
  void initState() {
    getageValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
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
              CommonButton(
                title: 'Cancel',
                onTap: () => Navigator.of(context).pop(),
              ),
              CommonButton(
                title: 'Confirm',
                onTap: () {
                  updateprofile();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  dynamic settingfromserver = new List();
  Future<void> updateprofile() async {
    print(widget.email);
    print(widget.pass);
    print(widget.province);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    setState(() {
      getageValue();
      print(widget.email);
    });
    try {
      final response = await http.post(updateprofileonserver, headers: {
        'Authorization': 'Bearer $token',
      }, body: {
        'email': widget.email,
        'pin': widget.pass,
        "province": widget.province,
        "age_range": age
      });
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        settingfromserver = responseJson;

        prefs.setString("email", settingfromserver['data']['email']);
        // prefs.setString("province", settingfromserver['data']['province']);
        // prefs.setString("key", settingfromserver['data']['age_range']);

        print(prefs.getString("email"));
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
}
