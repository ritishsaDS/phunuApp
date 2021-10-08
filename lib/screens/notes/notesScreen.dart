import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/Api.dart';
import 'package:vietnamese/common/blocvalidate.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/notesapirepo.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/components/bottom.dart';
import 'package:vietnamese/models/addnotes.dart';
import 'package:vietnamese/screens/Dashboard/dashboard.dart';
import 'package:vietnamese/screens/lunar.dart';
import 'package:vietnamese/screens/notes/alerts/period_ended.dart';
import 'package:vietnamese/screens/notes/alerts/period_started.dart';
import 'package:vietnamese/screens/notes/components/two_item_container.dart';
import 'package:vietnamese/screens/signup/signUp.dart';

import 'components/notes_text_field.dart';
import 'moodcustomclass.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final addusernotesrepo = AddNotesRepo();
  TextEditingController textEditingControllerweight = new TextEditingController();
  TextEditingController textEditingControllerheight = new TextEditingController();
  bool isLoading = false;
  DateTime date;
  String note;
  var addcount = 0;
  final key = GlobalKey<FormState>();
  var user_type;
  var data;
  var login_count=0;
  var deviceid;
  String notes = "";
  String tx_wieght='';
  var moods;
  var u_flow = "";
  String tx_height='';
  var star = 3.0;
  DateTime periodStartedDate;
  DateTime periodenddate;
  TextEditingController notescontroller;
  DateTime periodEndedDate;
  String flow;
  String tookMedicine;
  String intercourse;
  String startperioddate;
  String masturbated;
  String weight;
  int filed_count;
  List<int> arr = [];
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
      filed_count: 2,
      mood: [
        Mood(id: "1"),
        Mood(id: "2"),
        Mood(id: "3"),
      ]);
  final List<AddUserNotes> addnotesList = [];
  var notesid = 0;
  DateTime startPerioddate;
  dynamic today;
  @override
  void initState() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    today = formatter.format(now);
    getdetail();
    // getnotesfromsevr();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:  Builder(
        builder: (context) => SingleChildScrollView(
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
                     // notesdate();
                    },
                  ),
                  WidthBox(getProportionateScreenWidth(40)),
                  Text(
                    "${DateTime.parse(today).day.toString()}" +
                        "/" "${DateTime.parse(today).month.toString()}" +
                        "/" "${DateTime.parse(today).year.toString()}",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  WidthBox(getProportionateScreenWidth(90))
                ],
              ),
              Divider(),
              // GestureDetector(
              //   onTap: () {
              //     showAlertDialog(context);
              //   },
              //   child: TwoItemContainer(
              //     title: "Add Notes",
              //     itemType: ItemType.icon,
              //   ),
              // ),

              Container(
                padding: EdgeInsets.only(
                  left: getProportionateScreenWidth(10),
                  right: getProportionateScreenWidth(10),
                  bottom: getProportionateScreenHeight(10),
                ),
                child: TextField(
                  controller: notescontroller,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    isDense: true,
                    focusColor: kPrimaryLightColor,
                    hoverColor: kPrimaryLightColor,
                    hintStyle: TextStyle(
                      color: kTextColor,
                    ),
                    hintText: "Viết những gì đáng nhớ",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 42, vertical: 10),
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
                  ),
                  onChanged: (value) {
                    setState(() {
                      notes = value;
                    });
                    if (notes != "") {}
                  },
                ),
              ),
              GestureDetector(
                onTap: () async {
                  addcount = addcount + 1;
                  startperioddate = await showDialog(
                      context: context,
                      builder: (BuildContext context) => PeriodStartedAlert());
                  SharedPreferences prfs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    print(startPerioddate);

                    print(prfs.getString("selecteddate"));
                  });
                  //showstartDialog(context);
                },
                child: TwoItemContainer(
                  title: "Kinh bắt đầu hôm nay",
                  itemType: ItemType.icon,
                ),
              ),
              GestureDetector(
                onTap: () {
                  addcount = addcount + 1;
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => PeriodEndedAlert());
                  //showstartDialog(context);
                },
                child: TwoItemContainer(
                  title: "Hết kinh hôm nay",
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
                        "Ra nhiều ít",
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
                          initialRating: star,
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
                            addcount = addcount + 1;

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
                                if (valuemedicine == true) {
                                  addcount = addcount + 1;
                                }
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
                                if (valueinter == true) {
                                  addcount = addcount + 1;
                                }
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
                                if (valuemasturbrated == true) {
                                  addcount = addcount + 1;
                                }
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
                      builder: (BuildContext context) =>
                          MyDialogContent(id: arr));
                  // print(moods[1]);
                  if (moods != null) {
                    addcount = addcount + 1;
                  }
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
                          // inputFormatters: [
                          //   WhitelistingTextInputFormatter(RegExp("[30-100]")),
                          //   LengthLimitingTextInputFormatter(3),
                          //  // _DateFormatter(),
                          // ],
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
                            hintStyle:
                                TextStyle(color: kTextColor, fontSize: 10),
                            hintText: "Cân (Kg) ",

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
                            addcount = addcount + 1;
                          },
                          validator: (val) {
                            if (double.parse(val) > 30 ||
                                double.parse(val) <100) {
                              return "Range 30-100";
                            } else {
                              return null;
                            }
                          },

                          // onChangedValue: widget.height,
                        ),
                      ),
                      // Container(
                      //
                      //   child: StreamBuilder(
                      //     stream: validation.weight,
                      //     builder: (_, snapShot) => TextField(
                      //       onChanged: (val) => validation.sinkEmail.add(val),
                      //       decoration: InputDecoration(
                      //           hintText: 'Email',
                      //           errorText: snapShot.hasError?snapShot.error.toString():null
                      //       ),
                      //       keyboardType: TextInputType.emailAddress,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: getProportionateScreenHeight(50),
                        width: SizeConfig.screenWidth * 0.45,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: textEditingControllerheight,
                          maxLength: 4,
                          buildCounter: (BuildContext context,
                                  {int currentLength,
                                  int maxLength,
                                  bool isFocused}) =>
                              null,
                          // validator: (value) {
                          //   if (value == null) {
                          //     tx_height = "0.00";
                          //   }
                          //   var converted = double.parse(value);
                          //   if (converted < 35) {
                          //     return 'Range 35c to 45c';
                          //   } else if (converted > 45) {
                          //     return 'Range 35c to 45c';
                          //   }
                          // },
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            isDense: true,
                            focusColor: kPrimaryLightColor,
                            hoverColor: kPrimaryLightColor,
                            hintStyle:
                                TextStyle(color: kTextColor, fontSize: 8),
                            hintText: "Thân nhiệt (C)",
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
                          // validator: (value) {
                          //   if (double.parse(value) > 35.0 ||
                          //       double.parse(value) <45.0) {
                          //     return "Range 30-100";
                          //   } else {
                          //     return null;
                          //   }
                          // },

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

              // ignore: deprecated_member_use
              RaisedButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: kPrimaryColor, width: 0.5),
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  if (tx_wieght != "" ) {

                    if(double.parse(textEditingControllerweight.text)<30.0||double.parse(textEditingControllerweight.text)>100.0){
                      print("ijnpwsdsdsdsd");
                      setState(() {
                        isLoading=false;
                      });
                      return Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Nhập Cân 30kg - 100kg"),
                      ));
                      return  Fluttertoast.showToast(
                          msg: "Please ENter value in range",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0);


                    }
                    else{
                      addcount = addcount + 1;
                    }

                  }  if (tx_height != "" ) {
                  //  print("ijnpw"+textEditingControllerheight.text);

                    if(double.parse(tx_height)<35.0||double.parse(tx_height)>45.0){
                      print("ijnpwsdsdsdsd");
                      setState(() {
                        isLoading=false;
                      });
                      return Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Nhập Thân nhiệt 35c - 45c"),
                      ));
                      return  Fluttertoast.showToast(
                          msg: "Please ENter value in range",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0);


                    }
                    else{
                      print('iwejoerv');
                      addcount = addcount + 1;
                    }
                  } else if (notes != "" ) {
                    addcount = addcount + 1;
                  }
                  print(addcount.toString() + "addcount");
                  if (moods == null) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString("weight", tx_wieght);
                   // print("weightweightweight"+prefs.getString("weight"));
                    data = AddUserNotes(
                        date: DateTime.parse(today.toString().substring(0, 10)),
                        note: notes == null ? "" : notes,
                        periodStartedDate:
                            DateTime.parse(prefs.getString("startdate")),
                        periodEndedDate: periodenddate == null
                            ? DateTime.parse("1970-01-25")
                            : periodEndedDate,
                        flow: star.toString(),
                        tookMedicine: valuemedicine.toString(),
                        intercourse: valueinter.toString(),
                        masturbated: valuemasturbrated.toString(),
                        weight: tx_wieght == '' ? "" : tx_wieght,
                        height: tx_height == '' ? "" : tx_height,
                        mood: [],
                        filed_count: addcount,
                        user_notes_id: notesid);
                    print("addcouht" + addcount.toString());
                    setState(() {
                      isLoading = true;
                    });
                    addnotesList.add(data);
                    if (user_type == "guest") {
if(login_count==null){
  login_count=1;
}
                      if (login_count <= 3) {
                        showregisterdialog(context);
                      } else {
                        postnotes(addnotesList);
                      }
                    } else {
                      postnotes(addnotesList);
                    }
                  }
                  else {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    // prefs.setString("weight", tx_wieght);

                    data = AddUserNotes(
                        date: DateTime.parse(today.toString().substring(0, 10)),
                        note: notes == null ? "" : notes,
                        periodStartedDate:
                            DateTime.parse(prefs.getString("startdate")),
                        periodEndedDate: periodenddate == null
                            ? DateTime.parse("1970-01-25")
                            : periodEndedDate,
                        flow: star.toString(),
                        tookMedicine: valuemedicine.toString(),
                        intercourse: valueinter.toString(),
                        masturbated: valuemasturbrated.toString(),
                        weight: tx_wieght == '' ? "" : tx_wieght,
                        height: tx_height == '' ? "" : tx_height,
                        filed_count: addcount,
                        mood: moods,
                        user_notes_id: notesid);
                    print("add" + notesid.toString());
                    setState(() {
                      isLoading = true;
                    });
                    addnotesList.add(data);
                    if (user_type == "guest") {
                      if(login_count==null){
                        login_count=0;
                      }
                      if (login_count <= 3) {
                        showregisterdialog(context);
                      } else {
                        postnotes(addnotesList);
                      }
                    } else {
                      postnotes(addnotesList);
                    }
                  }
                },
                child: isLoading
                    ? CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.pink),
                      )
                    : Text(
                        " Lưu",
                        style: TextStyle(color: Colors.pink),
                      ),
              )
            ],
          ),
        ),
      ),
    ));
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

    print(token);
    print(addnotes.length);

    addusernotesrepo.addusernotes(token, addnotes).then((value) => {
          print(value),
          if (value)
            {
              showToast("Đã thêm ghi chú thành công"),
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()))
            }
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
      child: Text("Đăng ký"),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpScreen()));
      },
    );
    Widget deny = FlatButton(
      child: Text("Tiếp tục mà không cần Đăng nhập"),
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
              Text("Để thêm ghi chú, bạn phải đăng nhập"),
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
      title: Text(" Periods Ended "),
      content: Container(
        height: getProportionateScreenHeight(40),
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(10),
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${today.toString().replaceAll("-", "/").substring(0, 10)}",

              /// style: date,
            ),
            GestureDetector(
                child: Image.asset(
                  "assets/icons/calender.png",
                  height: 15,
                  width: 20,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PeriodStartedAlert()));
                  // getendperioddate();
                })
          ],
        ),
      ),
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
      title: Text(" Periods Started "),
      content: Container(
        height: getProportionateScreenHeight(40),
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(10),
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${today.toString().replaceAll("-", "/").substring(0, 10)}",

              /// style: date,
            ),
            GestureDetector(
                child: Image.asset(
                  "assets/icons/calender.png",
                  height: 15,
                  width: 20,
                ),
                onTap: () {
                  // getendperioddate();
                })
          ],
        ),
      ),
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
      print("lohin"+login_count.toString());
      deviceid = prefs.getString("deviceid");

      if (prefs.getString("weight") == null) {
      } else {
        // textEditingControllerweight =
        //     TextEditingController(text: prefs.getString("weight"));
        // tx_wieght = prefs.getString("weight");
      }
      if (prefs.getString("selecteddate") == null) {
      } else {
        setState(() {
          today = prefs.getString("selecteddate");
          getnotescount(today);
        });
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
        login_count=login_count+1;
        // print("lmn lnvlfl"+login['data']['login_count'].toString());
         SharedPreferences preferences = await SharedPreferences.getInstance();
         preferences.setInt("login_count",login_count);
       // login_count = preferences.getInt("login_count");
        print("login_count"+login_count.toString());
        //print(loginwithserver);

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

  dynamic countfromserver = new List();
  getnotescount(date) async {
    // count++;
    // isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    try {
      final response = await http.post(
        getnotescountapi,
        body: {"date": date.toString().substring(0, 10)},
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        setState(() {
          countfromserver = responseJson['data'];
          //  print(listdata['mood'])
          //  moodserver = mooddata;
        });
        print(responseJson);
        notescontroller =
            TextEditingController(text: countfromserver[0]['note']);
        textEditingControllerweight =
            TextEditingController(text: countfromserver[0]['weight']);
        textEditingControllerheight =
            TextEditingController(text: countfromserver[0]['height']);
        notesid = countfromserver[0]['id'];
        print(countfromserver[0]['mood']);

        // print(double.parse(countfromserver[0]['flow']));

        //  List<Map<String, dynamic>> varr = countfromserver[0]['mood'];
        for (int i = 0; i < countfromserver[0]['mood'].length; i++) {
          print(countfromserver[0]['mood'][i]['id']);
          arr.add(int.parse(countfromserver[0]['mood'][i]['id']));
          print(arr);
        }
        setState(() {
          if (countfromserver[0]["masturbated"] == "true") {
            valuemasturbrated = true;
          } else {
            valuemasturbrated = false;
          }
          if (countfromserver[0]["intercourse"] == "true") {
            valueinter = true;
          } else {
            valueinter = false;
          }
          if (countfromserver[0]['took_medicine'] == "true") {
            valuemedicine = true;
          } else {
            valuemedicine = false;
          }
        });

        if (countfromserver[0]["flow"] == 5) {
          star = 5.0;
        } else if (countfromserver[0]["flow"] == 3) {
          star = 3.0;
        } else if (countfromserver[0]["flow"] == 4) {
          star = 4.0;
        } else if (countfromserver[0]["flow"] == 1) {
          star = 1.0;
        } else if (countfromserver[0]['flow'] == 2) {
          star = 2.0;
        }

        /// notesdate = nextfromserver['date'];
        // usernotes = nextfromserver["note"];
        // print(nextfromserver[0]["note"]);

      } else {
        print("bjkb" + response.statusCode.toString());
      }
    } catch (e) {
      print(e);
    }
  }
}
