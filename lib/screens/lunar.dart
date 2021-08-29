import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lunar_calendar/lunar_calendar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vietnamese/common/Api.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/components/bottom.dart';
import 'package:vietnamese/models/calendarprovider.dart';
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
  var fertiletwo;
  var fertileone;
  var fertilethee;
  var fertilefour;
  var fertilefive;
  var fertilesix;
  List<dynamic> _selectedEvents = [];
  var pregnancy;
  bool isLoading = false;
  var fertilewindow;
  Map<DateTime, List> _holidays = {};
  DateTime _selectedDateTime;
  List<Widget> get _eventWidgets =>
      _selectedEvents.map((e) => events(e)).toList();
  List<Data> _data = [];
  var start;
  var next;
  var _bool = true;
  var _boolCheck = true;
  var count = 0;
  DateTime _selectedDay = DateTime.now();
  var ourdate;
  void initState() {
    super.initState();
    //  Provider.of<Calendarprovider>(context, listen: false).getnotes(ourdate);
    //getnotescount(ourdate);
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
        "http://18.219.10.133/api/get-user-notes",
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print("jenjksdnljsd");
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        nextfromserver = responseJson['data'];

        print(responseJson);
        List<dynamic> _results = await nextfromserver;
        print("dsnonlnsod" + _results.toString());
        _data = _results.map((item) => Data.fromJson(item)).toList();
        _data.forEach((element) {
          DateTime formattedDate = DateTime.parse(DateFormat('yyyy-MM-dd')
              .format(DateTime.parse(element.date.toString())));
          if (_events.containsKey(formattedDate)) {
            print(_events.toString() + "fvdvdfff");
            var flow = element.filed_count;
            var eventlength = [];
            List<String> cddc = List<String>.generate(flow, (counter) {
              // print("item" + counter.toString());
              eventlength.add(counter);
            });

            print("element" + element.flow.toString() + element.date);
            _events[formattedDate] = eventlength;
          } else {
            var flow = element.filed_count;
            var eventlength = [];
            List<String> cddc = List<String>.generate(flow, (counter) {
              // print("item" + counter.toString());
              eventlength.add(counter);
            });
            print("element" + element.filed_count.toString() + element.date);
            _events[formattedDate] = eventlength;
          }
        });

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
    getmethod(ourdate).dispose();
    getnotescount(ourdate).dispose();

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
            Text("djhdsjhl",
                style: Theme.of(context).primaryTextTheme.bodyText1),
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
        solar.year, solar.month, solar.day, Timezone.Vietnamese);
    return DateFormat.Md('vi').format(DateTime(lunar[2], lunar[1], lunar[0]));
  }

  Widget buildCell(Color color, DateTime date) {
    return  SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      margin:  EdgeInsets.only(top:2.0,left: 4,right: 4,bottom: 10),
       //padding:  EdgeInsets.only( bottom: 3),
      width: 100,
      height: SizeConfig.screenHeight*0.048,

        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Text('${date.day}',
                      style: TextStyle().copyWith(fontSize: 16.0))),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '${printLunarDate(date)}',
                    style: TextStyle().copyWith(fontSize: 10.0),
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return Container(
       // duration: const Duration(milliseconds: 300),
        width: 16.0,
        height: 16.0,
        child: Padding(
          padding:  EdgeInsets.only(left: 6),
          child: Container(
            height: 20,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    margin: EdgeInsets.only(top: 5, left: 5),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    height: 5,
                    width: 5,
                    decoration: new BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ));
              },
              itemCount: events.length > 3 ? 3 : events.length,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ));
  }

  Widget _buildHolidaysMarker() {
    return Container(
      height: 5,
      margin: EdgeInsets.only(left: 5, right: 5),
      color: Colors.pink,
    );
  }

  Widget _buildHolidays2Marker() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepOrange[300].withOpacity(0.5),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      margin: const EdgeInsets.all(4.0),
      // padding: const EdgeInsets.only(top: 5.0, left: 6.0, right: 3, bottom: 3),
      width: 100,
      height: 35,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 5,
                  margin: EdgeInsets.only(left: 5, right: 5),
                  color: Colors.white,
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text('${DateTime.parse(fertilewindow).day}',
                        style: TextStyle().copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '${printLunarDate(DateTime.parse(fertilewindow))}',
                  style:
                      TextStyle().copyWith(fontSize: 10.0, color: Colors.white),
                ),
              ),
            ),
          ]),
    );
  }

  Widget _buildHolidays3Marker() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepOrange[300].withOpacity(0.5),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      margin: const EdgeInsets.all(4.0),
      // padding: const EdgeInsets.only(top: 5.0, left: 6.0, right: 3, bottom: 3),
      width: 100,
      height: 35,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 5,
                  margin: EdgeInsets.only(left: 5, right: 5),
                  color: Colors.white,
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text('${DateTime.parse(fertileone.toString()).day}',
                        style: TextStyle().copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '${printLunarDate(DateTime.parse(fertileone.toString()))}',
                  style:
                      TextStyle().copyWith(fontSize: 10.0, color: Colors.white),
                ),
              ),
            ),
          ]),
    );
  }

  Widget _buildHolidays4Marker() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepOrange[300].withOpacity(0.5),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      margin: const EdgeInsets.all(4.0),
      // padding: const EdgeInsets.only(top: 5.0, left: 6.0, right: 3, bottom: 3),
      width: 100,
      height: 35,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 5,
                  margin: EdgeInsets.only(left: 5, right: 5),
                  color: Colors.white,
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text('${DateTime.parse(fertiletwo.toString()).day}',
                        style: TextStyle().copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '${printLunarDate(DateTime.parse(fertiletwo.toString()))}',
                  style:
                      TextStyle().copyWith(fontSize: 10.0, color: Colors.white),
                ),
              ),
            ),
          ]),
    );
  }

  Widget _buildHolidays5Marker(DateTime date) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepOrange[300].withOpacity(0.5),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      margin: const EdgeInsets.all(4.0),
      // padding: const EdgeInsets.only(top: 5.0, left: 6.0, right: 3, bottom: 3),
      width: 100,
      height: 35,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 5,
                  margin: EdgeInsets.only(left: 5, right: 5),
                  color: Colors.white,
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text('${DateTime.parse(date.toString()).day}',
                        style: TextStyle().copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '${printLunarDate(DateTime.parse(date.toString()))}',
                  style:
                      TextStyle().copyWith(fontSize: 10.0, color: Colors.white),
                ),
              ),
            ),
          ]),
    );
  }

  getBool() {
    setState(() {
      _bool = true;
    });
  }

  Widget calendar() {
    var tableCalendar = TableCalendar(
      holidays: _holidays,
      availableCalendarFormats: {
        CalendarFormat.month: '',
      },
      startingDayOfWeek: StartingDayOfWeek.monday,

      availableGestures: AvailableGestures.all,
      calendarStyle: CalendarStyle(
        canEventMarkersOverflow: true,
        markersColor: Colors.white,
        weekdayStyle: TextStyle(color: Colors.red),
        todayColor: Colors.deepOrange[300].withOpacity(0.5),
        todayStyle: TextStyle(color: Colors.redAccent, fontSize: 16),
        selectedColor: Colors.deepOrange[300],
        outsideWeekendStyle: TextStyle(color: Colors.white60),
        outsideStyle: TextStyle(color: Colors.white60),
        weekendStyle: TextStyle(color: Colors.white),

        renderDaysOfWeek: true,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle:
            TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        weekendStyle: TextStyle().copyWith(color: Colors.grey),
      ),

      /// onDaySelected:_onDaySelected(DateTime.now()),
      calendarController: _calendarController,
      events: _events,
      builders: CalendarBuilders(
        dayBuilder: (context, date, events) {
          return Container(
            height: 250,
            child: Column(
              children: [
                buildCell(Colors.grey[300].withOpacity(0.5), date),
                Divider(
                  height: 1,
                  thickness: 0.2,
                  color: Colors.pink,
                )
              ],
            ),
          );
        },
        selectedDayBuilder: (context, date, _) {
          print("selected");
          if (date != ourdate) {
            count = 0;
          } else {}
          if (count == 0) {
            ourdate = date;

            getmethod(date);
            print(date);
            // count = 0;
          }

          //_fetchEvents();

          return GestureDetector(
            onTap: () {
             // print(date);
            },
            child: Container(
              child: buildCell(Colors.deepOrange[300].withOpacity(0.5), date),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          // print(date);

          return buildCell(Colors.red.withOpacity(0.7), date);
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                bottom: 2,
                left: 0,
                right: 0,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            print(holidays);

            children.add(pregnancy == false
                ? holidays.contains("fertile window")
                    ? Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: _buildHolidays2Marker())
                    : holidays.contains("fertile windowone")
                        ? Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: _buildHolidays3Marker())
                        : holidays.contains("fertile windowtwo")
                            ? Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: _buildHolidays4Marker())
                            : holidays.contains("fertile windothree")
                                ? Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: _buildHolidays5Marker(fertilethee))
                                : holidays.contains("fertile windowfour")
                                    ? Positioned(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        child:
                                            _buildHolidays5Marker(fertilefour))
                                    : holidays.contains("fertile windowfive")
                                        ? Positioned(
                                            top: 0,
                                            left: 0,
                                            right: 0,
                                            child: _buildHolidays5Marker(
                                                fertilefive))
                                        : holidays.contains("fertile windowsix")
                                            ? Positioned(
                                                top: 0,
                                                left: 0,
                                                right: 0,
                                                child: _buildHolidays5Marker(
                                                    fertilesix))
                                            : Positioned(
                                                top: 5,
                                                left: 0,
                                                right: 0,
                                                child: _buildHolidaysMarker())
                : Container());
          }

          return children;
        },
      ),
      headerStyle: HeaderStyle(
        headerMargin: EdgeInsets.symmetric(vertical: 5),
        formatButtonVisible: false,
        decoration: BoxDecoration(
            //color: Colors.pink,
            border: Border(bottom: BorderSide(color: Colors.pink))),
        centerHeaderTitle: true,
        leftChevronIcon:
            Icon(Icons.arrow_back_ios, size: 15, color: Colors.pink),
        rightChevronIcon:
            Icon(Icons.arrow_forward_ios, size: 15, color: Colors.pink),
        titleTextStyle: TextStyle(
            color: Colors.pink, fontSize: 20, fontWeight: FontWeight.bold),
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
    if (_selectedEvents.length == 0 || null) {
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
      body: SafeArea(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BottomTabs(1, true),
            calendar(),
            Divider(
              color: Colors.pink,
              thickness: 1.5,
            ),
            Expanded(
              child: Container(
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
            ),
          ],
        ),
      ),
    );
  }

  void getnextdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fertilewindow = prefs.getString("fertilewindow");
    pregnancy = prefs.getBool("pregnancy");
    print(pregnancy);
    if (pregnancy == null) {
      pregnancy = false;
    }

    print("knewjldsnlwkl");
    next = prefs.getString("nextdate");
    start = prefs.getString("startdate");

    print(DateTime.parse(start).day);
    print(prefs.getInt("login_count"));
    var two;
    var one =
    DateTime(DateTime.parse(start).year, DateTime.parse(start).month,
        DateTime.parse(start).day + 1);
    two = DateTime(
        DateTime.parse(one.toString()).year,
        DateTime.parse(one.toString()).month,
        DateTime.parse(one.toString()).day + 1);
    // int startyear = DateTime(int.parse(start)).year;
    // int startmonth = DateTime(int.parse(start)).month;
    // int startday = DateTime(int.parse(start)).day;
    //  print(startyear + startday);
    var three;
    var four;

    three = DateTime(
        DateTime.parse(two.toString()).year,
        DateTime.parse(two.toString()).month,
        DateTime.parse(two.toString()).day + 1);
    four = DateTime(
        DateTime.parse(three.toString()).year,
        DateTime.parse(three.toString()).month,
        DateTime.parse(three.toString()).day + 1);
    fertileone = DateTime(
        DateTime.parse(fertilewindow.toString()).year,
        DateTime.parse(fertilewindow.toString()).month,
        DateTime.parse(fertilewindow.toString()).day - 1);
    fertiletwo = DateTime(
        DateTime.parse(fertileone.toString()).year,
        DateTime.parse(fertileone.toString()).month,
        DateTime.parse(fertileone.toString()).day - 1);
    // int startyear = DateTime(int.parse(start)).year;
    // int startmonth = DateTime(int.parse(start)).month;
    // int startday = DateTime(int.parse(start)).day;
    print(fertiletwo.day + fertileone.day);

    fertilethee = DateTime(
        DateTime.parse(fertiletwo.toString()).year,
        DateTime.parse(fertiletwo.toString()).month,
        DateTime.parse(fertiletwo.toString()).day - 1);
    fertilefour = DateTime(
        DateTime.parse(fertilethee.toString()).year,
        DateTime.parse(fertilethee.toString()).month,
        DateTime.parse(fertilethee.toString()).day - 1);
    fertilefive = DateTime(
        DateTime.parse(fertilefour.toString()).year,
        DateTime.parse(fertilefour.toString()).month,
        DateTime.parse(fertilefour.toString()).day - 1);
    fertilesix = DateTime(
        DateTime.parse(fertilefive.toString()).year,
        DateTime.parse(fertilefive.toString()).month,
        DateTime.parse(fertilefive.toString()).day - 1);
    _holidays = {
      DateTime(
          DateTime.parse(fertilewindow).year,
          DateTime.parse(fertilewindow).month,
          DateTime.parse(fertilewindow).day): ["fertile window"],
      DateTime(
          DateTime.parse(fertiletwo.toString()).year,
          DateTime.parse(fertiletwo.toString()).month,
          DateTime.parse(fertiletwo.toString()).day): ["fertile windowtwo"],
      DateTime(
          DateTime.parse(fertileone.toString()).year,
          DateTime.parse(fertileone.toString()).month,
          DateTime.parse(fertileone.toString()).day): ["fertile windowone"],
      DateTime(
          DateTime.parse(fertilethee.toString()).year,
          DateTime.parse(fertilethee.toString()).month,
          DateTime.parse(fertilethee.toString()).day): ["fertile windothree"],
      DateTime(DateTime.parse(start).year, DateTime.parse(start).month,
          DateTime.parse(start).day): ['Christmas Day'],
      DateTime(DateTime.parse(next).year, DateTime.parse(next).month,
          DateTime.parse(next).day): ['New Year\'s Day'],
      DateTime(
          DateTime.parse(fertilefour.toString()).year,
          DateTime.parse(fertilefour.toString()).month,
          DateTime.parse(fertilefour.toString()).day): ["fertile windowfour"],
      DateTime(
          DateTime.parse(fertilefive.toString()).year,
          DateTime.parse(fertilefive.toString()).month,
          DateTime.parse(fertilefive.toString()).day): ["fertile windowfive"],
      DateTime(
          DateTime.parse(fertilesix.toString()).year,
          DateTime.parse(fertilesix.toString()).month,
          DateTime.parse(fertilesix.toString()).day): ["fertile windowsix"],
      DateTime(
          DateTime.parse(one.toString()).year,
          DateTime.parse(one.toString()).month,
          DateTime.parse(one.toString()).day): [""],
      DateTime(
          DateTime.parse(two.toString()).year,
          DateTime.parse(two.toString()).month,
          DateTime.parse(two.toString()).day): [""],
      DateTime(
          DateTime.parse(three.toString()).year,
          DateTime.parse(three.toString()).month,
          DateTime.parse(three.toString()).day): [""],
      DateTime(
          DateTime.parse(four.toString()).year,
          DateTime.parse(four.toString()).month,
          DateTime.parse(four.toString()).day): [""]
    };
    //print(one+two+three);

    if (prefs.getString("selecteddate") == null) {
    } else {
      _selectedDateTime = DateTime.parse(prefs.getString("selecteddate"));
    }

    //print(next.toString().substring(8));
  }

  getmethod(date) async {
    print("dskl");
    if (count == 0) {
      getnotescount(date);
    } else {}
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString("selecteddate", date.toString());
    print(preferences.getString("selecteddate"));
  }

  dynamic listdata;
  dynamic mooddata = new List();
  dynamic moodserver = new List();
  dynamic countfromserver = new List();
  getnotescount(date) async {
    count++;
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

        setState(() {
          countfromserver = responseJson['data'];
          //  print(listdata['mood'])
          //  moodserver = mooddata;
        });
        print(responseJson);

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

  var moodstatic = [
    "Khó chịu",
    "Buồn",
    "Buồn chán",
    "Cô đơn",
    "Dễ xúc động",
    "Mệt đừ",
    "Muốn gây chuyện",
    "Nóng nảy",
    "Tự tin",
    "Yêu đời",
    "Bình thường"
  ];

  List<Widget> notesdatewidget() {
    List<Widget> productList = new List();

    for (int i = 0; i < countfromserver.length; i++) {

      productList.add(Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
        ),

        child: value != []

            ?
        Container(
                margin: EdgeInsets.only(top: 10),
                //height: getProportionateScreenHeight(150),
                width: SizeConfig.screenWidth,
            alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        DateTime.parse(countfromserver[i]['date'])
                                .day
                                .toString() +
                            "/" +
                            DateTime.parse(countfromserver[i]['date'])
                                .month
                                .toString() +
                            "/" +
                            DateTime.parse(countfromserver[i]['date'])
                                .year
                                .toString(),
                        style: _textStyle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),

                   // SizedBox(height: 10,),
                    Container(
                      child: Wrap(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            countfromserver[i]['note'] == null
                                ? "......"
                                : countfromserver[i]['note'] + "...",
                            style: _textStyle,textAlign:TextAlign.start,
                          ),
                          Text(
                           countfromserver[i]['took_medicine'].toString()=="true"?"Uống thuốc..." :  ""+"...",
                            style: _textStyle,textAlign:TextAlign.start,
                          ),
                          //SizedBox(width: 1,),

                          Text(
                             countfromserver[i]['masturbated'].toString()=="true"?"Tự sướng...":""+"...",
                            style: _textStyle,textAlign:TextAlign.start,
                          ),  //SizedBox(width: 10,),
                          Text(
                            countfromserver[i]['intercourse'].toString()=="true"?"Giao hợp...":""+"...",
                            style: _textStyle,textAlign: TextAlign.start,
                          ),
                          Text(countfromserver[i]['weight']==null||double.parse(countfromserver[i]['weight'])<30||double.parse(countfromserver[i]['weight'])>100?"":
                          "Cân:"+ countfromserver[i]['weight'].toString()+"Kg."+"...",
                            style: _textStyle,textAlign:TextAlign.start,
                          ),
                        //  SizedBox(width: 10,),
                          Text(countfromserver[i]['height']==null||double.parse(countfromserver[i]['height'])<35||double.parse(countfromserver[i]['height'])>50?"":
                          "Thân nhiệt:"+ countfromserver[i]['height'].toString()+"...",
                            style: _textStyle,textAlign:TextAlign.start,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: getmoods(countfromserver[i]['mood']),
                            ),
                          ),
                        ],
                      ),
                      
                    ),

                    SizedBox(height: 10,),
                   // Row(
                   //   children: [
                   //     Text(countfromserver[i]['weight']==null?"":
                   //   "Cân:"+ countfromserver[i]['weight'].toString()+"Kg."+"...",
                   //     style: _textStyle,textAlign:TextAlign.start,
                   //   ),
                   //     SizedBox(width: 10,),
                   //     Text(countfromserver[i]['height']==null?"":
                   //     "Thân nhiệt:"+ countfromserver[i]['height'].toString()+"...",
                   //       style: _textStyle,textAlign:TextAlign.start,
                   //     ),],
                   // ),
                   //  SizedBox(height: 10,),


                    // getmood()
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

  showAlert() {
    return showToast("No Notes Found!!!");
  }

  List<Widget> getmoods(moodget) {
    List<Widget> moodlist = new List();
    for (int i = 0; i < moodget.length; i++) {
      print("knlwnl");
      moodlist.add(Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(1),
          ),
          child: Container(
              child: Text(
            moodstatic[int.parse(moodget[i]['id'])] + "...",
            style: TextStyle(color: kPrimaryColor),textAlign:TextAlign.start,
          ))));
    }
    return moodlist;
  }

  void getlst() {}

  // List<Widget> getmood() {
  //   List<Widget> productList = new List();
  //   for (int i = 0; i < listdata.length; i++) {
  //     print(
  //       "knlwnl" + listdata[i]['date'].toString().replaceAll("-", "/"),
  //     );
  //     productList.add();
  //   }
  //   return productList;
  // }
}
