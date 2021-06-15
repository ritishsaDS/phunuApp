import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/Api.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/components/bottom.dart';
import 'package:vietnamese/components/common_navigation.dart';
import 'package:vietnamese/screens/Login/login.dart';
import 'package:vietnamese/screens/notes/alerts/period_started.dart';
import 'package:vietnamese/screens/notes/components/notes_text_field.dart';
import 'package:vietnamese/screens/notes/components/two_item_container.dart';
import 'package:vietnamese/screens/notes/components/two_textField.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/models/addnotes.dart';
import 'package:vietnamese/common/notesapirepo.dart';
import 'package:vietnamese/screens/signup/signUp.dart';
import 'alerts/mood.dart';
import 'alerts/period_ended.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/header.dart';
import 'moodcustomclass.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final addusernotesrepo = AddNotesRepo();
  TextEditingController textEditingControllerweight;
  bool isLoading = false;
  DateTime date;
  String note;
  final key = GlobalKey<FormState>();
  var user_type;
  var login_count;
  var deviceid;
  String notes;
  String tx_wieght;
  var moods;
  var u_flow = "";
  String tx_height;
  var star;
  DateTime periodStartedDate;
  DateTime periodenddate;
  TextEditingController notescontroller;
  DateTime periodEndedDate;
  String flow;
  String tookMedicine;
  String intercourse;
  String masturbated;
  String weight;
  DateTime selectedDate = DateTime.now();
  DateTime selectedDateforstart = DateTime.now();
  String height;
  List<Mood> mood;
  bool valuemedicine = false;
  bool valueinter = false;
  bool valuemasturbrated = false;
  final addUserNotes = AddUserNotes(
      date: DateTime.parse("2021-05-05"),
      note: "RItiijnasnjon",
      periodStartedDate: DateTime.parse("2021-05-05 16:58:27"),
      periodEndedDate: DateTime.parse("2021-05-05 18:58:27"),
      flow: "3",
      tookMedicine: "yes",
      intercourse: "no",
      masturbated: "no",
      weight: "65",
      height: "6",
      mood: [
        Mood(id: "1"),
        Mood(id: "2"),
        Mood(id: "3"),
      ]);
  final List<AddUserNotes> addnotesList = [];

  DateTime startPerioddate;
  dynamic today;
  @override
  void initState() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    today = formatter.format(now);
    getdetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              BottomTabs(2, true),
              HeightBox(20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    child: Container(
                      height: getProportionateScreenHeight(25),
                      width: getProportionateScreenHeight(25),
                      child: Image.asset(
                        'assets/icons/calender.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    onTap: () {
                      notesdate();
                    },
                  ),
                  WidthBox(getProportionateScreenWidth(40)),
                  Text(
                    "${today.toString().substring(0, 10)}",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  WidthBox(getProportionateScreenWidth(90))
                ],
              ),
              Divider(),
              GestureDetector(
                onTap: () {
                  showAlertDialog(context);
                },
                child: TwoItemContainer(
                  title: "Add Notes",
                  itemType: ItemType.icon,
                ),
              ),
              // NotesTextField(
              //   hintText: "Your note...",
              // ),
              GestureDetector(
                onTap: () {
                  showstartDialog(context);
                },
                child: TwoItemContainer(
                  title: "Period Started Today",
                  itemType: ItemType.icon,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showendDialog(context);
                },
                child: TwoItemContainer(
                  title: "Period Ended Today",
                  itemType: ItemType.icon,
                ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Flow",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "$u_flow",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        //height: getProportionateScreenHeight(40),
                        child: RatingBar.builder(
                          initialRating: 3,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemSize: getProportionateScreenHeight(22),
                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star_rounded,
                            color: kPrimaryColor,
                          ),
                          onRatingUpdate: (rating) {
                            star = rating;
                            setState(() {
                              if (star == 1) {
                                u_flow = "(Ra rất ít)";
                              } else if (star == 2) {
                                u_flow = "(Ra hơi ít)";
                              } else if (star == 3) {
                                u_flow = "(Ra bình thường)";
                              } else if (star == 4) {
                                u_flow = "(Ra hơi nhiều)";
                              } else {
                                u_flow = "(Ra rất nhiều)";
                              }
                            });
                            print(star);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Uống thuốc",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: getProportionateScreenHeight(23),
                        width: getProportionateScreenWidth(23),
                        //  decoration: BoxDecoration(
                        //     border: Border.all(color: kPrimaryColor),
                        //     borderRadius: BorderRadius.circular(4)),
                        child: Checkbox(
                          focusColor: (kPrimaryColor),
                          value: valuemedicine,
                          onChanged: (medicine) {
                            setState(
                              () {
                                valuemedicine = medicine;
                                print(valuemedicine);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Giao hợp",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: getProportionateScreenHeight(23),
                        width: getProportionateScreenWidth(23),
                        //  decoration: BoxDecoration(
                        //     border: Border.all(color: kPrimaryColor),
                        //     borderRadius: BorderRadius.circular(4)),
                        child: Checkbox(
                          focusColor: (kPrimaryColor),
                          value: valueinter,
                          onChanged: (currentValuei) {
                            setState(
                              () {
                                valueinter = currentValuei;
                                print(valueinter);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Tự sướng",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: getProportionateScreenHeight(23),
                        width: getProportionateScreenWidth(23),
                        //  decoration: BoxDecoration(
                        //     border: Border.all(color: kPrimaryColor),
                        //     borderRadius: BorderRadius.circular(4)),
                        child: Checkbox(
                          focusColor: (kPrimaryColor),
                          value: valuemasturbrated,
                          onChanged: (currentValuem) {
                            setState(
                              () {
                                valuemasturbrated = currentValuem;
                                print(valuemasturbrated);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // TwoItemContainer(
              //     title: "Took Medicine", itemType: ItemType.checkbox),
              // TwoItemContainer(
              //     title: "Intercourse", itemType: ItemType.checkbox),
              // TwoItemContainer(
              //     title: "Masturbated", itemType: ItemType.checkbox),
              GestureDetector(
                onTap: () async {
                  moods = await showDialog(
                      context: context,
                      builder: (BuildContext context) => MyDialogContent());
                 // print(moods[1]);
                },
                child: TwoItemContainer(
                  title: "Mình cảm thấy",
                  itemType: ItemType.icon,
                ),
              ),

              Form(
                key: key,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(10)),
                  width: SizeConfig.screenWidth,
                  height: getProportionateScreenHeight(60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: getProportionateScreenHeight(50),
                        width: SizeConfig.screenWidth * 0.45,
                        child: TextFormField(
                          controller: textEditingControllerweight,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          buildCounter: (BuildContext context,
                                  {int currentLength,
                                  int maxLength,
                                  bool isFocused}) =>
                              null,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            isDense: true,
                            focusColor: kPrimaryLightColor,
                            hoverColor: kPrimaryLightColor,
                            hintStyle: TextStyle(color: kTextColor),
                            hintText: "Weight",

                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 42, vertical: 5),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: kPrimaryColor),
                              gapPadding: 10,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: kPrimaryColor),
                              gapPadding: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: kPrimaryColor),
                              gapPadding: 10,
                            ),
                            // errorText: validatePassword(double.parse(tx_wieght)),
                          ),
                          onChanged: (value) {
                            setState(() {
                              tx_wieght = value;
                            });
                          },
                          validator: (val) {
                            if (double.parse(val) < 30 ||
                                double.parse(val) > 100) {
                              return "Enter Range 30-100";
                            } else {
                              return null;
                            }
                          },
                          // onChangedValue: widget.height,
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(50),
                        width: SizeConfig.screenWidth * 0.45,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          buildCounter: (BuildContext context,
                                  {int currentLength,
                                  int maxLength,
                                  bool isFocused}) =>
                              null,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            isDense: true,
                            focusColor: kPrimaryLightColor,
                            hoverColor: kPrimaryLightColor,
                            hintStyle: TextStyle(color: kTextColor),
                            hintText: "Height",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 42, vertical: 5),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: kPrimaryColor),
                              gapPadding: 0,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: kPrimaryColor),
                              gapPadding: 0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: kPrimaryColor),
                              gapPadding: 0,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              tx_height = value;
                              print(tx_height);
                            });
                          },

                          // onChangedValue: widget.height,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),

              RaisedButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: kPrimaryColor, width: 0.5),
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () async {
                  if (key.currentState.validate() && moods.length != null) {
                    print(moods);
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString("weight", tx_wieght);

                    var data = AddUserNotes(
                        date: DateTime.parse(today.toString().substring(0, 10)),
                        note: notes,
                        periodStartedDate: startPerioddate,
                        periodEndedDate: periodenddate,
                        flow: star.toString(),
                        tookMedicine: valuemedicine.toString(),
                        intercourse: valueinter.toString(),
                        masturbated: valuemasturbrated.toString(),
                        weight: tx_wieght,
                        height: tx_height,
                        mood: moods);

                    setState(() {
                      isLoading = true;
                    });
                    addnotesList.add(data);
                    if (user_type == "guest") {
                      if (login_count <= 3) {
                        showregisterdialog(context);
                      } else {
                        postnotes(addnotesList);
                      }
                    } else {
                      postnotes(addnotesList);
                    }
                  } else {
                    showToast("message");
                  }
                },
                child: isLoading
                    ? CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.pink),
                      )
                    : Text(
                        "Save Notes",
                        style: TextStyle(color: Colors.pink),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String validatePassword(double value) {
    if (!(value > 30.0) && value < 100.0) {
      return "Password should contain more than 5 characters";
    }
    return null;
  }

  postnotes(List<AddUserNotes> addnotes) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    dynamic token = preferences.getString("token");
    setState(() {
      isLoading = true;
    });
    print(token);
    print(addnotes.length);

    addusernotesrepo.addusernotes(token, addnotes).then((value) => {
          if (value)
            {showToast("Notes Added Successfully!"), Navigator.pop(context)}
        });
    setState(() {
      isLoading = false;
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Add"),
      onPressed: () {
        print(notes);

        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Add Notes"),
      content: Container(
        child: TextFormField(
          maxLines: 5,
          controller: notescontroller,
          onChanged: (value) {
            setState(() {
              notes = value;
            });
          },
          decoration: inputDecoration(),
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

  showregisterdialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Register"),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpScreen()));
      },
    );
    Widget deny = FlatButton(
      child: Text("Continue,without Login"),
      onPressed: () {
        print(notes);
        getlogindemo();
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Container(
          height: SizeConfig.screenHeight / 10,
          child: Column(
            children: [
              Text("For Add Notes You have to login "),
            ],
          )),
      actions: [
        okButton,
        deny,
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

  InputDecoration inputDecoration() {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: kPrimaryColor),
      gapPadding: 10,
    );
    return InputDecoration(
      fillColor: Colors.white,
      filled: true,
      isDense: true,
      focusColor: kPrimaryLightColor,
      hoverColor: kPrimaryLightColor,
      hintStyle: TextStyle(color: kTextColor),
      hintText: "Add Notes",
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      border: outlineInputBorder,
    );
  }

  getdate() async {
    startPerioddate = await showDatePicker(
      context: context,
      initialDate: selectedDateforstart,
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
    if (startPerioddate != null && startPerioddate != selectedDateforstart)
      setState(() {
        selectedDateforstart = startPerioddate;
        print(selectedDateforstart);
      });
  }

  enddate() async {
    periodenddate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021, 4),
      lastDate: selectedDate,
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
    if (periodenddate != null && periodenddate != selectedDate)
      setState(() {
        selectedDate = periodenddate;
        print(selectedDate);
      });
  }

  showendDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        print(notes);

        Navigator.pop(context);
      },
    );
    Widget close = FlatButton(
      child: Text("No"),
      onPressed: () {
        print(notes);

        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Your Periods Ended Today?"),
      actions: [okButton, close],
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
    Widget okButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        print(notes);

        Navigator.pop(context);
      },
    );

    Widget closeButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        print(notes);

        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Your Periods Started Today"),
      actions: [
        okButton,
        closeButton,
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

  notesdate() async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021, 4),
      lastDate: DateTime(2022, 4),
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
      setState(() {
        today = pickedDate;
        //  selectedDate = DateTime.parse(today);
        print(today.toString());
      });
  }

  Future<void> getdetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_type = prefs.getString("user_type");
      login_count = prefs.getInt("login_count");
      print(login_count);
      deviceid = prefs.getString("deviceid");
      if (prefs.getString("weight") == null) {
      } else {
        textEditingControllerweight =
            TextEditingController(text: prefs.getString("weight"));
        tx_wieght = prefs.getString("weight");
      }
    });
  }

  dynamic login = new List();
  Future<void> getlogindemo() async {
    print(deviceid);
    try {
      final response = await http.post(logindemo, body: {
        "device_id": deviceid,
        // "password": passwordString,
      });
      print("bjkb" + response.statusCode.toString());
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        print(responseJson);
        login = responseJson;
        print(login['data']['login_count']);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setInt("login_count", login['data']['login_count']);
        login_count = preferences.getInt("login_count");
        print(login_count);
        //print(loginwithserver);

        Navigator.pop(context);
        postnotes(addnotesList);

        // showToast("");
        // savedata();
        setState(() {
          //  isError = false;
          isLoading = false;
          print('setstate');
        });
      } else {
        print("bjkb" + response.statusCode.toString());
        showToast("Mismatch Credentials");
        setState(() {
          // isError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        // isError = true;
        isLoading = false;
      });
    }
  }
}
