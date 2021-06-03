import 'package:flutter/material.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/components/bottom.dart';
import 'package:vietnamese/components/common_navigation.dart';
import 'package:vietnamese/screens/calander/components/calanderSceeenWidget.dart';
import 'package:vietnamese/screens/calander/components/calander_message.dart';

class CalanderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            BottomTabs(1, true),
            SizedBox(
              height: MediaQuery.of(context).size.height - 90,
              child: CalanderScreenWidget(),
            ),
            //   CalanderMessage(),
          ],
        ),
      ),
    );
  }
}
