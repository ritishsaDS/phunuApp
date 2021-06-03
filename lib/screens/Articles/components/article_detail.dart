import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/screens/Articles/constant/article_constant.dart';
import 'header_bar.dart';

class ArticleDetailScreen extends StatefulWidget {
  ArticleDetailScreen({this.title, this.image, this.description});
  dynamic title;
  dynamic image;
  dynamic description;
  @override
  _ArticleDetailScreenState createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
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
                          image: NetworkImage(widget.image),
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
                            widget.title,
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
                  data: widget.description,
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
}
