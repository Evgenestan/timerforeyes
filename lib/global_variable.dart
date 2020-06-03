import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

int allTimeWorkH = 0;

var allTimeWorkM = '00';
bool firstRun = true;

String hour = '00:00';
int hour23 = 75600100;
int hourTempStart = 0;
int minute = 0;
SharedPreferences prefs;
String startWorkTime = '00:00';
String textButtonWork = 'Start Work';

Timer timer;

bool timerOff = true;
var timeStart = DateTime.now().millisecondsSinceEpoch;
class Constant {
  static const String resetAllTime = 'Удалить статистику';
  static const List<String> choices = <String>[resetAllTime];
}

