import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timerforeyes/auth.dart';
import 'package:timerforeyes/auth_firebase.dart';

import 'MyHomePage.dart';
import 'SecondPage.dart';
import 'global_variable.dart';
import 'notification.dart';
import 'theme.dart';

void main() async {
  dispose = reaction((_) => isEnable.isEnable, (msg) => reCreate(msg));

  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  initializeNotification();
  await createNotificationChannel();
  prefs = await SharedPreferences.getInstance();
  await setTheme();
  await checkWeek();
  await resumeWork();
  await checkAuth().whenComplete(() {
    startApp();
  });
}

void startApp(){
  if(isAuth) {
    runApp(MaterialApp(home: BottomNavBar()));
  } else {
    runApp(MaterialApp(home: AuthPage()));
  }
}

Future<void> checkAuth() async {
  Firebase_User = await getCurrentUser();
  if(Firebase_User != null) {
    isAuth = true;
    iconAuth = iconAuthTrue;
  } else {
    isAuth = false;
    iconAuth = iconAuthFalse;
  }
  print('isAuth = $isAuth user = $Firebase_User');


}

void checkWeek() async {
  DateTime dateOld;
  var day = DateTime.now().weekday;
  var dateNow = DateTime.now();
  var datePref = prefs.getInt('dateOld');
  datePref == null? dateOld = DateTime.fromMillisecondsSinceEpoch(0) : dateOld = DateTime.fromMillisecondsSinceEpoch(datePref);
  if(day == 1 && (dateNow.day > dateOld.day || dateNow.month > dateOld.month || dateNow.year > dateOld.year)){
    await prefs.setInt('dateOld', DateTime.now().millisecondsSinceEpoch);
    await prefs.setInt('timeAll', 0);
  }
  print('date if $dateNow');
}

void reCreate(var value) {
  print('reCreate');

  runApp(MaterialApp(home: BottomNavBar()));
}

void resumeWork() async {
  var tempTime = await prefs.getInt('timeStart');
  if (tempTime != null && tempTime != 0) {
    timeStart = tempTime;
    timerOff = false;
  }
  //runApp(MaterialApp(home: BottomNavBar()));

}

void setTheme() async {
  var localTheme = await prefs.getString('theme');
  if (localTheme == 'dark') {
    isSwitched = true;
    isEnable.getTrue();
    bottomNavBarColor = bottomNavBarColorDark;
    backgroundColorNavBar = backgroundColorDarkNavBar;
    buttonBackgroundColor = buttonBackgroundColorDark;
    appBarColor = appBarColorDark;
    backgroundColor = backgroundColorDark;
    colorText = colorTextDark;
    iconColor = iconColorDark;
  } else {
    bottomNavBarColor = bottomNavBarColorLight;
    backgroundColorNavBar = backgroundColorLightNavBar;
    buttonBackgroundColor = buttonBackgroundColorLight;
    appBarColor = appBarColorLight;
    backgroundColor = backgroundColorLight;
    colorText = colorTextLight;
    iconColor = iconColorLight;
  }
}

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int pageIndex = 0;

  final SecondPage _second = SecondPage();
  Widget _showPage = MyHomePage();

  MyHomePage get _home => MyHomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        bottomNavigationBar: CurvedNavigationBar(
          index: pageIndex,
          height: 50.0,
          items: <Widget>[
            Icon(Icons.add, size: 30, color: iconColor),
            Icon(Icons.list, size: 30, color: iconColor),
          ],
          color: bottomNavBarColor,
          buttonBackgroundColor: bottomNavBarColor,
          backgroundColor: backgroundColorNavBar,
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

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return _home;
        break;
      case 1:
        return _second;
        break;
      default:
        return null;
    }
  }
}
