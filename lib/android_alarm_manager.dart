import 'package:android_alarm_manager/android_alarm_manager.dart';

// Мне не понятно, что делает эта функция, исходя из ее названия clockIn?
void startAlarm() async {
  //Do Stuff
  print('trigger');
  AlarmHelper.scheduleAlarm();
}

class AlarmHelper {
  static final int _REQUEST_CODE = 12377;

  static void scheduleAlarm() async {
    print('schedule');

    await AndroidAlarmManager.cancel(_REQUEST_CODE);
    await AndroidAlarmManager.oneShot(Duration(seconds: 5), _REQUEST_CODE, startAlarm, exact: true, wakeup: true);
  }
}
