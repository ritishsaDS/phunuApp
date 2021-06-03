import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';

class TwoItemContainer extends StatelessWidget {
  TwoItemContainer({@required this.title, @required this.itemType});

  final String title;
  final ItemType itemType;

  @override
  Widget build(BuildContext context) {
    Widget _widget;

    switch (itemType) {
      case ItemType.icon:
        _widget = Icon(
          Icons.arrow_forward_ios_rounded,
          color: kPrimaryColor,
        );
        break;
      case ItemType.checkbox:
        _widget = MyCheckBox();
        break;
      case ItemType.rating:
        _widget = MyRatingBar();
        break;
      default:
        _widget = Icon(
          Icons.arrow_forward_ios_rounded,
          color: kPrimaryColor,
        );
    }

    return Padding(
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
              title,
              style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            _widget
          ],
        ),
      ),
    );
  }
}

enum ItemType { icon, rating, checkbox }

class MyCheckBox extends StatefulWidget {
  @override
  _MyCheckBoxState createState() => _MyCheckBoxState();
}

class _MyCheckBoxState extends State<MyCheckBox> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(23),
      width: getProportionateScreenWidth(23),
      //  decoration: BoxDecoration(
      //     border: Border.all(color: kPrimaryColor),
      //     borderRadius: BorderRadius.circular(4)),
      child: Checkbox(
         focusColor: (kPrimaryColor),
        value: value,
        onChanged: (currentValue) {
          setState(
            () {
              value = currentValue;
            },
          );
        },
      ),
    );
  }
}

class MyRatingBar extends StatefulWidget {
  @override
  _MyRatingBarState createState() => _MyRatingBarState();
}

class _MyRatingBarState extends State<MyRatingBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: getProportionateScreenHeight(40),
      child: RatingBar.builder(
        initialRating: 4,
        minRating: 0,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemSize: getProportionateScreenHeight(22),
        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
        itemBuilder: (context, _) => Icon(
          Icons.star_rounded,
          color: kPrimaryColor,
        ),
        onRatingUpdate: (rating) {
          print(rating);
        },
      ),
    );
  }
}
