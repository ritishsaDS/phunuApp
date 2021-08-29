import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/Api.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/components/logo.dart';
import 'package:vietnamese/screens/Login/login.dart';
import 'package:vietnamese/screens/notes/notesScreen.dart';

class SignUpBody extends StatefulWidget {
  SignUpBody({
    Key key,
  }) : super(key: key);

  @override
  _SignUpBodyState createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  String usernameString = '';
  String passwordString = '';
  String confirmpassword = '';
  String name = '';
  String phone = '';
  String email = '';
  bool isLoading = false;
  GoogleSignInAccount _userObj;
  //GoogleSignInAccount _userObj;
  bool isLoggedIn = false;
  var profileData;
  Map userfb = {};

  GoogleSignIn _googleSignIn = GoogleSignIn();

  final signInKey = GlobalKey<FormState>();
  //TextEditingController email = TextEditingController();
  bool isError;
  TextEditingController pincontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(
            // vertical: getProportionateScreenHeight(10),
            10),
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
                  Align(alignment: Alignment.centerLeft, child: Logo()),
                  // SizedBox(
                  //   height: getProportionateScreenHeight(60),
                  // ),
                  Text(
                    "ĐĂNG KÝ",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: getProportionateScreenHeight(22),
                      color: kPrimaryLightColor,
                    ),
                  ),
                  HeightBox(
                    getProportionateScreenHeight(10),
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
                            "Tên tài khoản",
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
                                return "Username cannot be empty";
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Tên",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            enabled: isLoading ? false : true,
                            onChanged: (text) {
                              name = text;
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
                            keyboardType: TextInputType.name,
                            cursorColor: kPrimaryLightColor,
                            validator: (val) {
                              if (val.length == 0) {
                                return "Name cannot be empty";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Điện thoại",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            enabled: isLoading ? false : true,
                            onChanged: (text) {
                              phone = text;
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
                                return "Phone cannot be empty";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "E-mail",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            enabled: isLoading ? false : true,
                            onChanged: (text) {
                              email = text;
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
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: kPrimaryLightColor,
                            validator: (val) {
                              if (val.length == 0) {
                                return "Email cannot be empty";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "GHIM",
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Xác nhận mã PIN",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            enabled: isLoading ? false : true,
                            onChanged: (text) {
                              confirmpassword = text;
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
                                return "Confirm Password cannot be empty";
                              } else if (val != passwordString) {
                                return " Password Cant same";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // MyTextField(
                  //   labelText: "Name",
                  // ),
                  // MyTextField(
                  //   labelText: "Username",
                  // ),
                  // MyTextField(
                  //   labelText: "Phone",
                  // ),
                  // MyTextField(
                  //   labelText: "Email",
                  // ),
                  // MyTextField(
                  //   labelText: "PIN",
                  // ),
                  // MyTextField(
                  //   labelText: "Confirm PIN",
                  // ),
                  HeightBox(
                    getProportionateScreenHeight(25),
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
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            )
                          : Text(
                              "ĐĂNG KÝ",
                              style: TextStyle(color: Colors.white),
                            ),
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

                  HeightBox(
                    getProportionateScreenHeight(20),
                  ),
                  VxTwoRow(
                    left: Text(
                      'Bạn co săn san để tạo một tai khoản?',
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
                        'ĐĂNG NHẬP',
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

  dynamic loginwithserver = new List();

  signin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString("device_id");
    print("osnanl" + usernameString);
    bool isvalid = EmailValidator.validate(usernameString);
    if (signInKey.currentState.validate()) {
      signInKey.currentState.save();
      setState(() {
        isLoading = true;
      });

      if (!_validateEmail(email)) {
        showToast("Phụ Nữ Việt Says .....Địa chỉ email");
        setState(() {
          isLoading = false;
        });
      } else if (passwordString.length != 4) {
        showToast("Phụ Nữ Việt Says .....Số PIN");
      } else {
        try {
          final response = await http.post(regsiter, body: {
            "user_name": usernameString,
            "name": name,
            "pin": passwordString,
            "mobile_number": phone,
            "email": email,
            "device_id": prefs.getString("deviceid")
            // "password": passwordString,
          });
          print("bjkb" + response.statusCode.toString());
          if (response.statusCode == 200) {
            final responseJson = json.decode(response.body);

            loginwithserver = responseJson;
            // print(loginwithserver['data']['email']);
            print(loginwithserver);
if(loginwithserver["error"]!=null){
  showToast(loginwithserver["error"]);
}
else{

showToast("Registered Succesfully");
savedata();
}


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
    prefs.setString("user_type", loginwithserver['data']['user_type']);
    //prefs.setString('email', emailController.text);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => NotesScreen()));
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

  googlelogin() {
    _googleSignIn.signIn().then((userData) {
      setState(() async {
         SharedPreferences prefs = await SharedPreferences.getInstance();
      //  _isLoggedIn = true;
        _userObj = userData;

        if (_userObj.displayName != null) {
          try {
            final response = await http.post(regsiter, body: {
              "user_name": _userObj.displayName.toString(),
            "name":_userObj.displayName.toString(),
            "pin": "1235",
           
            "email":  _userObj.email.toString(),
            "device_id": prefs.getString("deviceid")
             
            });
            print("bjkb" + response.statusCode.toString());
            if (response.statusCode == 200) {
              final responseJson = json.decode(response.body);

              loginwithserver = responseJson;
              print(loginwithserver);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => PinField(
              //             email: _userObj.email,
              //             message: loginwithserver['message'])));
              // showToast("");
               savedata();
              setState(() {
                isError = false;
                isLoading = false;
                print('setstate');
              });
            } else {
              print("bjkb" + response.statusCode.toString());
              // showToast("Mismatch Credentials");
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
