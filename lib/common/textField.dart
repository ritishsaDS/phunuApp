import 'package:flutter/material.dart';
import 'package:vietnamese/common/constants.dart';

class MyTextField extends StatelessWidget {
  final String labelText;
  MyTextField({@required this.labelText});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            labelText,
            style: TextStyle(color: Colors.black),
          ),
        ),
          Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 24.0,
                spreadRadius: 0.0,
                offset: Offset(6.0, 6.0),
              ),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            cursorColor: kPrimaryLightColor,
          ),
        ),
      ],
    );
  }
}
