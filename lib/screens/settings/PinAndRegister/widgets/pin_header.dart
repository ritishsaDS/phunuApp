import 'package:flutter/material.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';

class PinHeaderBar extends StatelessWidget {
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
                'PIN And Register',
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
    );
  }
}
