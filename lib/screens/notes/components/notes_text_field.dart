import 'package:flutter/material.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';

class NotesTextField extends StatefulWidget {
  NotesTextField({@required this.hintText, this.getvlaue, this.onChangedValue});
  final hintText;
  Function getvlaue;
  var onChangedValue;

  @override
  _NotesTextFieldState createState() => _NotesTextFieldState();
}

class _NotesTextFieldState extends State<NotesTextField> {
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
      hintStyle: TextStyle(
        color: kTextColor,
      ),
      hintText: widget.hintText,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 10),
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
        child: TextField(
          decoration: inputDecoration(),
          onChanged: (value) {
            setState(() {
              widget.onChangedValue = value;
            });
          },
        ),
      ),
    );
  }
}
