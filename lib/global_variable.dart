import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'global_variable.g.dart';

int allTimeWorkH = 0;
int allTimeWorkM = 0;

String allTimeWorkAtDay = '00:00';


final FirebaseAuth firebase = FirebaseAuth.instance;

bool isAuth;
FirebaseUser Firebase_User;



ReactionDisposer dispose;
bool firstRun = true;

String hour = '00:00';

//int hour23 = 75600100;
DateTime hourTempStart;

Enable isEnable = Enable();
bool isSwitched = false;
Duration minute;
SharedPreferences prefs;
String startWorkTime = '00:00';
String textButtonWork = 'Start Work';
Timer timer;
bool timerOff = true;

var timeStart = DateTime.now();

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
