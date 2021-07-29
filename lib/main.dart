import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vietnamese/common/Api.dart';
import 'package:vietnamese/models/calendarprovider.dart';
import 'package:vietnamese/screens/Articles/articles.dart';
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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

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
  var fcmtoken;
  FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
      messaging = FirebaseMessaging.instance;
      messaging.getToken().then((value) {
        print("fcm" + value);
        fcmtoken = value;
        _getId();
      });
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
     // notifpermission();
      print("message recieved");
      //  print(event.notification.body);
    });

    registerNotification();
    checkForInitialMessage();
    //firebaseCloudMessaging_Listeners();
    // _mockCheckForSession();

    // TODO: implement initState
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

      setState(() {
        _notificationInfo = notification;
        //_totalNotifications++;
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ArticleScreen()));
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
// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   dwjok() {
//     var initializationSettingsAndroid =
//         new AndroidInitializationSettings('@mipmap/ic_launcher');

//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         showNotification(
//             message['notification']['title'], message['notification']['body']);
//         print("onMessage: $message");
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");
//         Navigator.pushNamed(context, '/notify');
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//       },
//     );
//   }

//   Future onSelectNotification(String payload) async {
//     showDialog(
//       context: context,
//       builder: (_) {
//         return new AlertDialog(
//           title: Text("PayLoad"),
//           content: Text("Payload : $payload"),
//         );
//       },
//     );
//   }

//   void showNotification(String title, String body) async {
//     await _demoNotification(title, body);
//   }

//   Future<void> _demoNotification(String title, String body) async {
//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         'channel_ID', 'channel name', 'channel description',
//         importance: Importance.Max,
//         playSound: true,
//         //sound: 'sound',
//         showProgress: true,
//         priority: Priority.High,
//         ticker: 'test ticker');

//     //   var iOSChannelSpecifics = IOSNotificationDetails();
//     //   // var platformChannelSpecifics = NotificationDetails(

//     //   //     android : androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
//     //   await flutterLocalNotificationsPlugin
//     //       .show(0, title, body, platformChannelSpecifics, payload: 'test');
//     // }
//   }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
          title: 'Vietnamese Women',
          theme: theme(),
          debugShowCheckedModeBanner: false,
          home: DashboardScreen(),
    );
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
   // print(fcmtoken + "deviceid");
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
          print('setfffstate');
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
        "Fcmtoken": fcmtoken
      });
      //print("bjkb" + response.statusCode.toString());
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        loginwithserver = responseJson;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("fcmtoken", fcmtoken);
        // print(loginwithserver['data']['email']);
        print(loginwithserver);
        // loginasguest(deviceid);
        // showToast("");
        savedata(deviceid);

        setState(() {
          isError = false;
          isLoading = false;
          print('setstatesdf');
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

  // void firebaseCloudMessaging_Listeners() {
  //   _firebaseMessaging.getToken().then((token) {
  //     print(token);
  //   });
  // }
  //   _firebaseMessaging.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       print('on message $message');
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print('on resume $message');
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print('on launch $message');
  //     },
  //   );
  // }

  // void iOS_Permission() {
  //   _firebaseMessaging.requestNotificationPermissions(
  //       IosNotificationSettings(sound: true, badge: true, alert: true)
  //   );
  //   _firebaseMessaging.onIosSettingsRegistered
  //       .listen((IosNotificationSettings settings)
  //   {
  //     print("Settings registered: $settings");
  //   });
  // }
  Future<void> savedata(deviceid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (loginwithserver['data']['login_count'] == null) {
      prefs.setString("user_type", loginwithserver['data']['user_type']);

      //  prefs.setInt("login_count", loginwithserver['data']['login_count']);
      prefs.setString("deviceid", deviceid);
      // prefs.setInt("password", loginwithserver['data']['password']);
      prefs.setString("token", loginwithserver['access_token']);
     // logintimebackup(prefs.getString("token"));
    } else if (loginwithserver['data']['email'] == null) {
      prefs.setString("user_type", loginwithserver['data']['user_type']);

      prefs.setInt("login_count", loginwithserver['data']['login_count']);
      prefs.setString("deviceid", deviceid);
      // prefs.setInt("password", loginwithserver['data']['password']);
      prefs.setString("token", loginwithserver['access_token']);
    } else {
      prefs.setString("email", loginwithserver['data']['email']);
      prefs.setString("user_type", loginwithserver['data']['user_type']);

      prefs.setInt("login_count", loginwithserver['data']['login_count']);
      prefs.setString("deviceid", deviceid);
      // prefs.setInt("password", loginwithserver['data']['password']);
      prefs.setString("token", loginwithserver['access_token']);
     // logintimebackup(prefs.getString("token"));
      //prefs.setString('email', emailController.text);
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>DashboardScreen()));
    }
  }

  Future<void> logintimebackup(token) async {
    print(token + "tokenthis");
    try {
      final response = await http.post(
        Uri.parse("http://girl-period.uplosse.com/api/login-time-backup"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      //print("bjkb" + response.statusCode.toString());
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        // print(loginwithserver['data']['email']);
        print("nwejlsd");
        print(responseJson);
        // loginasguest(deviceid);
        // showToast("");

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
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
  });

  String title;
  String body;
  String dataTitle;
  String dataBody;
}
