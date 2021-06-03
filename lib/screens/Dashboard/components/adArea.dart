import 'package:flutter/material.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';

class AdArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(75),
      width: SizeConfig.screenWidth,
      color: kSecondaryColor.withOpacity(0.4),
      child: Center(
        child: Text(
          'AD Area',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: getProportionateScreenHeight(18)
          ),
        ),
      ),
    );
  }
}
