import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';




import 'global_variable.dart';
import 'theme.dart';


class MyHomePage extends StatefulWidget {

  MyHomePage({Key key}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// Збс, что стейт - приватный класс (начинается с _)
// Но иногда может быть так, что стейт будет публичным, тогда его внутренности необходимо делать приватными, а публичными оставлять лишь то, что ты явно хочешь оставить доступным снаружи
class _MyHomePageState extends State<MyHomePage> {
  bool firstRun = true;
  Timer timer;

  //DateTime time = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
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
                      color: buttonBackgroundColor,

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
      //startAlarm();
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
    var timeStart = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      minuteStart = DateTime.now().minute;
      hourStart = DateTime.now().hour;
      print('${minuteStart/1000}');
    });

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      print('Before setState');
      setState(() {
        print('setState');

        var timenow = ((DateTime.now().millisecondsSinceEpoch - timeStart)/(1000*60));

        minute = timenow.toInt();//DateTime.now().minute - minuteStart;


    });
  });
    }
}