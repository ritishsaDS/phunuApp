import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';

class CalanderMessage extends StatefulWidget {
  @override
  _CalanderMessageState createState() => _CalanderMessageState();
}

class _CalanderMessageState extends State<CalanderMessage> {
  final TextStyle _textStyle = TextStyle(color: kPrimaryLightColor);
  var next;
  @override
  void initState() {
    getnextdate();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
      ),
      child: Container(
          height: getProportionateScreenHeight(100),
          width: SizeConfig.screenWidth,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: kPrimaryColor),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${next.toString().replaceAll("-", "/")}",
                style: _textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Period started Rather little flow Took med",
                style: _textStyle,
              ),
              Text(
                "Happy he said I\'m beautiful",
                style: _textStyle,
              ),
            ],
          )),
    );
  }

  void getnextdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      next = prefs.getString("nextdate");
    });

    print(next.toString().replaceAll("-", "/"));
  }
}
