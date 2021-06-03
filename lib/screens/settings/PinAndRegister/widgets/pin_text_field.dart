import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';

class PinTextField extends StatefulWidget {
  PinTextField({
    @required this.hintText,
    this.getText,
    @required this.suggestionText,
  });
  final hintText;
  final getText;
  final suggestionText;
  @override
  _PinTextFieldState createState() => _PinTextFieldState();
}

class _PinTextFieldState extends State<PinTextField> {
  TextEditingController textEditingController;
  String text;

  String email;

  int pin;
  
  @override
  void initState() {
    print(widget.getText);
     getuserdetail();
    textEditingController = TextEditingController(text: email);

    super.initState();
  }

  InputDecoration inputDecoration() {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: kPrimaryColor),
      gapPadding: 10,
    );
    return InputDecoration(
      fillColor: Colors.white,
      filled: true,
      isDense: true,
      focusColor: kPrimaryLightColor,
      hoverColor: kPrimaryLightColor,
      hintStyle: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
      hintText: widget.hintText,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      border: outlineInputBorder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: getProportionateScreenWidth(10),
        right: getProportionateScreenWidth(10),
        bottom: getProportionateScreenHeight(10),
      ),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: inputDecoration(),
              controller: textEditingController,
            ),
            Text(
              '\t\t\t\t\t\t' + widget.suggestionText,
              style: TextStyle(
                fontSize: getProportionateScreenHeight(10),
              ),
            )
          ],
        ),
      ),
    );
  }
   void getuserdetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      email = prefs.getString("email");
      pin = prefs.getInt("password");
    });
  }
}
