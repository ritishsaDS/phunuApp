import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/Api.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/screens/Articles/constant/article_constant.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  final TextStyle _headline =
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold);

  final TextStyle _content = TextStyle(
    color: Colors.black,
  );
  bool isLoading = false;

  bool isError;
  @override
  void initState() {
    getprivacypolicy();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrivacyHeaderBar(),
                HeightBox(
                  getProportionateScreenHeight(30),
                ),
                Text(
                  'Privacy Policy',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: getProportionateScreenHeight(18),
                  ),
                ),
                HeightBox(
                  getProportionateScreenHeight(10),
                ),
                Stack(
                  children: [
                    Container(
                      height: SizeConfig.screenHeight -
                          getProportionateScreenHeight(80),
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView(
                              children: getprivacy(),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  dynamic privacyfromserver = new List();
  Future<void> getprivacypolicy() async {
    isLoading = true;
    try {
      final response = await http.post(getpolicies);
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        privacyfromserver = responseJson['data'];
        print(privacyfromserver['description']);
        setState(() {
          isError = false;
          isLoading = false;
          print('setstate');
        });
      } else {
        print("bjkb" + response.statusCode.toString());

        setState(() {
          isError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print("uhdfuhdfuh" + e);
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  List<Widget> getprivacy() {
    List<Widget> productList = new List();
    for (int i = 0; i <= privacyfromserver.length; i++) {
      productList.add(GestureDetector(
        onTap: () {},
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Html(
                    data: privacyfromserver["description"],
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    }

    return productList;
  }
}

class PrivacyHeaderBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: getProportionateScreenHeight(55),
          width: SizeConfig.screenWidth,
          color: kSecondaryColor.withOpacity(0.2),
          child: Center(
            child: Text(
              'Privacy Policy',
              style: TextStyle(
                color: kPrimaryLightColor,
                fontWeight: FontWeight.w600,
                fontSize: getProportionateScreenHeight(20),
              ),
            ),
          ),
        ),
        Positioned(
          left: 10,
          child: SizedBox(
            height: getProportionateScreenHeight(55),
            child: Center(
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: kPrimaryLightColor,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
