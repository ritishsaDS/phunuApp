import 'package:flutter/material.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/screens/Dashboard/dashboard.dart';

class CommonAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DashboardScreen()));
        },
        child: Container(
          height: getProportionateScreenHeight(55),
          width: SizeConfig.screenWidth,
          color: kSecondaryColor.withOpacity(0.4),
          child: Center(
            child: Text(
              'Phụ Nữ Việt',
              style: TextStyle(
                  color: kPrimaryLightColor,
                  fontWeight: FontWeight.w700,
                  fontSize: getProportionateScreenHeight(18)),
            ),
          ),
        ),
      ),
    );
  }
}
