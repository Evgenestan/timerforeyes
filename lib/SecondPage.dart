import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timerforeyes/settings.dart';
import 'package:timerforeyes/theme.dart';
import 'settings.dart';

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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text('Статистика', style: TextStyle(color: colorText)),
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: iconColor),
            color: backgroundColor,
            onSelected: choiceAction,
            itemBuilder: (BuildContext contex) {
              return Constant.choices.map((String choise) {
                return PopupMenuItem<String>(
                  value: choise,
                  child: Text(choise, style: TextStyle(color: colorText),),
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
                    style: TextStyle(color: colorText)
                ),
              ),
              Row(
                children: <Widget>[
                  Text(
                    '$allTimeWorkH',
                    textScaleFactor: 6,
                    textAlign: TextAlign.center,
                      style: TextStyle(color: colorText)
                  ),
                  Text(
                    '  hour',
                    textScaleFactor: 6,
                    textAlign: TextAlign.center,
                      style: TextStyle(color: colorText)
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    '$allTimeWorkM',
                    textScaleFactor: 6,
                    textAlign: TextAlign.center,
                      style: TextStyle(color: colorText)
                  ),
                  Text(
                    ' min  ',
                    textScaleFactor: 6,
                    textAlign: TextAlign.center,
                      style: TextStyle(color: colorText)
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                    'Время работы за сегодня',
                    textScaleFactor: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colorText)
                ),
              ),
              Row(
                children: <Widget>[
                  Text(
                      '$allTimeWorkAtDay',
                      textScaleFactor: 6,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colorText)
                  ),

                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  void choiceAction(String choice) async {
    if (choice == Constant.resetAllTime) {
      await prefs.setInt('timeAll', 0);
      await prefs.setInt('timeAllAtDay', 0);
      setAllTimeWork();
    }
    if(choice == Constant.settings) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsPage()),
      ).whenComplete(() {
        setState(() {
          bottomNavBarColor;
          backgroundColorNavBar;
          buttonBackgroundColor;
          appBarColor;
          backgroundColor;
          colorText;
          iconColor;
        });
      });
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
    if (tempTimeAll != null) {
      var tempDateTime = Duration(milliseconds: tempTimeAll);
      print('Day = $allTimeWorkH');
      setState(() {
        allTimeWorkH = tempDateTime.inHours + tempDateTime.inDays * 24;
        allTimeWorkM = tempDateTime.inMinutes - tempDateTime.inHours * 60;
      });
    }
    tempTimeAll = await prefs.getInt('timeAllAtDay');
    if (tempTimeAll != null){

      setState(() {
        var tempDateTime = Duration(milliseconds: tempTimeAll);
        allTimeWorkAtDay = '${tempDateTime.inHours} : ${tempDateTime.inMinutes - tempDateTime.inHours * 60}';
      });

    }

  }

// camelCase! -> startWork
// The callback for our alarm
}
