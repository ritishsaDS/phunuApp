import 'package:flutter/material.dart';

import 'package:vietnamese/screens/signup/components/sign_up_background.dart';
import 'package:vietnamese/screens/signup/components/sign_up_body.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SignUpBackground(),
          SignUpBody(),
        ],
      ),
    );
  }
}
