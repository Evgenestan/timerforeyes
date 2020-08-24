import 'dart:async';

import 'global_variable.dart';



Stream<Duration> StreamCreater() {
  StreamController<Duration> controller;

  Timer timer;


  void startTimer() {
    controller.sink.add(minute);
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (timerOff) {

      } else {
        print('ReturnMinute');


        minute = DateTime.now().difference(timeStart);
        print('$minute');

        hour = '${minute.inHours} : ${minute.inMinutes - minute.inHours * 60}';
        print('$hour');



        //DateTime.now().minute - minuteStart;
        controller.sink.add(minute);
      }


    });
  }

  void stopTimer() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
  }

  controller = StreamController<Duration>(
      onListen: startTimer,
      onPause: stopTimer,
      onResume: startTimer,
      onCancel: stopTimer);

  return controller.stream;
}