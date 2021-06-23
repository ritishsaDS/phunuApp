import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vietnamese/common/Api.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/screens/Dashboard/dashboard.dart';

class DashboardTitle extends StatefulWidget {
  DashboardTitle({this.day});
  dynamic day;
  @override
  _DashboardTitleState createState() => _DashboardTitleState();
}

class _DashboardTitleState extends State<DashboardTitle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(15),
        vertical: getProportionateScreenHeight(20),
      ),
      child: Stack(
        children: [
          Container(
            height: getProportionateScreenHeight(140),
            width: SizeConfig.screenWidth,
            child: Image.asset(
              'assets/images/dashboard/header_big.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            height: getProportionateScreenHeight(140),
            width: SizeConfig.screenWidth,
            child: Column(
              children: [
                Header(day: widget.day),
                //  Footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
        vertical: getProportionateScreenHeight(0),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Has your period ended yet?',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class Header extends StatefulWidget {
  Header({
    this.day,
    Key key,
  }) : super(key: key);
  dynamic day;
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  String Title;
  String buttontext;
  var formatter;
  String formattedDate;
  bool isLoading = false;
  String token;
  bool isError;
  var getnext = "       ";
  var periodno = "3";
  DateTime selectedDate = DateTime.now();

  DateTime end;
  bool visible = true;
  @override
  void initState() {
    gettoken();
    var now = new DateTime.now();
    formatter = new DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
    print(formattedDate);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(10),
              vertical: getProportionateScreenHeight(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$Title',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: getProportionateScreenHeight(24),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  height: getProportionateScreenHeight(40),
                  width: getProportionateScreenWidth(40),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/dashboard/number_count.png',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.day.toString() != null
                          ? widget.day.toString().replaceAll("-", "")
                          : "",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: getProportionateScreenHeight(24),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (buttontext == "Is Your Period Ended Yet?") {
                showAlertDialog(context);
              } else {
                //showAlertDialog(context);
              }
            },
            child: Visibility(
              visible: visible,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                  vertical: getProportionateScreenHeight(0),
                ),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$buttontext',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
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
          getendperiod();

          // Navigator.pop(context);
        },
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.all(0),
      //  backgroundColor: kPrimaryColor,

      title: Text("Your Period ended"),
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
showstartDialog(BuildContext context) {
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
          sendperioddate();

          // Navigator.pop(context);
        },
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.all(0),
      //  backgroundColor: kPrimaryColor,

      title: Text("Your Period ended"),
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

  dynamic settingfromserver = new List();
  dynamic endperiodfromserver = new List();
  Future<void> sendperioddate() async {
    // isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    print("ddffd" + token);
    try {
      final response = await http.post(getperiodsdate, headers: {
        'Authorization': 'Bearer $token',
      }, body: {
        "start_date": DateTime.now(),
       
      });
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        settingfromserver = responseJson;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("alert", "true");
        prefs.setString("startdate", DateTime.now().toString());
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
Future<void> getendperiod() async {
    Navigator.pop(context);
    // isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    print("ddffd" + token);
    try {
      final response = await http.post(getendperioddate, headers: {
        'Authorization': 'Bearer $token',
      }, body: {
        "period-ended-yet": DateTime.now().toString(),
      });
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        endperiodfromserver = responseJson['data'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("alert", "true");
        prefs.setString(
            "startdate", endperiodfromserver['start_period_date'].toString());
        prefs.setString("fertilewindow",
            endperiodfromserver['fertile_window_starts'].toString());
        prefs.setString(
            "nextdate", endperiodfromserver['next_period_date'].toString());
        prefs.setBool("button", false);
        getDay();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => DashboardScreen()));
        // print("lvnsdlm l" + settingfromserver);
        // getNextperiod();
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
          getnext = prefs.getString("nextdate");
          print(getnext);
          getDay();
        } else {
          getnext = prefs.getString("nextdate");

          getDay();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DashboardScreen()));
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
    setState(() {
      if (int.parse(widget.day) <= 3) {
        Title = "Period Day";
        buttontext = "Is Your Period Ended Yet?";
        setState(() {
          visible = true;
        });
      } else if (int.parse(widget.day) > 3 && int.parse(widget.day) <= 7) {
        Title = "Period Day";
        setState(() {
          visible = false;
        });
      } else if (int.parse(widget.day) > 7 && int.parse(widget.day) < 20) {
        Title = "Days Until Next Period";
        setState(() {
          visible = false;
        });
      } else if (int.parse(widget.day) > 20) {
        Title = "Days Until Next Period";
        buttontext = "Is Your Period Started?";
        setState(() {
          visible = true;
        });
      }
    });
  }
}
