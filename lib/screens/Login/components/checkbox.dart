import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/size_config.dart';

class RememberCheckbox extends StatefulWidget {
  @override
  _RememberCheckboxState createState() => _RememberCheckboxState();
}

class _RememberCheckboxState extends State<RememberCheckbox> {
  bool status = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(12),
        vertical: getProportionateScreenHeight(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          VxTwoRow(
            left: SizedBox(
              height: 28,
              width: 12,
              child: Checkbox(
                onChanged: (value) {
                  setState(() {
                    status = value;
                  });
                },
                value: status,
              ),
            ),
            right: Text("Remember me"),
          ),
          Text("Forgot?"),
        ],
      ),
    );
  }
}
