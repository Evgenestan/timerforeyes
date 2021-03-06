import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timerforeyes/auth.dart';
import 'package:timerforeyes/notification.dart';

import 'StreamCreater.dart';
import 'android_alarm_manager.dart';
import 'global_variable.dart';
import 'theme.dart';
import 'user_page.dart';

// Збс, что стейт - приватный класс (начинается с _)
// Но иногда может быть так, что стейт будет публичным, тогда его внутренности необходимо делать приватными, а публичными оставлять лишь то, что ты явно хочешь оставить доступным снаружи
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool firstRun = true;
  Timer timer;
  var returnMinuteVar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text('Главная', style: TextStyle(color: colorText)),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              iconAuth,
              color: iconColor,
            ),
            onPressed: goToAuth,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: FittedBox(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('Время начала работы',
                        textScaleFactor: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colorText)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1),
                    child: Text('$startWorkTime',
                        textScaleFactor: 8,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colorText)),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: FittedBox(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(1),
                    child: Text('Время в работе',
                        textScaleFactor: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colorText)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1),
                    child: StreamBuilder<Duration>(
                      stream: StreamCreater(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.active:
                            return Text('$hour',
                                textScaleFactor: 8,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: colorText));
                          default:
                            return Text('$hour',
                                textScaleFactor: 8,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: colorText));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: RaisedButton(
                      color: buttonBackgroundColor,
                      onPressed: onPressButton,
                      onLongPress: onLongPressButton,
                      child: Text('$textButtonWork',
                          style: TextStyle(color: colorText))),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void goToAuth() {
    if (isAuth) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserPage()),
      ).whenComplete(() {
        setState(() {
          iconAuth;
        });
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AuthPage()),
      ).whenComplete(() {
        setState(() {
          iconAuth;
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (timerOff == false) {
      startAlarm();
      setState(() {
        startWorkTime = DateFormat.Hm().format(timeStart);
        textButtonWork = 'Stop Work';
      });
    }
  }

  void onLongPressButton() async {
    timerOff = true;

      var tempTime0 = await DateTime.fromMillisecondsSinceEpoch(prefs.getInt('timeStart'));

      var tempDuration = DateTime.now().difference(tempTime0);
      var tempDurationAtDay = tempDuration;

      var intTempTimeAll = await prefs.getInt('timeAll');
      var intTempTimeAllAtDay = await prefs.getInt('timeAllAtDay');

      if (intTempTimeAll != null) {
        var tempTimeAll = await Duration(milliseconds: (prefs.getInt('timeAll')) );
        tempDuration = tempDuration + tempTimeAll;
      }
      if(intTempTimeAllAtDay != null){
        var tempTimeAllAtDay = await Duration(milliseconds: (prefs.getInt('timeAllAtDay')) );
        tempDurationAtDay = tempDurationAtDay +  tempTimeAllAtDay;
      }

      await prefs.setInt('timeAllAtDay', tempDurationAtDay.inMilliseconds);

      await prefs.setInt('timeAll', tempDuration.inMilliseconds);

      await prefs.setInt('timeStart', 0);
      await cancelNotification();
      await setState(() {
        startWorkTime = '00:00';
        hour = '00:00';
        textButtonWork = 'Start Work';
      });

  }

  void onPressButton() {
    print('presed');
    if (timerOff) {
      showRepeatNotification();
      timeStart = DateTime.now();
      timerOff = false;
      startAlarm();
      setStartWorkTime();
      setState(() {
        textButtonWork = 'Stop Work';
      });
    }
  }

  void setStartWorkTime() async {
    setState(() {
      var tempTime = DateTime.now();
      startWorkTime = DateFormat.Hm().format(tempTime);
    });
    await prefs.setInt('timeStart', DateTime.now().millisecondsSinceEpoch);
  }
}
