import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/components/common_button.dart';

class CycleLenghtAlert extends StatefulWidget {
  @override
  _CycleLenghtAlertState createState() => _CycleLenghtAlertState();
}

class _CycleLenghtAlertState extends State<CycleLenghtAlert> {
  int text = 28;

  final TextStyle title = TextStyle(
    fontSize: getProportionateScreenHeight(18),
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  bool average = false;
  bool irregularcycle = false;
  final TextStyle subTitle = TextStyle(
    fontSize: getProportionateScreenHeight(16),
    color: kPrimaryColor,
  );
  @override
  void initState() {
    // TODO: implement initState
    getswitchvlue();
    super.initState();
  }

  final TextStyle date =
      TextStyle(fontSize: getProportionateScreenHeight(12), color: kTextColor);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(context),
              buildTitle(),
              Divider(),
              buildButton(context)
            ],
          ),
        ),
      ),
    );
  }

  buildHeader(context) {
    return Container(
      height: getProportionateScreenHeight(45),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        color: kPrimaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Cycle Length',
            style: title,
          ),
          IconButton(
              icon: Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: getProportionateScreenHeight(20),
              ),
              onPressed: () => Navigator.of(context).pop())
        ],
      ),
    );
  }

  buildTitle() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(25),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: getProportionateScreenHeight(100),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  shape: const CircleBorder(),
                  color: kPrimaryColor,
                  height: getProportionateScreenHeight(5),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setState(() {
                      if (text == 5) {
                      } else {
                        text = text - 1;
                        print(text);
                      }
                    });
                  },
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: getProportionateScreenWidth(70),
                  height: getProportionateScreenHeight(50),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kPrimaryColor)),
                  child: Column(
                    children: [
                      Text(
                        text.toString(),
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: getProportionateScreenHeight(22),
                        ),
                      ),
                      Text(
                        'Days',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: getProportionateScreenHeight(12),
                        ),
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  shape: const CircleBorder(),
                  color: kPrimaryColor,
                  height: getProportionateScreenHeight(5),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setState(() {
                      if (text == 40) {
                      } else {
                        text = text + 1;
                        print(text);
                      }
                      print(text);
                    });
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'We use this cycle length to predict your next period start date.',
          ),
        ],
      ),
    );
  }

  buildButton(context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
            ),
            width: SizeConfig.screenWidth,
            height: getProportionateScreenHeight(40),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Use Average",
                  style: TextStyle(color: kPrimaryColor),
                ),
                Center(
                  child: Switch(
                    value: average,
                    inactiveThumbColor: kPrimaryLightColor,
                    onChanged: (val) async {
                      setState(() {
                        average = val;

                        print(average);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
            ),
            width: SizeConfig.screenWidth,
            height: getProportionateScreenHeight(40),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Irregular Cycle",
                  style: TextStyle(color: kPrimaryColor),
                ),
                Center(
                  child: Switch(
                    value: irregularcycle,
                    inactiveThumbColor: kPrimaryLightColor,
                    onChanged: (val) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      setState(() {
                        irregularcycle = val;

                        print(irregularcycle);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          HeightBox(getProportionateScreenHeight(20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CommonButton(
                title: 'Cancel',
                onTap: () => Navigator.of(context).pop(text.toString()),
              ),
              CommonButton(
                  title: 'Confirm',
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool("irregularcycle", irregularcycle);
                    prefs.setBool("average", average);
                    Navigator.of(context).pop(text.toString());
                  }),
            ],
          ),
          HeightBox(getProportionateScreenHeight(20))
        ],
      ),
    );
  }

  Future<void> getswitchvlue() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getBool("average") == null&& preferences.getBool("irregularcycle")) {
      average = false;
      print("dsklm");
    } else {
      print("dssaasklm");

     setState(() {
        average = preferences.getBool("average");
      irregularcycle = preferences.getBool("irregularcycle");
     });
    }
  }
}

class RowSwitch extends StatefulWidget {
  final String title;
  bool status;
  RowSwitch({@required this.title, @required this.status});

  @override
  _RowSwitchState createState() => _RowSwitchState();
}

class _RowSwitchState extends State<RowSwitch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
      ),
      width: SizeConfig.screenWidth,
      height: getProportionateScreenHeight(40),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: TextStyle(color: kPrimaryColor),
          ),
          Center(
            child: Switch(
              value: widget.status,
              inactiveThumbColor: kPrimaryLightColor,
              onChanged: (val) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                setState(() {
                  widget.status = val;
                  print(widget.status);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
