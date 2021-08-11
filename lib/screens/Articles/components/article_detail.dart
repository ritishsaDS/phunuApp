import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/Api.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/screens/Articles/constant/article_constant.dart';
import 'header_bar.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

class ArticleDetailScreen extends StatefulWidget {
  ArticleDetailScreen({this.title, this.image, this.description,this.id});
  dynamic title;
  dynamic id;
  dynamic image;
  dynamic description;
  @override
  _ArticleDetailScreenState createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  bool isError=false;
  bool isLoading=false;
  @override
  void initState() {
    getarticledetail();

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: isLoading==true?Center(child: CircularProgressIndicator(color: kPrimaryColor,)):Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderBar(iconData: Icons.arrow_back_rounded),
              HeightBox(getProportionateScreenHeight(20)),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: getProportionateScreenHeight(120),
                      width: getProportionateScreenWidth(130),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(articlewithserver['image']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    WidthBox(20),
                    SizedBox(
                      height: getProportionateScreenHeight(120),
                      width: getProportionateScreenWidth(200),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            articlewithserver['title'],
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(12),
                  vertical: getProportionateScreenHeight(20),
                ),
                child: Html(
                  data:  articlewithserver['description'],
                  // softWrap: true,
                  // overflow: TextOverflow.clip,
                  // style: TextStyle(
                  //   color: Colors.black,
                  //   fontWeight: FontWeight.w500,
                  // ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  dynamic articlewithserver = new List();

  Future<void> getarticledetail() async {
setState(() {
  isLoading=true;
});
    try {
      final response = await http.post(articledetail,
          body: {
            'id': widget.id.toString(),
          });

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        articlewithserver = responseJson['data'] ;
//print(articlewithserver[0]['user_likes']);
        setState(() {
          isError = false;
          isLoading = false;
          print('setstate'+articlewithserver.toString());
        });
      } else {
        print("bjkb" + response.statusCode.toString());

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

}
