import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'global_variable.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

// Збс, что стейт - приватный класс (начинается с _)
// Но иногда может быть так, что стейт будет публичным, тогда его внутренности необходимо делать приватными, а публичными оставлять лишь то, что ты явно хочешь оставить доступным снаружи
class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Статистика'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiseAction,
            itemBuilder: (BuildContext contex) {
              return Constant.choices.map((String choise) {
                return PopupMenuItem<String>(
                  value: choise,
                  child: Text(choise),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: FittedBox(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Общее время работы',
                  textScaleFactor: 2,
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                children: <Widget>[
                  Text(
                    '$allTimeWorkH',
                    textScaleFactor: 6,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '  hour',
                    textScaleFactor: 6,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    '$allTimeWorkM',
                    textScaleFactor: 6,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    ' min  ',
                    textScaleFactor: 6,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void choiseAction(String choice) async {
    if (choice == Constant.resetAllTime) {
      await prefs.setInt('timeAll', 0);
      setAllTimeWork();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setAllTimeWork();
  }

  void setAllTimeWork() async {
    var tempTimeAll = await prefs.getInt('timeAll');
    print('tempTimeAll second screen $tempTimeAll');
    if (tempTimeAll != null) {
      tempTimeAll = tempTimeAll + hour23;
      var tempDateTime = DateTime.fromMillisecondsSinceEpoch(tempTimeAll);

      var tempHour = DateFormat.d().format(tempDateTime);
      allTimeWorkH = int.parse(tempHour);

      setState(() {
        allTimeWorkH = (allTimeWorkH - 2) * 24 +
            int.parse(DateFormat.H().format(tempDateTime));
        allTimeWorkM = DateFormat.m().format(tempDateTime);
        print('allTimeWork $tempDateTime');
      });
    }
  }

// camelCase! -> startWork
// The callback for our alarm
}
