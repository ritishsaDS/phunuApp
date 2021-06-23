import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:lunar_calendar/lunar_calendar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:vietnamese/common/Api.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/components/bottom.dart';
import 'package:vietnamese/models/notesmodel.dart';

class Lunar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Lunar> with TickerProviderStateMixin {
  CalendarController _calendarController;
  Map<DateTime, List<dynamic>> _events = {};
  // List<CalendarItem> _data = [];
  final TextStyle _textStyle = TextStyle(color: kPrimaryLightColor);
  var value;

  List<dynamic> _selectedEvents = [];

  bool isLoading = false;
  Map<DateTime, List> _holidays = {};
  DateTime _selectedDateTime;
  List<Widget> get _eventWidgets =>
      _selectedEvents.map((e) => events(e)).toList();
  List<Data> _data = [];
  var start;
  var next;
  var count = 0;
  DateTime _selectedDay = DateTime.now();
  void initState() {
    super.initState();
    getnextdate();
    _fetchEvents();
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();

    List<int> lunarVi =
        CalendarConverter.solarToLunar(2020, 12, 14, Timezone.Vietnamese);
    List<int> lunarJa =
        CalendarConverter.solarToLunar(2020, 12, 14, Timezone.Japanese);
    print(lunarVi);
    print(lunarJa);
  }

