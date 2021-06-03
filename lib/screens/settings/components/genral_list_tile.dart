import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';

class GenralListTile extends StatelessWidget {
  GenralListTile(
      {@required this.title,
      @required this.onTap,
      this.tileType,
      this.subtitle});

  final String title;
  final Function onTap;
  final TileType tileType;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    Widget _widget;

    switch (tileType) {
      case TileType.subtext:
        _widget = Text("\t\t\t\t" + subtitle);
        break;
      default:
        _widget = Container();
    }

    return GestureDetector(
      onTap: onTap,
      child: Padding(
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
              VxTwoRow(
                left: Text(
                  title,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                right: _widget,
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: kPrimaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum TileType { subtext }
