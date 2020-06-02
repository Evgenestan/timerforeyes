import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'StreamCreater.dart';
import 'android_alarm_manager.dart';
import 'global_variable.dart';
import 'theme.dart';

// Збс, что стейт - приватный класс (начинается с _)
// Но иногда может быть так, что стейт будет публичным, тогда его внутренности необходимо делать приватными, а публичными оставлять лишь то, что ты явно хочешь оставить доступным снаружи
class MyHomePage extends StatefulWidget {
  @override
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool firstRun = true;
  Timer timer;
  var returnMinuteVar;

  //DateTime time = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('title1'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Время начала работы',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Text(
                        '$startWorkTime',
                        style: TextStyle(
                          fontSize: 100,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Время проведенное в работе',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: StreamBuilder<int>(
                        stream: StreamCreater(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.active:
                              return Text(
                                '$hour',
                                style: TextStyle(
                                  fontSize: 100,
                                ),
                                textAlign: TextAlign.center,
                              );
                            default:
                              return Text(
                                '$hour',
                                style: TextStyle(
                                  fontSize: 100,
                                ),
                                textAlign: TextAlign.center,
                              );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Center(
                  child: RaisedButton(
                      color: buttonBackgroundColor,
                      onPressed: onPressButton,
                      onLongPress: onLongPressButton,
                      child: Text('Start Work')),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }



  void setStartWorkTime() {
    setState(() {
      var tempTime = DateTime.now();
      startWorkTime = DateFormat.Hm().format(tempTime);
    });
  }

  void onLongPressButton() {
    if(timerOff) {
      setState(() {
        startWorkTime = '00:00';
        hour = '00:00';
      });
    } else {
      timerOff = true;
    }
  }

  void onPressButton() {
    print('presed');
    if (timerOff) {
      timeStart = DateTime.now().millisecondsSinceEpoch;
      timerOff = false;

      startAlarm();
      setStartWorkTime();
    }
  }
}
