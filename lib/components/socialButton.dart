import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vietnamese/common/size_config.dart';

class SocialButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(10),
            vertical: getProportionateScreenHeight(10)),
        child: Column(
          children: [
            Text(
              'Sign in with google',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            HeightBox(
              getProportionateScreenHeight(10),
            ),
            SizedBox(
              height: getProportionateScreenHeight(60),
              width: getProportionateScreenWidth(160),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(60),
                    width: getProportionateScreenWidth(60),
                    child: Card(
                      child: Center(
                        child: Image.network(
                          "https://cdn2.hubspot.net/hubfs/53/image8-2.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(60),
                    width: getProportionateScreenWidth(60),
                    child: Card(
                      child: Center(
                        child: FaIcon(FontAwesomeIcons.facebookF,
                            color: Color(0xff4267B2)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
