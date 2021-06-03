import 'package:flutter/material.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';

class CustomRowModel {
  bool selected;
  String title;
  int id;
  CustomRowModel({this.selected, this.title, this.id});
}

class CustomRow extends StatelessWidget {
  final CustomRowModel model;
  CustomRow(this.model);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(left: 8.0, right: 8.0, top: 3.0, bottom: 3.0),
        child: SizedBox(
            height: getProportionateScreenHeight(40),
            child: Chip(
                backgroundColor: Colors.white,
                shadowColor: kTextColor.withOpacity(0.3),
                elevation: 4.0,
                label: Container(
                  width: getProportionateScreenWidth(260),
                  height: getProportionateScreenHeight(25),
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
// I have used my own CustomText class to customise TextWidget.
                      Text(
                        model.title,
                      ),
                      this.model.selected
                          ? Icon(
                              Icons.radio_button_checked,
                              color: kPrimaryColor,
                            )
                          : Icon(Icons.radio_button_unchecked),
                    ],
                  ),
                ))));
  }
}
