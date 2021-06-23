import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunar_calendar/lunar_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:vietnamese/common/Api.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:http/http.dart' as http;
import 'custom_calendar.dart';

enum CalendarViews { dates, months, year }

class CalanderScreenWidget extends StatefulWidget {
  @override
  _CalanderScreenWidgetState createState() => _CalanderScreenWidgetState();
}

class _CalanderScreenWidgetState extends State<CalanderScreenWidget> {
  DateTime _currentDateTime;
  DateTime _selectedDateTime;
  List<Calendar> _sequentialDates;
  var next;
  var start;
  int midYear;
  CalendarViews _currentView = CalendarViews.dates;
  final List<String> _weekDays = [
    //MON
    'T2',
    'T3',
    'T4',
    'T5',
    'T6',
    'T7',
    'CN',
  ];
  final List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  final TextStyle _textStyle = TextStyle(color: kPrimaryLightColor);
  var token;
  bool isLoading = false;
  var notesdate;
  var usernotes;
  var listOfDates;
  var value;
  dynamic notes = new List();

  @override
  void initState() {
    super.initState();
    getdot();
    getnotescountbymonth();
    getnextdate();
    getNotesdate();
    getnotescount(
        _selectedDateTime == null ? DateTime.now() : _selectedDateTime);
    final date = DateTime.now();
    _currentDateTime = DateTime(date.year, date.month);
    _selectedDateTime = DateTime(date.year, date.month, date.day);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() => _getCalendar());
    });
  }

  String printLunarDate(DateTime solar) {
    List<int> lunar = CalendarConverter.solarToLunar(
        solar.year, solar.month, solar.day, Timezone.Japanese);
    return DateFormat.Md('ja').format(DateTime(lunar[2], lunar[1], lunar[0]));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(children: [
      SizedBox(
        height: 20,
      ),
      Center(
        child: Container(
          margin: EdgeInsets.all(16),
          height: getProportionateScreenHeight(400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.1),
                blurRadius: 12.0,
                spreadRadius: 3.0,
                offset: Offset(0, 15),
              )
            ],
          ),
          child: (_currentView == CalendarViews.dates)
              ? _datesView()
              : (_currentView == CalendarViews.months)
                  ? _showMonthsList()
                  : _yearsView(midYear ?? _currentDateTime.year),
        ),
      ),
      Expanded(
        //: getProportionateScreenHeight(250),

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
    ])));
  }

  // List<Widget> notesdatewidget() {
  //   List<Widget> productList = new List();
  //   for (int i = 0; i < nextfromserver.length; i++) {
  //     productList.add(Padding(
  //       padding: EdgeInsets.symmetric(
  //         horizontal: getProportionateScreenWidth(20),
  //       ),
  //       child: Container(
  //           margin: EdgeInsets.only(top: 10),
  //           height: getProportionateScreenHeight(100),
  //           width: SizeConfig.screenWidth,
  //           alignment: Alignment.center,
  //           decoration: BoxDecoration(
  //             border: Border.all(color: kPrimaryColor),
  //             borderRadius: BorderRadius.circular(16),
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Text(
  //                 nextfromserver[i]['date'].toString().replaceAll("-", "/"),
  //                 style: _textStyle.copyWith(
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               Text(
  //                 nextfromserver[i]['note'],
  //                 style: _textStyle,
  //               ),
  //             ],
  //           )),
  //     ));
  //   }
  //   return productList;
  // }

  // dates view
  Widget _datesView() {
    return SizedBox(
      height: getProportionateScreenHeight(320),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // header
          Container(
            height: getProportionateScreenHeight(50),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // prev month button
                _toggleBtn(false, Colors.white),
                // month and year
                InkWell(
                  onTap: () =>
                      setState(() => _currentView = CalendarViews.months),
                  child: Center(
                    child: Text(
                      '${_monthNames[_currentDateTime.month - 1]} ${_currentDateTime.year}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                // next month button
                _toggleBtn(true, Colors.white),
              ],
            ),
          ),

          SizedBox(
            height: 10,
          ),
          Container(
            height: getProportionateScreenHeight(320),
            padding: EdgeInsets.all(16),
            child: _calendarBody(),
          ),
        ],
      ),
    );
  }

  // next / prev month buttons
  Widget _toggleBtn(bool next, Color color) {
    return InkWell(
      onTap: () {
        if (_currentView == CalendarViews.dates) {
          setState(() => (next) ? _getNextMonth() : _getPrevMonth());
        } else if (_currentView == CalendarViews.year) {
          if (next) {
            midYear =
                (midYear == null) ? _currentDateTime.year + 9 : midYear + 9;
          } else {
            midYear =
                (midYear == null) ? _currentDateTime.year - 9 : midYear - 9;
          }
          setState(() {});
        }
      },
      child: Container(
        alignment: Alignment.center,
        child: Icon((next) ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
            color: color),
      ),
    );
  }

  // calendar
  Widget _calendarBody() {
    if (_sequentialDates == null) return Container();
    return SwipeDetector(
      onSwipeRight: () {
        setState(() {
          _getPrevMonth();

          print("swipe right");
        });
      },
      onSwipeLeft: () {
        setState(() {
          _getNextMonth();
        });
      },
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: _sequentialDates.length + 7,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 20,
          crossAxisCount: 7,
          crossAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          if (index < 7) return _weekDayTitle(index);

          if (_sequentialDates[index - 7].date == _selectedDateTime)
            return _selector(_sequentialDates[index - 7]);
          //  nextdate();

          return _calendarDates(_sequentialDates[index - 7]);
        },
      ),
    );
  }

  getdot() {
    var now = DateTime.now();

    // Getting the total number of days of the month
    var totalDays = daysInMonth(now);

    // Stroing all the dates till the last date
    // since we have found the last date using generate
    listOfDates =
        new List<String>.generate(totalDays, (i) => "2020/06/${i + 1}");
    print(listOfDates);
  }

