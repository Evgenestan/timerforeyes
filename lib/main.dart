import 'dart:async';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'android_alarm_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  initialN();
  runApp(MyApp());
}

bool chknotification = true;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
int hour = -1;
int hourStart = 0;
int hourTempStart = 0;

int minute = 0;
int minuteStart = 0;

///////////////////////////////////////////////////<Notification>///////////////////////////////////////////////////
void initialN() {
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);
}

Future selectNotification(String payload) {
  debugPrint('payload $payload');
  return null;
}

void showNotification() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max, priority: Priority.High);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin
      .show(
        0,
        'Может пора отдохнуть?',
        'Время проведенное за работой $hour:$minute',
        platformChannelSpecifics,
        payload: 'Default_Sound',
      )
      .whenComplete(() => chknotification = false);
}

///////////////////////////////////////////////////</Notification>///////////////////////////////////////////////////

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Title1',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'title2'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer timer;

  //DateTime time = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                        '$hourStart:$minuteStart',
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
                      child: Text(
                        '$hour:$minute',
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
                      onPressed: () async {
                        print('presed');
                        if (timer == null) {
                          clockIn();
                          startwork();
                        }
                      },
                      onLongPress: () {
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
                      },
                      child: Text('Start Work')),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // The callback for our alarm
  void startwork() {
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
      if (minute >= 0 && minute < 15 && chknotification == true) {
        showNotification();
        hour++;
      }
      if (minute > 15 && minute < 29) {
        chknotification = true;
      }
      if (minute >= 30 && minute < 45 && chknotification == true) {
        showNotification();
      }
      if (minute > 45 && minute < 59) {
        chknotification = true;
      }
    });
  }
}
