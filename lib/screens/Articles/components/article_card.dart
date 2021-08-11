import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vietnamese/common/Api.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/screens/Articles/components/article_detail.dart';
import 'package:vietnamese/screens/Articles/constant/article_constant.dart';

class ArticleCard extends StatefulWidget {
  String title;
  String description;
dynamic userlikes;
  String image;
  var id ;
  ArticleCard({this.title,this.description,this.id,this.image,this.userlikes});
  @override
  _ArticleCardState createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  bool isLoading = false;

  bool isError;
  @override
  void initState() {
    getstatus();
    //print(widget.userlikes);
   // getArticlesfromserver();
    // TODO: implement initState
    super.initState();
  }

  bool like = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight,
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(
              title: widget.title,
              id:widget.id,
              image: widget.image,
              description:widget.description,
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
                                   widget.image,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(110),
                              width: getProportionateScreenWidth(200),
                              child: Text(
                               widget.title,
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
                      GestureDetector(
                        onTap: () {
                          print("like");
                          setState(() {
                            if(like==true){
                              like=false;
                            }else{
                              like=true;
                            }
                          });
                          setState(() => like = !like);
                          likeapihit();
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(15),
                            vertical: 10
                          ),
                          height: getProportionateScreenHeight(25),
                          child: GestureDetector(
                            onTap: () {
                              print("like");
                              setState(() {
                                // if(widget.userlikes==null){
                                //   like=false;
                                // }else{
                                //   like=true;
                                // }
                              });
                              setState(() => like = !like);
                              likeapihit();
                            },
                            child: Container(
                              //padding: EdgeInsets.symmetric(horizontal: 20),
                              child: GestureDetector(
                                onTap: () {
                                  print("like");
                                  setState(() {
                                    if(like){
                                      like=false;
                                    }
                                    else{
                                      like=true;
                                    }
                                    // if(widget.userlikes==null){
                                    //   like=false;
                                    // }else{
                                    //   like=true;
                                    // }
                                  });
                                  setState(() => like = !like);
                                 likeapihit();
                                },
                                child: Icon(
                                  like ? Icons.thumb_up_alt_rounded: Icons.thumb_up_off_alt_outlined
                                  ,
                                  color: Colors.pink,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Html(
                          data: widget.description,
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
      )
    );
  }

  dynamic articlewithserver = new List();
  Future<void> likeapihit() async {
     SharedPreferences prefs= await SharedPreferences.getInstance();
     var token=prefs.getString("token");
     print(widget.id);
    try {
      final response = await http.post(articlelike,
          headers: {
            'Authorization': 'Bearer $token',
          },body: {"article_id":widget.id.toString()});

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        articlewithserver = responseJson;
print(articlewithserver);
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
      print("uhdfuhdfuh"+e.toString());
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  void getstatus() {
    print("jbwerjn;n");
   setState(() {
     if(widget.userlikes==null){
       setState(() {
         like=false;
       });
     }else{
       like=true;
     }
   });
  }



}
