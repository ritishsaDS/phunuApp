import 'package:flutter/material.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/screens/notes/components/notes_text_field.dart';

class TwoTextField extends StatefulWidget {
  String height;
  String weight;
  TwoTextField({this.height, this.weight});
  @override
  _TwoTextFieldState createState() => _TwoTextFieldState();
}

class _TwoTextFieldState extends State<TwoTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: getProportionateScreenHeight(60),
      child: Row(
        children: [
          SizedBox(
            height: getProportionateScreenHeight(60),
            width: SizeConfig.screenWidth * 0.5,
            child: NotesTextField(
              hintText: "Weight",
              onChangedValue: widget.weight,
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(60),
            width: SizeConfig.screenWidth * 0.5,
            child: NotesTextField(
              hintText: "Height",
              getvlaue: () {
                setState(() {
                  print(widget.height);
                });
              },
              onChangedValue: widget.height,
            ),
          ),
        ],
      ),
    );
  }
}
