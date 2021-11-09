import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/Api.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/components/common_button.dart';

import '../settings.dart';

class CycleLenghtAlert extends StatefulWidget {
  dynamic day;
  CycleLenghtAlert({this.day});
  @override
  _CycleLenghtAlertState createState() => _CycleLenghtAlertState();
}

class _CycleLenghtAlertState extends State<CycleLenghtAlert> {
  int text = 28;
  bool  isError = false;
  bool isLoading = false;

  final TextStyle title = TextStyle(
    fontSize: getProportionateScreenHeight(18),
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  bool average = false;
  bool irregularcycle = false;
  final TextStyle subTitle = TextStyle(
    fontSize: getProportionateScreenHeight(16),
    color: kPrimaryColor,
  );
  @override
  void initState() {
    text=int.parse(widget.day);
    // TODO: implement initState
    getswitchvlue();
    super.initState();
  }

  final TextStyle date =
      TextStyle(fontSize: getProportionateScreenHeight(12), color: kTextColor);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(context),
              buildTitle(),
              Divider(),
              buildButton(context)
            ],
          ),
        ),
      ),
    );
  }

  buildHeader(context) {
    return Container(
      height: getProportionateScreenHeight(45),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        color: kPrimaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Chu kỳ kinh',
            style: title,
          ),
          IconButton(
              icon: Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: getProportionateScreenHeight(20),
              ),
              onPressed: () => Navigator.of(context).pop())
        ],
      ),
    );
  }

  buildTitle() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(25),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: getProportionateScreenHeight(100),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  shape: const CircleBorder(),
                  color: kPrimaryColor,
                  height: getProportionateScreenHeight(5),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setState(() {
                      if (text == 16) {
                      } else {
                        text = text - 1;
                        print(text);
                      }
                    });
                  },
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: getProportionateScreenWidth(70),
                  height: getProportionateScreenHeight(50),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kPrimaryColor)),
                  child: Column(
                    children: [
                      Text(
                        text.toString(),
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: getProportionateScreenHeight(22),
                        ),
                      ),
                      Text(
                        'ngày',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: getProportionateScreenHeight(12),
                        ),
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  shape: const CircleBorder(),
                  color: kPrimaryColor,
                  height: getProportionateScreenHeight(5),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setState(() {
                      if (text == 40) {
                      } else {
                        text = text + 1;
                        print(text);
                      }
                      print(text);
                    });
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Phụ Nữ Việt dùng	thông tin này để tính ngày đèn đỏ tới .'
             ,
          ),
        ],
      ),
    );
  }

  buildButton(context) {
    return Container(
      child: Column(
        children: [
          // Container(
          //   padding: EdgeInsets.symmetric(
          //     horizontal: getProportionateScreenWidth(20),
          //   ),
          //   width: SizeConfig.screenWidth,
          //   height: getProportionateScreenHeight(40),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         "Ding trung bình",
          //         style: TextStyle(color: kPrimaryColor),
          //       ),
          //       Center(
          //         child: Switch(
          //           value: average,
          //           inactiveThumbColor: kPrimaryLightColor,
          //           onChanged: (val) async {
          //             setState(() {
          //               average = val;
          //
          //               print(average);
          //               if (average == false) {
          //                 setState(() {
          //                   irregularcycle = false;
          //                 });
          //               }
          //             });
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Container(
          //   padding: EdgeInsets.symmetric(
          //     horizontal: getProportionateScreenWidth(20),
          //   ),
          //   width: SizeConfig.screenWidth,
          //   height: getProportionateScreenHeight(40),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         "Bo qua nhñ'ng gi batthuong",
          //         style: TextStyle(color: kPrimaryColor),
          //       ),
          //       Center(
          //         child: Switch(
          //           value: irregularcycle,
          //           inactiveThumbColor: kPrimaryLightColor,
          //           onChanged: (val) async {
          //             SharedPreferences prefs =
          //                 await SharedPreferences.getInstance();
          //             setState(() {
          //               if (average == true) {
          //                 irregularcycle = val;
          //
          //                 print(irregularcycle);
          //               } else if (average == false) {
          //                 setState(() {
          //                   irregularcycle = false;
          //                 });
          //               } else {}
          //             });
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // HeightBox(getProportionateScreenHeight(20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CommonButton(
                title: 'Bỏ',
                onTap: () => Navigator.of(context).pop(text.toString()),
              ),
              CommonButton(
                  title: 'Ok',
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    prefs.setBool("irregularcycle", irregularcycle);
                    prefs.setBool("average", average);
                    prefs.setString("cyclelength", text.toString());
                    Navigator.of(context).pop(text.toString());
                    updateSetting();
                  }),
            ],
          ),
          HeightBox(getProportionateScreenHeight(20))
        ],
      ),
    );
  }

  Future<void> getswitchvlue() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getBool("average") == null &&
        preferences.getBool("irregularcycle")) {
      average = false;
      print("dsklm");
    } else {
      print("dssaasklm");

      setState(() {
        average = preferences.getBool("average");
        irregularcycle = preferences.getBool("irregularcycle");
      });
    }
  }
  dynamic settingfromserver = new List();
  Future<void> updateSetting() async {
   // isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    print(token);
    try {
      final response = await post(updatesetings, headers: {
        'Authorization': 'Bearer $token',
      }, body: {
        "is_pregnency": "false",
        "period_length": text.toString(),
        "menstural_period": prefs.getString("periodlength")==null?"4":prefs.getString("periodlength")
      });
      print(response.statusCode.toString());
     // print(perioddate.toString());
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
}

class RowSwitch extends StatefulWidget {
  final String title;
  bool status;
  RowSwitch({@required this.title, @required this.status});

  @override
  _RowSwitchState createState() => _RowSwitchState();
}

class _RowSwitchState extends State<RowSwitch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
      ),
      width: SizeConfig.screenWidth,
      height: getProportionateScreenHeight(40),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: TextStyle(color: kPrimaryColor),
          ),
          Center(
            child: Switch(
              value: widget.status,
              inactiveThumbColor: kPrimaryLightColor,
              onChanged: (val) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                setState(() {
                  widget.status = val;
                  print(widget.status);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
