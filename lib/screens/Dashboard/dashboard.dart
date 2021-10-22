import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/Api.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/main.dart';
import 'package:vietnamese/screens/Articles/articles.dart';
import 'package:vietnamese/screens/Articles/components/article_detail.dart';
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
  var getnext = " ??-??-   ?   ";
  var getfertile = " ??-??- ?     ";
  var getdays = " ??     ";
  var periodno = "  ? ";
  var fcmtoken;
  FirebaseMessaging messaging;
  DateTime selectedDate = DateTime.now();
bool pressAttention = false;
  DateTime end;

  bool pregnancy=false;
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  @override
  void initState() {
    super.initState();
    gettoken();
    _getId();
   // // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
   //    // notifpermission();
   //    print("message recieved");
   //    //  print(event.notification.body);
   //  });
   //
    registerNotification();
    checkForInitialMessage();
   // fcmtoken = "lkenwlkklfwlewfnelfk";

    // Firebase.initializeApp().whenComplete(() {
    //   print("completed");
    //   setState(() {});
    //   messaging = FirebaseMessaging.instance;
    //   messaging.getToken().then((value) {
    //     print("fcm" + value);
    //     fcmtoken = value;
    //     _getId();
    //   });
    // });
    // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    //   print("message recieved");
    //   //  print(event.notification.body);
    // });

    var now = new DateTime.now();
    formatter = new DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
    print(formattedDate);
    // getDay();
  }
  var i=0;
  var alert;
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
                   
                    CardSection(),
                  ])
                : Column(
                    children: [
                      CommonAppBar(),
                      DashboardTitle(day: periodno),

                      BodyContent(
                        title: "Ngày dự đoán sẽ có kinh",
                        date: "${getnext
        .split("-")[2]
        .toString()+"/"+ getnext .split("-")[1]
        .toString()}"
                      ),
                      HeightBox(getProportionateScreenHeight(10)),
                      BodyContent(
                        title: 'Ngày bắt đầu màu mỡ',
                        date: "${getdays.toString()+"/"+ getfertile .split("-")[1]
        .toString(
    )
  }"
                           // .replaceAll("-", "/")

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
    prefs.getString("lnslnlnl"+"alert");

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
          if (selectedDate == null || selectedDate == "") {
            return Text(
                "Để dùng app Phụ Nữ Việt, xin cho biết lần trước có kinh là khoảng ngày nào");
          } else {
            sendperioddate(selectedDate);
          }
          // Navigator.pop(context);
        },
      ),
    );
    Widget cancel = Container(
      decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(
            15.0,
          ),
          color: kPrimaryColor),
      child: FlatButton(
        child: Text(
          "bo",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
setState(() {
  isLoading=false;
});
          Navigator.pop(context);
        },
      ),
    );
    var date;
    // set up the AlertDialog

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            //  backgroundColor: kPrimaryColor,

            content: Container(
              height: SizeConfig.screenHeight*0.2,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Center(
                      child: Text(
                        "Để dùng app Phụ Nữ Việt, xin cho biết lần trước có kinh là khoảng ngày nào",
                        style: TextStyle(
                            color: kPrimaryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                        margin: EdgeInsets.all(10),
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
                          date != null && date != ""
                              ? DateFormat("dd/MM/yyyy").format(date)
                              : "Ngày đèn đỏ lần gần\n đây nhất",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: kPrimaryColor),
                        ))),
                    onTap: () async {
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
                              colorScheme:
                                  ColorScheme.light(primary: Color(0xFFDE439A)),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary),
                            ),
                            child: child,
                          );
                        },
                      );
                      if (pickedDate != null && pickedDate != selectedDate)
                        selectedDate = pickedDate;
                      date = selectedDate;
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.setString(
                          "selected", selectedDate.toString());
                      print(selectedDate);
                      // getenddate();
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            actions: [
              cancel,
              okButton,

            ],
          );
        });
      },
    );
  }

  Future<void> savedata(deviceid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pregnancy = prefs.getBool("pregnancy");
    print(pregnancy);
    if (pregnancy == null) {
      pregnancy = false;
    }
    else{
      pregnancy=true;
     getnext = " ??-??-   ?   ";
       getfertile = " ??-??- ?     ";
    }
    if (loginwithserver['data']['login_count'] == null) {
      prefs.setString("user_type", loginwithserver['data']['user_type']);

      //  prefs.setInt("login_count", loginwithserver['data']['login_count']);
      prefs.setString("deviceid", deviceid);
      // prefs.setInt("password", loginwithserver['data']['password']);
      prefs.setString("token", loginwithserver['access_token']);
      gettoken();
      // logintimebackup(prefs.getString("token"));
    } else if (loginwithserver['data']['email'] == null) {
      prefs.setString("user_type", loginwithserver['data']['user_type']);

   //   prefs.setInt("login_count", loginwithserver['data']['login_count']);
      prefs.setString("deviceid", deviceid);
      // prefs.setInt("password", loginwithserver['data']['password']);
      prefs.setString("token", loginwithserver['access_token']);
      gettoken();
    } else {
      prefs.setString("email", loginwithserver['data']['email']);
      prefs.setString("user_type", loginwithserver['data']['user_type']);

    //  prefs.setInt("login_count", loginwithserver['data']['login_count']);
      prefs.setString("deviceid", deviceid);
      // prefs.setInt("password", loginwithserver['data']['password']);
      prefs.setString("token", loginwithserver['access_token']);
      //  logintimebackup(prefs.getString("token"));
      //prefs.setString('email', emailController.text);
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>DashboardScreen()));
      gettoken();
    }
  }

  _getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   // prefs.getString("nextdate");
  //  SharedPreferences prefs = await SharedPreferences.getInstance();
   fcmtoken = prefs.getString("fcmtoken");
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
    //print(fcmtoken + "deviceid");
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
          isLoading = true;
          print('setstsasadate');
        });
      } else {
        print("bjkb" + response.statusCode.toString());
        showToast("Mismatch Credentials");
        setState(() {
          isError = true;
          isLoading = true;
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
        "Fcmtoken": fcmtoken
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
          isLoading = true;
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

  getdate() async {}

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
        getdaytext();
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
          isLoading = true;
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
  PushNotification _notificationInfo;
  void registerNotification() async {
    await Firebase.initializeApp();
    messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],

      );

      // setState(() {
      //   _notificationInfo = notification;
      //   //_totalNotifications++;
      // });
      if(message.data['click_action']=="FLUTTER_NOTIFICATION_CLICK"){
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ArticleDetailScreen(id:message.data['article_id'])));
      }

    });
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(
            'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => ArticleScreen()));
        // Parse the message received
        PushNotification notification = PushNotification(
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );

        setState(() {
          _notificationInfo = notification;
          //  _totalNotifications++;
        });

        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
          showSimpleNotification(
            Text(notification.dataTitle),
            //  leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text(notification.dataTitle),
            background: Colors.cyan.shade700,
            duration: Duration(seconds: 10),
          );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }
  Future<void> notifpermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,

      );
      setState(() {
        _notificationInfo = notification;
        // _totalNotifications++;
      });
    }
  }
  // _getId() async {
  //   var deviceInfo = DeviceInfoPlugin();
  //   if (Platform.isIOS) {
  //     // import 'dart:io'
  //     var iosDeviceInfo = await deviceInfo.iosInfo;
  //     print(iosDeviceInfo.identifierForVendor);
  //     await signin(iosDeviceInfo.identifierForVendor);
  //     return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  //   } else {
  //     var androidDeviceInfo = await deviceInfo.androidInfo;
  //     print(androidDeviceInfo.androidId);
  //     await signin(androidDeviceInfo.androidId);
  //     return androidDeviceInfo.androidId; // unique ID on Android
  //   }
  // }

  // signin(deviceid) async {
  //   print(deviceid);
  //   try {
  //     final response = await http.post(firstlogin, body: {
  //       "device_id": deviceid,
  //       "pin": "1234",
  //     });
  //     //print("bjkb" + response.statusCode.toString());
  //     if (response.statusCode == 200) {
  //       final responseJson = json.decode(response.body);

  //       firstloginlist = responseJson;
  //       // print(loginwithserver['data']['email']);
  //       print(firstloginlist);
  //       loginasguest(deviceid);
  //       // showToast("");
  //       // savedata();
  //       setState(() {
  //         isError = false;
  //         isLoading = false;
  //         print('setstate');
  //       });
  //     } else {
  //       print("bjkb" + response.statusCode.toString());
  //       showToast("Mismatch Credentials");
  //       setState(() {
  //         isError = true;
  //         isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     print(e);
  //     setState(() {
  //       isError = true;
  //       isLoading = false;
  //     });
  //   }
  // }

  // Future<void> loginasguest(deviceid) async {
  //   try {
  //     final response = await http.post(login, body: {
  //       "device_id": deviceid,
  //       "password": "1234",
  //     });
  //     //print("bjkb" + response.statusCode.toString());
  //     if (response.statusCode == 200) {
  //       final responseJson = json.decode(response.body);

  //       loginwithserver = responseJson;
  //       // print(loginwithserver['data']['email']);
  //       print(loginwithserver);
  //       // loginasguest(deviceid);
  //       // showToast("");
  //       savedata(deviceid);
  //       gettoken();
  //       getalert();
  //       setState(() {
  //         isError = false;
  //         isLoading = false;
  //         print('setstate');
  //       });
  //     } else {
  //       print("bjkb" + response.statusCode.toString());
  //       showToast("Mismatch Credentials");
  //       setState(() {
  //         isError = true;
  //         isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     print(e);
  //     setState(() {
  //       isError = true;
  //       isLoading = false;
  //     });
  //   }
  // }

  // Future<void> savedata(deviceid) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (loginwithserver['data']['login_count'] == null) {
  //     prefs.setString("user_type", loginwithserver['data']['user_type']);

  //     //  prefs.setInt("login_count", loginwithserver['data']['login_count']);
  //     prefs.setString("deviceid", deviceid);
  //     // prefs.setInt("password", loginwithserver['data']['password']);
  //     prefs.setString("token", loginwithserver['access_token']);
  //   } else if (loginwithserver['data']['email'] == null) {
  //     prefs.setString("user_type", loginwithserver['data']['user_type']);

  //     prefs.setInt("login_count", loginwithserver['data']['login_count']);
  //     prefs.setString("deviceid", deviceid);
  //     // prefs.setInt("password", loginwithserver['data']['password']);
  //     prefs.setString("token", loginwithserver['access_token']);
  //   } else {
  //     prefs.setString("email", loginwithserver['data']['email']);
  //     prefs.setString("user_type", loginwithserver['data']['user_type']);

  //     prefs.setInt("login_count", loginwithserver['data']['login_count']);
  //     prefs.setString("deviceid", deviceid);
  //     // prefs.setInt("password", loginwithserver['data']['password']);
  //     prefs.setString("token", loginwithserver['access_token']);
  //     //prefs.setString('email', emailController.text);
  //     //Navigator.push(context, MaterialPageRoute(builder: (context)=>DashboardScreen()));
  //   }
  // }

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

          getdaytext();
          //  getDay();
        } else {
          getnext = prefs.getString("nextdate");
          getfertile = prefs.getString("fertilewindow");
          getdaytext();
          // getDay();
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

  // Future<void> getDay() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   var select = preferences.getString("selected");
  //   print("toays dayt" + select.toString().substring(8, 10));
  //   print("toays dayt" + formattedDate.toString().substring(8, 10));
  //   print(
  //       "${DateTime.parse(formattedDate).difference(DateTime.parse(select)).inDays}");
  //   periodno = (DateTime.parse(formattedDate)
  //           .difference(DateTime.parse(select))
  //           .inDays)
  //       .toString();
  //   // if(periodno){}
  // }
  dynamic getalldays = new List();
  Future<void> getdaytext() async {
    try {
      final response = await http.post(
          Uri.parse("http://18.219.10.133/api/display-date-results"),
          headers: {
            'Authorization': 'Bearer $token',
          });
      //print("bjkb" + response.statusCode.toString());
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        getalldays = responseJson;
        // print(loginwithserver['data']['email']);
        print(getalldays);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("nextperiod", getalldays['data']['next_period_date']);
        prefs.setString(
            "fertilewindow", getalldays['data']['fertile_window_starts']);
        prefs.setBool("buttonvisibility", getalldays['button']);
        prefs.setString("buttontext", getalldays['text']);
        prefs.setInt("totaldays", getalldays['days']);
        getnext = prefs.getString("nextperiod");
        getfertile = prefs.getString("fertilewindow");
        getdays=(DateTime.parse(getfertile).day-5).toString();
        print("jhebieri"+getdays);
        periodno = prefs.getInt("totaldays").toString();
        prefs.setString("daystext", getalldays['days_text']);

        if (prefs.getString("buttontext") == null) {
          print("kofo;dodofsd ");
          prefs.setString("buttontext", "button");
        } else {
          prefs.setString("buttontext", getalldays['text']);
        }

        // loginasguest(deviceid);
        // showToast("");
        // savedata(deviceid);
        // gettoken();
        // getalert();
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

  Future<void> gettoken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    alert = prefs.getString("alert");

    i=i+1;
    print("------"+i.toString());
    if(i==1){
      getalert();
    }
    else{
      if (alert == null) {
        //showAlertDialog(context);
      } else {
        getNextperiod();
      }
     // getNextperiod();
    }

  }
}

class BodyContent extends StatefulWidget {

   String title;
   String date;
   BodyContent({Key key, @required this.title, @required this.date})
      : super(key: key);


  @override
  _BodyContentState createState() => _BodyContentState();
}

class _BodyContentState extends State<BodyContent> {
  bool pregnancy=false;
  @override
  void initState() {
    // TODO: implement initState
    //getpregnant();

  }
  getpregnant() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

     // pregnancy = prefs.getBool("pregnancy");
     // print(pregnancy);


     if (prefs.getBool("pregnancy") == false||null) {
       print("iiiiiiiiii");
      setState(() {
        pregnancy = true;
      });
     }
     else if (prefs.getBool("pregnancy") ==true){
       print("jkwvkbjkb");
      setState(() {
        pregnancy=false;
      });

     }

  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(10),
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
                  widget.title,
                  style: TextStyle(
                      color: kPrimaryColor, fontWeight: FontWeight.w600),
                ),
               Text(
                    widget.date == null ? "" : widget.date,
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
