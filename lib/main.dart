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

// Названия в camelCase - chkNotification (и вообще лучше выбирать сокращения понятнее, а то и не сокращать вовсе, тут ты сэкономил 2 символа в названии переменной, но зачем?)
bool chknotification = true;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
int hour = -1;
int hourStart = 0;
int hourTempStart = 0;

int minute = 0;
int minuteStart = 0;

// Если у тебя возникает желание написать такой комментарий - значит ты считаешь, что может быть не очень понятно из кода, ЧТО он делает - и это повод написать код понятнее и не писать комментарий
///////////////////////////////////////////////////<Notification>///////////////////////////////////////////////////
// Тоже самое - мне приходится понимать из кода, что эта функция инициализирует нотификации, но можно было и назвать ее сразу initial(ize)Notifications
void initialN() {
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification);
}

// Здесь же ты не написал selectN, или вообще slktn
Future selectNotification(String payload) {
  debugPrint('payload $payload');
  return null;
}

// И здесь, хотя название shwntf выглдяит отлично
void showNotification() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails('your channel id', 'your channel name', 'your channel description', importance: Importance.Max, priority: Priority.High);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

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

// Вместо этого комментария и предыдущего стоило вынести эти функции в отдельный файл/класс
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

// В будущем не стоит совмещать в одном файле несколько классов-виджетов, как тут у тебя - MyApp, MyHomePage
// Их можно писать в одном файле, только если они очень связанны (если бы ты решил разбить один неделимый виджет на два поменьше и попроще)
class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// Збс, что стейт - приватный класс (начинается с _)
// Но иногда может быть так, что стейт будет публичным, тогда его внутренности необходимо делать приватными, а публичными оставлять лишь то, что ты явно хочешь оставить доступным снаружи
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
                      // Лучше выносить подобные функции отдельно, как ты вынес clockIn и startwork (кстати - camelCase: startWork!)
                      // Например: onPressed: _yourPressureHandler
                      // Допустимо писать так, как написал ты,, если ты в функции используешь замыкания, вроде onPressed: (someParam) => _yourPressureHandler(someParam, anotherParamFromClosure)
                      onPressed: () async {
                        print('presed');
                        if (timer == null) {
                          clockIn();
                          startwork();
                        }
                      },
                      // Аналогично
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

  // camelCase! -> startWork
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
