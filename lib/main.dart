

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SecondPage.dart';
import 'theme.dart';
import 'notification.dart';
import 'MyHomePage.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  initializeNotification();
  runApp(MaterialApp(home: BottomNavBar(),theme: ThemeData.dark()));
}






class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  int pageIndex = 0;
  static final Key key2 = GlobalKey();
  @override
  void initState() {

    super.initState();
    print('$key2');


  }


  final MyHomePage _home = MyHomePage(key: key2);
  final SecondPage _second = SecondPage();


  Widget _showPage = MyHomePage();
  Widget _pageChooser(int page) {
    switch(page) {
      case 0:
        return _home;
        break;
      case 1:
        return _second;
        break;
      default: return null;
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(

          index: pageIndex,
          height: 50.0,
          items: <Widget>[
            Icon(Icons.add, size: 30),
            Icon(Icons.list, size: 30),

          ],
          color: Colors.grey[700],
          buttonBackgroundColor: buttonBackgroundColor,
          backgroundColor: Colors.grey[850],
          animationCurve: Curves.linearToEaseOut,
          animationDuration: Duration(milliseconds: 400),
          onTap: (int onTapIndex) {
            setState(() {
              _showPage = _pageChooser(onTapIndex);
            });
          },
        ),
        body: Container(
          child: _showPage,
        ));
  }
}