  dynamic nextfromserver = new List();
  Future<void> _fetchEvents() async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    print(token);
    try {
      final response = await http.post(
        "http://girl-period.uplosse.com/api/get-user-notes",
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        nextfromserver = responseJson['data'];

        print(nextfromserver);
        List<dynamic> _results = await nextfromserver;
        print("dsnonlnsod" + _results.toString());
        _data = _results.map((item) => Data.fromJson(item)).toList();
        _data.forEach((element) {
          DateTime formattedDate = DateTime.parse(DateFormat('yyyy-MM-dd')
              .format(DateTime.parse(element.date.toString())));
          if (_events.containsKey(formattedDate)) {
            _events[formattedDate].add(element.date.toString());
          } else {
            _events[formattedDate] = [element.date.toString()];
          }
        });
        setState(() {});

        /// notesdate = nextfromserver['date'];
        // usernotes = nextfromserver["note"];
        // print(nextfromserver[0]["note"]);
        setState(() {
          isLoading = false;
          print('setstate');
        });
      } else {
        print("bjkb" + response.statusCode.toString());

        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  AnimationController _animationController;
  Widget events(var d) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          decoration: BoxDecoration(
              border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor),
          )),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(d, style: Theme.of(context).primaryTextTheme.bodyText1),
            IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.trashAlt,
                  color: Colors.redAccent,
                  size: 15,
                ),
                onPressed: () {})
          ])),
    );
  }

  void _onDaySelected(DateTime day) {
    _animationController.forward(from: 0.0);
    setState(() {
      _selectedDay = day;
      //_selectedEvents = events;
    });
  }

  // void _fetchEvents() async {
  //   _events = {};
  //   List<Map<String, dynamic>> _results = await DB.query(CalendarItem.table);
  //   print(_results);
  //   _data = _results.map((item) => CalendarItem.fromMap(item)).toList();
  //   _data.forEach((element) {
  //     DateTime formattedDate = DateTime.parse(DateFormat('yyyy-MM-dd')
  //         .format(DateTime.parse(element.date.toString())));
  //     if (_events.containsKey(formattedDate)) {
  //       _events[formattedDate].add(element.name.toString());
  //     } else {
  //       _events[formattedDate] = [element.name.toString()];
  //     }
  //   });
  //   setState(() {});
  // }

  String printLunarDate(DateTime solar) {
    List<int> lunar = CalendarConverter.solarToLunar(
        solar.year, solar.month, solar.day, Timezone.Japanese);
    return DateFormat.Md('ja').format(DateTime(lunar[2], lunar[1], lunar[0]));
  }

  Widget buildCell(Color color, DateTime date) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.only(top: 5.0, left: 6.0, right: 3, bottom: 3),
      width: 100,
      height: 100,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '${printLunarDate(date)}',
                  style: TextStyle().copyWith(fontSize: 10.0),
                ),
              ),
            ),
          ]),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.line_style,
      size: 20.0,
      color: Colors.pink,
    );
  }

  Widget calendar() {
    var tableCalendar = TableCalendar(
      holidays: _holidays,
      calendarStyle: CalendarStyle(
        canEventMarkersOverflow: true,
        markersColor: Colors.white,
        weekdayStyle: TextStyle(color: Colors.white),
        todayColor: Colors.white54,
        todayStyle: TextStyle(
            color: Colors.redAccent, fontSize: 15, fontWeight: FontWeight.bold),
        selectedColor: Colors.red[900],
        outsideWeekendStyle: TextStyle(color: Colors.white60),
        outsideStyle: TextStyle(color: Colors.white60),
        weekendStyle: TextStyle(color: Colors.white),
        renderDaysOfWeek: false,
      ),

      /// onDaySelected:_onDaySelected(DateTime.now()),
      calendarController: _calendarController,
      events: _events,
      builders: CalendarBuilders(
        dayBuilder: (context, date, events) {
          return buildCell(Colors.grey.withOpacity(0.1), date);
        },
        selectedDayBuilder: (context, date, _) {
          count++;
          getmethod(date);

          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: buildCell(Colors.deepOrange[300].withOpacity(0.5), date),
          );
        },
        todayDayBuilder: (context, date, _) {
          return buildCell(Colors.amber[400].withOpacity(0.5), date);
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            print(holidays[0]);
            children.add(
              Positioned(
                child: Container(
                  alignment: Alignment.topCenter,
                  height: 2,
                  color: Colors.pink,
                ),
              ),
            );
          }

          return children;
        },
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        leftChevronIcon:
            Icon(Icons.arrow_back_ios, size: 15, color: Colors.pink),
        rightChevronIcon:
            Icon(Icons.arrow_forward_ios, size: 15, color: Colors.pink),
        titleTextStyle: TextStyle(color: Colors.pink, fontSize: 16),
      ),
    );
    return Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: tableCalendar);
  }

  Widget eventTitle() {
    if (_selectedEvents.length == 0) {
      return Container(
        padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
        child: Text("No events",
            style: Theme.of(context).primaryTextTheme.headline1),
      );
    }
    return Container(
      padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
      child:
          Text("Events", style: Theme.of(context).primaryTextTheme.headline1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      body: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BottomTabs(1, true),
          calendar(),
          Container(
            height: getProportionateScreenHeight(250),
            child: Stack(
              children: [
                Container(
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            backgroundColor: kPrimaryColor,
                          ),
                        )
                      : ListView(
                          children: notesdatewidget(),
                        ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void getnextdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    next = prefs.getString("nextdate");
    start = prefs.getString("startdate");
    print(DateTime.parse(start).day);
    var one;
    var two;
    // int startyear = DateTime(int.parse(start)).year;
    // int startmonth = DateTime(int.parse(start)).month;
    // int startday = DateTime(int.parse(start)).day;
    //  print(startyear + startday);
    var three;
    _holidays = {
      DateTime(DateTime.parse(start).year, DateTime.parse(start).month,
          DateTime.parse(start).day): ['Christmas Day'],
      DateTime(DateTime.parse(next).year, DateTime.parse(next).month,
          DateTime.parse(next).day): ['New Year\'s Day'],
    };
    //print(one+two+three);

    if (prefs.getString("selecteddate") == null) {
    } else {
      _selectedDateTime = DateTime.parse(prefs.getString("selecteddate"));
    }

    //print(next.toString().substring(8));
  }

  void getmethod(date) {
    setState(() {
      getnotescount(date);
    });
  }

  dynamic countfromserver = new List();
  Future<void> getnotescount(date) async {
    // isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    print(token);
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

        countfromserver = responseJson['data'];
        // count = responseJson['notes_count'];
        // count = noteslength;
        //  print(count);
        print(countfromserver);
        if (countfromserver.length == 0) {
          value = "[]";
          showToast("No Notes Found!!!");
          //return Text("data");
          print(value + "jbj");
        } else {
          print("object");
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

  List<Widget> notesdatewidget() {
    List<Widget> productList = new List();
    for (int i = 0; i < countfromserver.length; i++) {
      print(
        "knlwnl" + countfromserver[i]['date'].toString().replaceAll("-", "/"),
      );
      productList.add(Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
        ),
        child: value != []
            ? Container(
                margin: EdgeInsets.only(top: 10),
                height: getProportionateScreenHeight(100),
                width: SizeConfig.screenWidth,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: kPrimaryColor),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      countfromserver[i]['date']
                          .toString()
                          .replaceAll("-", "/"),
                      style: _textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      countfromserver[i]['note'] == null
                          ? ""
                          : countfromserver[i]['note'],
                      style: _textStyle,
                    ),
                  ],
                ))
            : Container(
                height: getProportionateScreenHeight(100),
                width: SizeConfig.screenWidth,
                child: Text("No Notes Found"),
              ),
      ));
    }
    return productList;
  }

 
}
