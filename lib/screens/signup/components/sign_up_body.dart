import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/common/textField.dart';
import 'package:vietnamese/components/logo.dart';
import 'package:vietnamese/components/socialButton.dart';
import 'package:vietnamese/screens/Dashboard/dashboard.dart';
import 'package:vietnamese/screens/Login/login.dart';

class SignUpBody extends StatelessWidget {
  const SignUpBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: getProportionateScreenHeight(10),
            horizontal: getProportionateScreenWidth(15)),
        child: Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 Align(
                   alignment: Alignment.centerLeft,
                  child: Logo() 
                 ),
                  // SizedBox(
                  //   height: getProportionateScreenHeight(60),
                  // ),
                  Text(
                    "SIGN UP",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: getProportionateScreenHeight(22),
                      color: kPrimaryLightColor,
                    ),
                  ),
                  HeightBox(
                    getProportionateScreenHeight(10),
                  ),
                  MyTextField(
                    labelText: "Name",
                  ),
                  MyTextField(
                    labelText: "Username",
                  ),
                  MyTextField(
                    labelText: "Phone",
                  ),
                  MyTextField(
                    labelText: "Email",
                  ),
                  MyTextField(
                    labelText: "PIN",
                  ),
                  MyTextField(
                    labelText: "Confirm PIN",
                  ),
                  HeightBox(
                    getProportionateScreenHeight(25),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashboardScreen()),
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
                        "SIGN UP",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenHeight(18)),
                      ),
                    ),
                  ),
                  HeightBox(
                    getProportionateScreenHeight(10),
                  ),
                  SocialButton(),
                  HeightBox(
                    getProportionateScreenHeight(20),
                  ),
                  VxTwoRow(
                    left: Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: getProportionateScreenHeight(18),
                      ),
                    ),
                    right: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      ),
                      child: Text(
                        'SIGN IN',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: getProportionateScreenHeight(18),
                        ),
                      ),
                    ),
                  ),
                  HeightBox(
                    getProportionateScreenHeight(20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
