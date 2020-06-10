import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'global_variable.g.dart';

int allTimeWorkH = 0;

var allTimeWorkM = '0';

ReactionDisposer dispose;
bool firstRun = true;

String hour = '00:00';

int hour23 = 75600100;
int hourTempStart = 0;

Enable isEnable = Enable();
bool isSwitched = false;
int minute = 0;
SharedPreferences prefs;
String startWorkTime = '00:00';
String textButtonWork = 'Start Work';
Timer timer;
bool timerOff = true;

var timeStart = DateTime.now().millisecondsSinceEpoch;

class Constant {
  static const String resetAllTime = 'Удалить статистику';
  static const String settings = 'Настройки';
  static const List<String> choices = <String>[resetAllTime, settings];
}
class Enable = EnableBase with _$Enable;

abstract class EnableBase with Store {
  @observable
  bool isEnable = false;

  @action
  void getFalse() {
    isEnable = false;
  }

  @action
  void getTrue() {
    isEnable = true;
  }
}
