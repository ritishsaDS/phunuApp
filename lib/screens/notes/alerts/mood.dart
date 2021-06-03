import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/components/common_button.dart';

class MoodAlert extends StatelessWidget {
  final TextStyle title = TextStyle(
    fontSize: getProportionateScreenHeight(18),
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );
  
  final TextStyle subTitle = TextStyle(
    fontSize: getProportionateScreenHeight(16),
    color: kPrimaryColor,
  );
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
        height: SizeConfig.screenHeight * 0.8,
        //padding: EdgeInsets.all(getProportionateScreenHeight(10)),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),

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
            'I Feel...',
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
      height: getProportionateScreenHeight(540),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(25),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HeightBox(getProportionateScreenHeight(10)),
            SearchBar(),
            MoodRaidoTile(
              title: "Well",
              status: false,
            ),
            MoodRaidoTile(
              title: "Neutral",
              status: true,
            ),
            MoodRaidoTile(
              title: "Slight Bad",
              status: false,
            ),
            MoodRaidoTile(
              title: "Angry",
              status: false,
            ),
            MoodRaidoTile(
              title: "Bad",
              status: false,
            ),
            MoodRaidoTile(
              title: "Worried",
              status: true,
            ),
            MoodRaidoTile(
              title: "Well",
              status: false,
            ),
            MoodRaidoTile(
              title: "Neutral",
              status: true,
            ),
            MoodRaidoTile(
              title: "Slight Bad",
              status: false,
            ),
            MoodRaidoTile(
              title: "Angry",
              status: false,
            ),
            MoodRaidoTile(
              title: "Bad",
              status: false,
            ),
            MoodRaidoTile(
              title: "Worried",
              status: true,
            ),
            HeightBox(getProportionateScreenHeight(10)),
          ],
        ),
      ),
    );
  }

  buildButton(context) {
    return Container(
      height: getProportionateScreenHeight(40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CommonButton(
            title: 'Cancel',
            onTap: () => Navigator.of(context).pop(),
          ),
          CommonButton(
            title: 'Confirm',
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  InputDecoration inputDecoration() {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(26),
      borderSide: BorderSide(color: kPrimaryColor),
      gapPadding: 10,
    );
    return InputDecoration(
        fillColor: Colors.white,
        filled: true,
        isDense: true,
        focusColor: kPrimaryLightColor,
        hoverColor: kPrimaryLightColor,
        hintStyle: TextStyle(color: kTextColor),
        hintText: 'Search',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 42,
        ),
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        border: outlineInputBorder,
        suffixIcon: Icon(
          Icons.search_rounded,
          size: getProportionateScreenHeight(18),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            bottom: getProportionateScreenHeight(5),
            right: getProportionateScreenWidth(5),
            left: getProportionateScreenWidth(5)),
        child: Container(
          height: getProportionateScreenHeight(40),
          child: TextField(
            decoration: inputDecoration(),
          ),
        ),
      ),
    );
  }
}

class MoodRaidoTile extends StatefulWidget {
  final String title;
  bool status;
  MoodRaidoTile({@required this.title, @required this.status});

  @override
  _MoodRaidoTileState createState() => _MoodRaidoTileState();
}

class _MoodRaidoTileState extends State<MoodRaidoTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(5),
      ),
      child: SizedBox(
        height: getProportionateScreenHeight(40),
        child: Chip(
          backgroundColor: Colors.white,
          shadowColor: kTextColor.withOpacity(0.3),
          elevation: 4.0,
          label: Container(
            width: getProportionateScreenWidth(260),
            height: getProportionateScreenHeight(25),
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: getProportionateScreenHeight(16),
                  ),
                ),
                Radio(
                    value: 0,
                    groupValue: (widget.status == false) ? 1 : 0,
                    focusColor: kPrimaryColor,
                    toggleable: true,
                    activeColor: kPrimaryColor,
                    autofocus: true,
                     hoverColor: (kPrimaryColor),
                    onChanged: (currentVal) {
                      setState(() {
                        widget.status = currentVal;
                      });
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
