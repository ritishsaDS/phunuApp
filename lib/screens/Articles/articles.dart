import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/Api.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/screens/Articles/components/article_card.dart';
import 'components/article_detail.dart';
import 'components/header_bar.dart';
import 'package:http/http.dart'as http;

class ArticleScreen extends StatefulWidget {
  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  bool isLoading = false;

  bool isError;
  @override
  void initState() {
    setUpTimedFetch();
    // TODO: implement initState
    super.initState();
  }
  setUpTimedFetch() {
    Timer.periodic(Duration(milliseconds: 2000), (timer) {
      getArticlesfromserver();
     // print("jnern"+timer.toString());
    });
  }
  bool like = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              HeaderBar(iconData: Icons.close),
              HeightBox(getProportionateScreenHeight(20)),
             Container(
                 height: SizeConfig.screenHeight*0.85,
                 child: ListView(children:createProduct() ,))
              // ArticleCard(),
              // ArticleCard(),
              // ArticleCard(),
            ],
          ),
        ),
      ),
    );
  }

  dynamic articlewithserver = new List();

  Future<void> getArticlesfromserver() async {
    SharedPreferences prefs=await SharedPreferences.getInstance();
   var token= prefs.getString("token");
    try {
      final response = await http.post(GetArticles,
      headers: {
        'Authorization': 'Bearer $token',
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
        child: ArticleCard(
          title: articlewithserver[i]["title"],
          id:articlewithserver[i]['id'],
          image: articlewithserver[i]["image"],
          description: articlewithserver[i]["description"],
          userlikes:articlewithserver[i]["user_likes"],
        )
      ));
    }

    return productList;
  }
}
