import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/screens/Articles/components/article_card.dart';
import 'components/header_bar.dart';

class ArticleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              HeaderBar(iconData: Icons.close),
              HeightBox(getProportionateScreenHeight(20)),
              ArticleCard(),
              // ArticleCard(),
              // ArticleCard(),
              // ArticleCard(),
            ],
          ),
        ),
      ),
    );
  }
}
