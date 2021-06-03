import 'package:flutter/material.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';

class CommonAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: getProportionateScreenHeight(55),
        width: SizeConfig.screenWidth,
        color: kSecondaryColor.withOpacity(0.4),
        child: Center(
          child: Text(
            'Vietnamese Women',
            style: TextStyle(
              color: kPrimaryLightColor,
              fontWeight: FontWeight.w700,
              fontSize: getProportionateScreenHeight(18)
            ),
          ),
        ),
      ),
    );
  }
}
