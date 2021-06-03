import 'dart:convert';

import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    getnextdate();
    getNotesdate();
    final date = DateTime.now();
    _currentDateTime = DateTime(date.year, date.month);
    _selectedDateTime = DateTime(date.year, date.month, date.day);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() => _getCalendar());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
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
            Container(
              height: getProportionateScreenHeight(250),
              child: ListView(
                children: notesdatewidget(),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> notesdatewidget() {
    List<Widget> productList = new List();
    for (int i = 0; i < nextfromserver.length; i++) {
      productList.add(Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
        ),
        child: Container(
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
                  nextfromserver[i]['date'].toString().replaceAll("-", "/"),
                  style: _textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  nextfromserver[i]['note'],
                  style: _textStyle,
                ),
              ],
            )),
      ));
    }
    return productList;
  }

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
        onTap: () {
          if (_selectedDateTime != calendarDate.date) {
            if (calendarDate.nextMonth) {
              _getNextMonth();
            } else if (calendarDate.prevMonth) {
              _getPrevMonth();
            }
            setState(() => _selectedDateTime = calendarDate.date);
            print(DateTime.parse(next));
          }
        },
        child: calendarDate.date.day != DateTime.parse(next).day
            ? Center(
                child: Text(
                '${calendarDate.date.day}',
                style: TextStyle(
                  color: (calendarDate.thisMonth)
                      ? (calendarDate.date.weekday == DateTime.sunday)
                          ? Colors.black
                          : Colors.black
                      : (calendarDate.date.weekday == DateTime.sunday)
                          ? Colors.black.withOpacity(0.5)
                          : Colors.black.withOpacity(0.5),
                ),
              ))
            : calendarDate.date.month < DateTime.parse(next).month ||
                    calendarDate.date.month > DateTime.parse(next).month
                ? Container(
                    child: Center(
                      child: Text(
                        "${DateTime.parse(next).day}",
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: kPrimaryColor,
                      ),
                    ),
                    child: Center(
                      child: Text("${DateTime.parse(next).day}",
                          style: TextStyle(color: Colors.white)),
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
          child: Center(
              child: Text(
            '${calendarDate.date.day.toString()}',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          )),
        ),
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
          child: Text(
            "${calendarDate.next.toString().substring(8)}",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
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

        nextfromserver = responseJson['data'];

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
}