// this returns the last date of the month using DateTime
  int daysInMonth(DateTime date) {
    var firstDayThisMonth = new DateTime(date.year, date.month, date.day);
    var firstDayNextMonth = new DateTime(firstDayThisMonth.year,
        firstDayThisMonth.month + 1, firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  // calendar header
  Widget _weekDayTitle(int index) {
    return Text(
      _weekDays[index],
      style: TextStyle(
          color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
    );
  }

  // calendar element
  Widget _calendarDates(Calendar calendarDate) {
    return InkWell(
        onTap: () async {
          if (_selectedDateTime != calendarDate.date) {
            if (calendarDate.nextMonth) {
              _getNextMonth();
            } else if (calendarDate.prevMonth) {
              _getPrevMonth();
            }
            setState(() => _selectedDateTime = calendarDate.date);
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            setState(() async {
              preferences.setString(
                  "selecteddate", _selectedDateTime.toString());
              print(preferences.getString("selecteddate"));
              getnotescount(_selectedDateTime);
              isLoading = true;
            });
            //print(DateTime.parse(next));
          }
        },
        child: calendarDate.date.day != DateTime.parse(next).day
            ? SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '${calendarDate.date.day}',
                      style: TextStyle(
                        fontSize: 10,
                        color: (calendarDate.thisMonth)
                            ? (calendarDate.date.weekday == DateTime.sunday)
                                ? Colors.black
                                : Colors.black
                            : (calendarDate.date.weekday == DateTime.sunday)
                                ? Colors.black.withOpacity(0.5)
                                : Colors.black.withOpacity(0.5),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${printLunarDate(DateTime.parse(calendarDate.date.toString()))}',
                        style: TextStyle().copyWith(fontSize: 8.0),
                      ),
                    ),
                    notes != null && notes.toString().length > 0
                        ? Container(
                            height: 20,
                            child: ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    margin: EdgeInsets.only(top: 5),
                                    height: 5,
                                    width: 5,
                                    decoration: new BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ));
                              },
                              itemCount: 2,
                              scrollDirection: Axis.horizontal,
                            ),
                          )
                        : SizedBox()
                  ],
                ),
              )
            : calendarDate.date.month < DateTime.parse(next).month ||
                    calendarDate.date.month > DateTime.parse(next).month
                ? Container(
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            "${DateTime.parse(next).day}",
                            style: TextStyle().copyWith(fontSize: 7.0),
                          ),
                        ),
                        Text(
                          '${printLunarDate(DateTime.parse(next.toString()))}',
                          style: TextStyle().copyWith(fontSize: 7.0),
                        )
                      ],
                    ),
                  )
                : DateTime.parse(start).day != calendarDate.date.day &&
                        DateTime.parse(start).month == calendarDate.date.month
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: kPrimaryColor,
                          ),
                        ),
                        child: Center(
                          child: Text("${DateTime.parse(next).day}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 8)),
                        ),
                      )
                    : Container(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.pink,
                          ),
                          child: Column(
                            children: [
                              Text(
                                DateTime.parse(next).day.toString(),
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                    '${printLunarDate(DateTime.parse(next.toString()))}',
                                    style: TextStyle(
                                        fontSize: 9, color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      ));
  }

  // date selector
  Widget _selector(Calendar calendarDate) {
    return GestureDetector(
      onTap: () {
        print('${calendarDate.date.day}');
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: kPrimaryColor,
          ),
        ),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${calendarDate.date.day.toString()}',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${printLunarDate(DateTime.parse(calendarDate.date.toString()))}',
                      style: TextStyle(fontSize: 8.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget nextdate(Calendar calendarDate) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: kPrimaryColor,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            children: [
              Text(
                "${calendarDate.next.toString().substring(8)}",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  '${printLunarDate(DateTime.parse(calendarDate.next.toString().substring(8)))}',
                  style: TextStyle().copyWith(fontSize: 8.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // get next month calendar
  void _getNextMonth() {
    if (_currentDateTime.month == 12) {
      _currentDateTime = DateTime(_currentDateTime.year + 1, 1);
    } else {
      _currentDateTime =
          DateTime(_currentDateTime.year, _currentDateTime.month + 1);
    }
    _getCalendar();
  }

  // get previous month calendar
  void _getPrevMonth() {
    if (_currentDateTime.month == 1) {
      _currentDateTime = DateTime(_currentDateTime.year - 1, 12);
    } else {
      _currentDateTime =
          DateTime(_currentDateTime.year, _currentDateTime.month - 1);
    }
    _getCalendar();
  }

  // get calendar for current month
  void _getCalendar() {
    _sequentialDates = CustomCalendar().getMonthCalendar(
        _currentDateTime.month, _currentDateTime.year,
        startWeekDay: StartWeekDay.monday);
  }

  // show months list
  Widget _showMonthsList() {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () => setState(() => _currentView = CalendarViews.year),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              '${_currentDateTime.year}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryColor),
            ),
          ),
        ),
        Divider(
          color: Colors.black38,
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: _monthNames.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                _currentDateTime = DateTime(_currentDateTime.year, index + 1);
                _getCalendar();
                setState(() => _currentView = CalendarViews.dates);
              },
              title: Center(
                child: Text(
                  _monthNames[index],
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: (index == _currentDateTime.month - 1)
                          ? kPrimaryColor
                          : Colors.black),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // years list views
  Widget _yearsView(int midYear) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _toggleBtn(false, Colors.black),
              Spacer(),
              _toggleBtn(true, Colors.black),
            ],
          ),
          Expanded(
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: 9,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  int thisYear;
                  if (index < 4) {
                    thisYear = midYear - (4 - index);
                  } else if (index > 4) {
                    thisYear = midYear + (index - 4);
                  } else {
                    thisYear = midYear;
                  }
                  return ListTile(
                    onTap: () {
                      _currentDateTime =
                          DateTime(thisYear, _currentDateTime.month);
                      _getCalendar();
                      setState(() => _currentView = CalendarViews.months);
                    },
                    title: Text(
                      '$thisYear',
                      style: TextStyle(
                          fontSize: 18,
                          color: (thisYear == _currentDateTime.year)
                              ? kPrimaryColor
                              : Colors.black),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  void getnextdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    next = prefs.getString("nextdate");
    start = prefs.getString("startdate");
    var one;
    var two;
    var three;
    one = DateTime.parse(start).day + 1;
    two = one + 1;
    one = two + 1;
    //print(one+two+three);
    print("sndlljnsdl" + start);
    if (prefs.getString("selecteddate") == null) {
    } else {
      _selectedDateTime = DateTime.parse(prefs.getString("selecteddate"));
    }

    //print(next.toString().substring(8));
  }

  dynamic nextfromserver = new List();
  Future<void> getNotesdate() async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    print(token);
    try {
      final response = await http.post(
        getnotes,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        nextfromserver = responseJson;

        print(nextfromserver);

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
                    countfromserver[i]['note']==null?"":   countfromserver[i]['note'],
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

  dynamic countfromserver = new List();
  Future<void> getnotescount(date) async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
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
        print(countfromserver.length);
        if (countfromserver.length == 0) {
          setState(() {
            value = "[]";
            showToast("No Notes Found!!!");
            //return Text("data");
            print(value + "jbj");
          });
        } else {
          print("object");
        }

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

  Future<void> getnotescountbymonth() async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    print(token);
    try {
      final response = await http.post(notecountbymonth,
          // body: {"date": date.toString().substring(0, 10)},
          headers: {
            'Authorization': 'Bearer $token',
          }, body: {
        "first_day": "2021-06-01",
        "last_day": "2021-06-30"
      });
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        notes = responseJson['data'];
        print("note" + notes.toString());
        // count = responseJson['notes_count'];
        // count = noteslength;
        //  print(count);
        responseJson['data'].forEach((k, v) {
          Calendar calendardate;
          for (int i = 1;
              i <= int.parse(calendardate.date.month.toString());
              i++) {
            var day = k.toString().split('-').last;
            if (int.parse(day) == i) {
              print("data" + day.toString());
            }
          }
          print("k" + k.toString() + "v" + v.toString());
        });
        for (int i = 0; i < listOfDates.length; i++) {
          var usdKey = notes.keys.firstWhere(
            (k) => (notes[k]),
          );
          print("fdssdvfdsfdddfff" + notes[1].toString());
        }

        // print("Notes" + notes.toString().replaceAll("-", "/"));
        for (int j = 0; j < notes.length; j++) {
          print(notes.toString().replaceAll("-", "/")[j]);
          for (int i = 0; i < listOfDates.length; i++) {
            if (listOfDates[i] ==
                notes.keys.toString().replaceAll("-", "/")[j]) {
              print("listOfDates[i]");
              print(listOfDates[i]);
            } else {
              print(notes.keys[i]);
            }
          }
        }

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
}
