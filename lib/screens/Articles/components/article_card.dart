import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:vietnamese/common/Api.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/screens/Articles/components/article_detail.dart';
import 'package:vietnamese/screens/Articles/constant/article_constant.dart';

class ArticleCard extends StatefulWidget {
  @override
  _ArticleCardState createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  bool isLoading = false;

  bool isError;
  @override
  void initState() {
    getArticlesfromserver();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight,
      child: ListView(
        children: createProduct(),
      ),
    );
  }

  dynamic articlewithserver = new List();
  Future<void> getArticlesfromserver() async {
    try {
      final response = await http.post(GetArticles);

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        articlewithserver = responseJson['data'] as List;

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
      print("uhdfuhdfuh");
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  List<Widget> createProduct() {
    List<Widget> productList = new List();
    for (int i = 0; i < articlewithserver.length; i++) {
      productList.add(GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(
              title: articlewithserver[i]["title"],
              image: articlewithserver[i]["image"],
              description: articlewithserver[i]["description"],
            ),
          ),
        ),
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        height: getProportionateScreenHeight(120),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: getProportionateScreenHeight(120),
                              width: getProportionateScreenWidth(130),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    articlewithserver[i]["image"],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(110),
                              width: getProportionateScreenWidth(200),
                              child: Text(
                                articlewithserver[i]["title"],
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(15),
                        ),
                        height: getProportionateScreenHeight(25),
                        child: Icon(Icons.thumb_up_alt_rounded,
                            color: kPrimaryColor),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Html(
                          data: articlewithserver[i]["description"],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1.5,
              )
            ],
          ),
        ),
      ));
    }

    return productList;
  }
}
