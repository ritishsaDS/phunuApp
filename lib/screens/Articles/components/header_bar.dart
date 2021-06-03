import 'package:flutter/material.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';

class HeaderBar extends StatelessWidget {
  final IconData iconData;
  HeaderBar({
    @required this.iconData,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            height: getProportionateScreenHeight(55),
            width: SizeConfig.screenWidth,
            color: kSecondaryColor.withOpacity(0.2),
            child: Center(
              child: Text(
                'Articles',
                style: TextStyle(
                  color: kPrimaryLightColor,
                  fontWeight: FontWeight.w600,
                  fontSize: getProportionateScreenHeight(22),
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
                    iconData,
                    color: kPrimaryLightColor,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
