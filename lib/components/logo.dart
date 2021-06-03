import 'package:flutter/material.dart';
import 'package:vietnamese/common/constants.dart';

import 'package:vietnamese/common/size_config.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: getProportionateScreenWidth(60),
        width: getProportionateScreenWidth(60),
        alignment: Alignment.center,
        // decoration: BoxDecoration(
        //     borderRadius:
        //         BorderRadius.circular(getProportionateScreenWidth(30)),
        //     border: Border.all(color: kPrimaryColor)),
        child: Image.asset(
          "assets/icons/home_white.png",
        ));
  }
}
