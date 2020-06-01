import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



import 'android_alarm_manager.dart';
import 'notification.dart';
import 'global_variable.dart';

class SecondPage extends StatefulWidget {

  @override
  _SecondPageState createState() => _SecondPageState();
}

// Збс, что стейт - приватный класс (начинается с _)
// Но иногда может быть так, что стейт будет публичным, тогда его внутренности необходимо делать приватными, а публичными оставлять лишь то, что ты явно хочешь оставить доступным снаружи
class _SecondPageState extends State<SecondPage> {
  Timer timer;

  //DateTime time = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        
        title: Text('title2'),
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
                      'Страница 2',
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
                        '',
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
                      '',
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
                        '',
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
          Container(
            child: Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Center(
                  child: RaisedButton(
                      color: Colors.grey[500],

                      onPressed: () async { onPressButton(); },
                      // Аналогично
                      onLongPress: () { onLongPressButton(); },
                      child: Text('Start Work')),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // camelCase! -> startWork
  // The callback for our alarm

  void onPressButton() {


    print('presed');
    if (timer == null) {
      startAlarm();
      callbackAlarm();
    }


  }
  void onLongPressButton() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    } else {
      setState(() {
        minute = 0;
        hour = 0;
        print('obnulai $minute');
      });
    }
  }

  void callbackAlarm() {
    setState(() {
      minuteStart = DateTime.now().minute;
      hourStart = DateTime.now().hour;
    });

    timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      setState(() {
        minute = DateTime.now().minute - minuteStart;

        if (minute < 0) {
          minute = minute + 60;
        }
      });
      if (minute >= 0 && minute < 15 && checkNotification == true) {
        showNotification();
        hour++;
      }
      if (minute > 15 && minute < 29) {
        checkNotification = true;
      }
      if (minute >= 30 && minute < 45 && checkNotification == true) {
        showNotification();
      }
      if (minute > 45 && minute < 59) {
        checkNotification = true;
      }
    });
  }
}