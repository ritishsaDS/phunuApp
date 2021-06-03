import 'package:flutter/material.dart';
import 'package:vietnamese/common/size_config.dart';

class SignUpBackground extends StatelessWidget {
  const SignUpBackground({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login/login-bg.png"),
          fit: BoxFit.fill,
          alignment: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
