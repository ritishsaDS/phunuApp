import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/Api.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';

class DashboardDate extends StatefulWidget {
  @override
  _DashboardDateState createState() => _DashboardDateState();
}

class _DashboardDateState extends State<DashboardDate> {
  String token;
  bool isError;
  bool isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          BodyContent(
            title: 'Next Period Date',
            date: "",
          ),
          HeightBox(getProportionateScreenHeight(10)),
          BodyContent(
            title: 'Fertile Window Starts',
            date: '21/11',
          ),
        ],
      ),
    );
  }

 }

class BodyContent extends StatelessWidget {
  const BodyContent({Key key, @required this.title, @required this.date})
      : super(key: key);

  final String title;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(15),
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
                  title,
                  style: TextStyle(
                      color: kPrimaryColor, fontWeight: FontWeight.w600),
                ),
                Text(
                  date,
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
