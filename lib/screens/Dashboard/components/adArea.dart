import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vietnamese/common/Api.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

class AdArea extends StatefulWidget {
  @override
  _AdAreaState createState() => _AdAreaState();
}

class _AdAreaState extends State<AdArea> {
  bool isLoading = false;
  bool  isError=false;
  @override
  void initState() {
    getAdsfromserver();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(75),
      width: SizeConfig.screenWidth,
      color: kSecondaryColor.withOpacity(0.4),
      child:isLoading==true?Container(width:50,child: CircularProgressIndicator(color: kPrimaryColor,)): Center(
        child: GestureDetector(
          onTap: (){
            if(adslist['data']['url']!=null){
              _launchURL();
            }
          },
          child: Image.network(
            adslist['data']['image'],fit: BoxFit.fitWidth,width: SizeConfig.screenWidth-40,
          ),
        ),
      ),
    );
  }
  dynamic adslist= new List();
  Future<void>getAdsfromserver() async {
    setState(() {
      isLoading=true;
    });
    try {
      final response = await http.get(advertisement,
      );
      //print("bjkb" + response.statusCode.toString());
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        adslist = responseJson;
        // print(loginwithserver['data']['email']);
        print(adslist);
        // loginasguest(deviceid);
        // showToast("");
        // savedata(deviceid);
        // gettoken();
        // getalert();
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
  _launchURL() async {
    var url= adslist['data']['url'] ;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
