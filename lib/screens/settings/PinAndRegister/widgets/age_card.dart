import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';

import '../../../../common/constants.dart';
import '../../../../common/constants.dart';

class AgeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.1),
              blurRadius: 16.0,
              spreadRadius: 5.0,
              offset: Offset(0, 0),
            )
          ],
        ),
        child: CardBody(),
      ),
    );
  }
}

class CardBody extends StatefulWidget {
  @override
  _CardBodyState createState() => _CardBodyState();
}

class _CardBodyState extends State<CardBody> {
  int selected = 0;
  int _radioValue = 0;
  String age;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      print(age);
      switch (_radioValue) {
        case 0:
          age = "Under 18";
          break;
        case 1:
          age = " 18-25";
          break;
        case 2:
          age = "25-30";
          break;
        case 3:
          age = "30-40";
          break;
        case 4:
          age = "40=45";
          break;
        case 5:
          age = "50-55";
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: getProportionateScreenHeight(150),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
        vertical: getProportionateScreenHeight(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Age range*',
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.w600,
              fontSize: getProportionateScreenHeight(16),
            ),
          ),
          HeightBox(
            getProportionateScreenHeight(10),
          ),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.spaceBetween,
            runSpacing: getProportionateScreenHeight(5),
            spacing: getProportionateScreenWidth(70),
            children: [
              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  height: getProportionateScreenHeight(23),
                  width: getProportionateScreenWidth(23),
                  child: new Radio(
                    value: 0,
                    groupValue: _radioValue,
                    focusColor: (kPrimaryColor),
                    onChanged: _handleRadioValueChange,
                  ),
                ),
                new Text(
                  'Under 18',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ]),
              Container(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    height: getProportionateScreenHeight(23),
                    width: getProportionateScreenWidth(23),
                    child: new Radio(
                      value: 1,
                      groupValue: _radioValue,
                      focusColor: (kPrimaryColor),
                      onChanged: _handleRadioValueChange,
                    ),
                  ),
                  new Text('18 - 25',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )),
                ]),
              ),
              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  height: getProportionateScreenHeight(23),
                  width: getProportionateScreenWidth(23),
                  child: new Radio(
                    value: 2,
                    groupValue: _radioValue,
                    focusColor: (kPrimaryColor),
                    onChanged: _handleRadioValueChange,
                  ),
                ),
                new Text(
                  '26 - 35',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ]),
              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  height: getProportionateScreenHeight(23),
                  width: getProportionateScreenWidth(23),
                  child: new Radio(
                    value: 3,
                    groupValue: _radioValue,
                    focusColor: (kPrimaryColor),
                    onChanged: _handleRadioValueChange,
                  ),
                ),
                new Text(
                  '35 - 45',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ]),
              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  height: getProportionateScreenHeight(23),
                  width: getProportionateScreenWidth(23),
                  child: new Radio(
                    value: 4,
                    groupValue: _radioValue,
                    focusColor: (kPrimaryColor),
                    onChanged: _handleRadioValueChange,
                  ),
                ),
                new Text(
                  '46 - 55',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ]),
              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  height: getProportionateScreenHeight(23),
                  width: getProportionateScreenWidth(23),
                  child: new Radio(
                    value: 5,
                    focusColor: (kPrimaryColor),
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                ),
                new Text(
                  '55 +     ',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ]),

              // PinCheckBox(lable: 'Under 18', value: 1),
              // PinCheckBox(lable: '18 - 25', value: 2),
              // PinCheckBox(lable: '26 - 35', value: 3),
              // PinCheckBox(lable: '35 - 45', value: 4),
              // PinCheckBox(lable: '46 - 55', value: 5),
              // PinCheckBox(lable: '55 +     ', value: 6),
            ],
          ),
        ],
      ),
    );
  }
}

class PinCheckBox extends StatefulWidget {
  final String lable;
  final int value;
  PinCheckBox({@required this.lable, @required this.value});
  @override
  _PinCheckBoxState createState() => _PinCheckBoxState();
}

class _PinCheckBoxState extends State<PinCheckBox> {
  int selected = 0;

  String radioItemHolder = 'Under 18';
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            height: getProportionateScreenHeight(23),
            width: getProportionateScreenWidth(23),
            child: Radio(
              groupValue: selected,
              focusColor: (kPrimaryColor),
              value: widget.value,
              onChanged: (val) {
                setState(() {
                  selected = 0;
                  //sradioItemHolder = widget.lable;
                  selected = widget.value;
                });
              },
            )),
        WidthBox(getProportionateScreenWidth(10)),
        Text(
          widget.lable,
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }

  setSelected(int val) {
    print(selected);
    setState(() {
      if (selected != 0) {
        print("if");
      } else {
        print("else");

        selected = val;
      }

      print(selected);
    });
  }
}
