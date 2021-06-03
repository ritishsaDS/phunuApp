import 'package:flutter/material.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/screens/Dashboard/dashboard.dart';

class ButtonRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Login with OTP",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: getProportionateScreenHeight(18),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardScreen()),
            ),
            child: Container(
              height: getProportionateScreenHeight(50),
              width: getProportionateScreenWidth(120),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: kPrimaryLightColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12.0,
                    spreadRadius: 1.0,
                    offset: Offset(6.0, 6.0),
                  ),
                ],
              ),
              child: Text(
                "SIGN IN",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: getProportionateScreenHeight(18)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
