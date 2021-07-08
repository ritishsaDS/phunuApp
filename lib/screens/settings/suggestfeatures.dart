import 'package:flutter/material.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';

class suggestfeatures extends StatefulWidget {
  String title;
  String subject;
  String email;
  suggestfeatures({this.title, this.subject,this.email});
  @override
  _suggestfeaturesState createState() => _suggestfeaturesState();
}

class _suggestfeaturesState extends State<suggestfeatures> {
  String tx_subject;
  String tx_email;
  TextEditingController subject;
  TextEditingController email;
  @override
  void initState() {
    subject = TextEditingController(text: widget.subject);
    email = TextEditingController(text: widget.email);
    // TODO: implement initState
    super.initState();
  }

  // TextEditingController passcontroller;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Container(
                      height: getProportionateScreenHeight(55),
                      width: SizeConfig.screenWidth,
                      color: kSecondaryColor.withOpacity(0.2),
                      child: Center(
                        child: Text(
                          widget.title,
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
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: TextFormField(
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    controller: email,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      isDense: true,
                      
                      focusColor: kPrimaryLightColor,
                      hoverColor: kPrimaryLightColor,
                      hintStyle: TextStyle(color: kTextColor),
                      hintText: "Email",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: kPrimaryColor),
                        gapPadding: 10,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: kPrimaryColor),
                        gapPadding: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: kPrimaryColor),
                        gapPadding: 10,
                      ),
                    )),
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: TextFormField(
                    minLines: 2,
                    maxLines: 5,
                    controller: subject,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      isDense: true,
                      focusColor: kPrimaryLightColor,
                      hoverColor: kPrimaryLightColor,
                      hintStyle: TextStyle(color: kTextColor),
                      hintText: "Subject",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: kPrimaryColor),
                        gapPadding: 10,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: kPrimaryColor),
                        gapPadding: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: kPrimaryColor),
                        gapPadding: 10,
                      ),
                    )),
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: TextFormField(
                    maxLines: 8,
                    keyboardType: TextInputType.multiline,
                    decoration: inputDecoration()),
              ),
              RaisedButton(
                //     disabledColor: Colors.red,
                // disabledTextColor: Colors.black,
                padding: const EdgeInsets.all(10),
                textColor: Colors.white,
                color: kPrimaryColor,
                onPressed: () {
                  showToast("under Development");
                },
                child: Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
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
      hintStyle: TextStyle(color: kTextColor),
      hintText: "Body",
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      border: outlineInputBorder,
    );
  }
}
