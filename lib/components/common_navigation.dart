import 'package:flutter/material.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/screens/Articles/articles.dart';
import 'package:vietnamese/screens/Dashboard/dashboard.dart';
import 'package:vietnamese/screens/calander/calander_screen.dart';
import 'package:vietnamese/screens/notes/notesScreen.dart';
import 'package:vietnamese/screens/settings/settings.dart';

class CommonNavigationBar extends StatefulWidget {
  CommonNavigationBar({
    this.articleActive = false,
    this.calenderActive = false,
    this.notesActive = false,
    this.settingsActive = false,
  });

  final bool notesActive;
  final bool calenderActive;
  final bool articleActive;
  final bool settingsActive;

  @override
  _CommonNavigationBarState createState() => _CommonNavigationBarState();
}

class _CommonNavigationBarState extends State<CommonNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: getProportionateScreenHeight(65),
        width: SizeConfig.screenWidth,
        color: kSecondaryColor.withOpacity(0.4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SingleIcon(
              iconPath: (widget.notesActive)
                  ? 'assets/icons/notes.png'
                  : 'assets/icons/notes_white.png',
              title: 'Notes',
              active: widget?.notesActive,
              onTap: (widget?.notesActive == false)
                  ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotesScreen(),
                        ),
                      )
                  : null,
            ),
            SingleIcon(
              iconPath: (widget.calenderActive)
                  ? 'assets/icons/calender.png'
                  : 'assets/icons/calender_white.png',
              title: 'Calender',
              active: widget?.calenderActive,
              onTap: (widget?.calenderActive == false)
                  ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalanderScreen(),
                        ),
                      )
                  : null,
            ),
            SingleIcon(
              iconPath: 'assets/icons/home_white.png',
              title: 'Home',
              active: false,
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(),
                ),
              ),
            ),
            SingleIcon(
              iconPath: (widget.articleActive)
                  ? 'assets/icons/articles.png'
                  : 'assets/icons/articles_white.png',
              title: 'Articles',
              active: widget?.articleActive,
              onTap: (widget?.articleActive == false)
                  ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ArticleScreen()),
                      )
                  : null,
            ),
            SingleIcon(
              iconPath: (widget.settingsActive)
                  ? 'assets/icons/seetings.png'
                  : 'assets/icons/settings_white.png',
              title: 'Settings',
              active: widget?.settingsActive,
              onTap: (widget?.settingsActive == false)
                  ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingScreen()),
                      )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class SingleIcon extends StatelessWidget {
  SingleIcon(
      {Key key,
      @required this.iconPath,
      @required this.title,
      @required this.active,
      @required this.onTap})
      : super(key: key);
  final String iconPath;
  final String title;
  final bool active;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 20),
              padding: EdgeInsets.all(getProportionateScreenHeight(10)),
              height: getProportionateScreenHeight(40),
              width: getProportionateScreenHeight(40),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(26),
              ),
              child: Image.asset(iconPath),
            ),
            Text(
              title,
              style: TextStyle(
                color: (active) ? kPrimaryColor : Colors.white,
                fontSize: getProportionateScreenHeight(14),
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
