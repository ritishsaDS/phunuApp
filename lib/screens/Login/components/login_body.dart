import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/Api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/common/textField.dart';
import 'package:vietnamese/components/socialButton.dart';
import 'package:vietnamese/screens/Dashboard/dashboard.dart';
import 'package:vietnamese/screens/Login/components/checkbox.dart';
import 'package:vietnamese/screens/Login/components/pinfield.dart';
import 'package:vietnamese/screens/signup/signUp.dart';

import 'buttonRow.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({
    Key key,
  }) : super(key: key);

  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  String usernameString = '';
  String passwordString = '';
  bool isLoading = false;
  bool _isLoggedIn = false;
  GoogleSignInAccount _userObj;
  bool isLoggedIn = false;
  var profileData;
  Map userfb = {};
  var facebookLogin = FacebookLogin();

  GoogleSignIn _googleSignIn = GoogleSignIn();

  final signInKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  bool isError;
  TextEditingController pincontroller = TextEditingController();
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    pincontroller.dispose();
    focusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

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
          decoration: BoxDecoration(
              //color: Colors.pinkAccent,
              ),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(130),
                  ),
                  Text(
                    "SIGN IN",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: getProportionateScreenHeight(22),
                      color: kPrimaryLightColor,
                    ),
                  ),
                  HeightBox(
                    getProportionateScreenHeight(20),
                  ),
                  Form(
                    key: signInKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Username",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            enabled: isLoading ? false : true,
                            onChanged: (text) {
                              usernameString = text;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            cursorColor: kPrimaryLightColor,
                            validator: (val) {
                              if (val.length == 0) {
                                return "Email cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.emailAddress,
                            style: new TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        HeightBox(
                          getProportionateScreenHeight(20),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "PIN",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            enabled: isLoading ? false : true,
                            onChanged: (text) {
                              passwordString = text;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            cursorColor: kPrimaryLightColor,
                            validator: (val) {
                              if (val.length == 0) {
                                return "Password cannot be empty";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  HeightBox(
                    getProportionateScreenHeight(20),
                  ),
                  HeightBox(
                    getProportionateScreenHeight(10),
                  ),
                  RememberCheckbox(),
                  HeightBox(
                    getProportionateScreenHeight(10),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(10)),
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
                          onTap: () {
                            signin();
                          },
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
                            child: isLoading
                                ? CircularProgressIndicator(
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                  )
                                : Text(
                                    "SIGNIN",
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                  HeightBox(
                    getProportionateScreenHeight(10),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(10),
                          vertical: getProportionateScreenHeight(10)),
                      child: Column(
                        children: [
                          Text(
                            'Sign in with google',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          HeightBox(
                            getProportionateScreenHeight(10),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(60),
                            width: getProportionateScreenWidth(160),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  child: SizedBox(
                                    height: getProportionateScreenHeight(60),
                                    width: getProportionateScreenWidth(60),
                                    child: Card(
                                      child: Center(
                                        child: Image.network(
                                          "https://cdn2.hubspot.net/hubfs/53/image8-2.jpg",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    googlelogin();
                                  },
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(60),
                                  width: getProportionateScreenWidth(60),
                                  child: Card(
                                    child: Center(
                                      child: FaIcon(FontAwesomeIcons.facebookF,
                                          color: Color(0xff4267B2)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),

                  // SocialButton(),
                  HeightBox(
                    getProportionateScreenHeight(20),
                  ),
                  // VxTwoRow(
                  //   left: Text(
                  //     'Don\'t have an account?',
                  //     style: TextStyle(
                  //       color: Colors.black,
                  //       fontWeight: FontWeight.w400,
                  //       fontSize: getProportionateScreenHeight(18),
                  //     ),
                  //   ),
                  //   right: GestureDetector(
                  //     onTap: () => Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => SignUpScreen(),
                  //       ),
                  //     ),
                  //     child: Text(
                  //       'SIGN UP',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: getProportionateScreenHeight(18),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  dynamic loginwithserver = new List();
  signin() async {
    print("osnanl" + usernameString);
    bool isvalid = EmailValidator.validate(usernameString);
    if (signInKey.currentState.validate()) {
      signInKey.currentState.save();
      setState(() {
        isLoading = true;
      });

      if (!_validateEmail(usernameString)) {
        showToast("Phụ Nữ Việt Says .....Địa chỉ email");
        setState(() {
          isLoading = false;
        });
      } else {
        try {
          final response = await http.post(login, body: {
            "email": usernameString,
            "password": passwordString,
          });
          print("bjkb" + response.statusCode.toString());
          if (response.statusCode == 200) {
            final responseJson = json.decode(response.body);

            loginwithserver = responseJson;
            // print(loginwithserver['data']['email']);
            print(loginwithserver);

            // showToast("");
            savedata();
            setState(() {
              isError = false;
              isLoading = false;
              print('setstate');
            });
          } else {
            print("bjkb" + response.statusCode.toString());
            showToast("Mismatch Credentials");
            setState(() {
              isError = true;
              isLoading = false;
            });
          }
        } catch (e) {
          print(e);
          setState(() {
            isError = true;
            isLoading = false;
          });
        }
      }
    }
  }

  Future<void> savedata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("email", loginwithserver['data']['email']);
    //prefs.setInt("password", loginwithserver['data']['password']);
    prefs.setString("token", loginwithserver['access_token']);
     prefs.setString("user_type", loginwithserver['data']['user_type']);
    //prefs.setString('email', emailController.text);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => DashboardScreen()));
  }

  bool _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }

  // fblogin() {
  //   FacebookAuth.instance
  //       .login(permissions: ["public_profile", "email"]).then((value) {
  //     FacebookAuth.instance.getUserData().then((userDatas) {
  //       setState(() {
  //         userfb = userDatas;
  //         if (userDatas != null) {
  //           print(userDatas['email']);
  //           if (userDatas['email'] == null) {
  //             showDialog(
  //                 context: context,
  //                 builder: (BuildContext context) {
  //                   return AlertDialog(
  //                     title: Text("Math App Says-\nAuthentication Failed "),
  //                     content: Container(
  //                       height: 100,
  //                       child: Column(
  //                         children: [
  //                           ElevatedButton(
  //                               onPressed: () {},
  //                               child: Text("SignUP Manually"))
  //                         ],
  //                       ),
  //                     ),
  //                   );
  //                 });
  //           } else {}
  //           //
  //         }

  //         print(userDatas);
  //       });
  //     });
  //   });
  // }

  googlelogin() {
    _googleSignIn.signIn().then((userData) {
      setState(() async {
        _isLoggedIn = true;
        _userObj = userData;
        print(_userObj.displayName);
        if (_userObj.displayName != null) {
          try {
            final response = await http.post(checklogin, body: {
              "email": _userObj.email,
              // "password": "1234",
            });
            print("bjkb" + response.statusCode.toString());
            if (response.statusCode == 200) {
              final responseJson = json.decode(response.body);

              loginwithserver = responseJson;
              print(loginwithserver);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PinField(
                          email: _userObj.email,
                          message: loginwithserver['message'])));
              // showToast("");
              // savedata();
              setState(() {
                isError = false;
                isLoading = false;
                print('setstate');
              });
            } else {
              print("bjkb" + response.statusCode.toString());
              showToast("Mismatch Credentials");
              setState(() {
                isError = true;
                isLoading = false;
              });
            }
          } catch (e) {
            print(e);
            setState(() {
              isError = true;
              isLoading = false;
            });
          }
          // signup(_userObj.displayName, _userObj.email,
          //     "google");
        }
      });
    }).catchError((e) {
      print(e);
    });
  }
}
