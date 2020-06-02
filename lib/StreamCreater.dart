import 'dart:async';


import 'package:intl/intl.dart';

import 'global_variable.dart';



Stream<int> StreamCreater() {
  StreamController<int> controller;

  Timer timer;


  void startTimer() {
    controller.sink.add(minute);
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (timerOff) {

      } else {
        print('ReturnMinute');


        minute = (DateTime.now().millisecondsSinceEpoch - timeStart) + hour23;
        print('$minute');
        var tempTime = DateTime.fromMillisecondsSinceEpoch(minute);
        hour = DateFormat.Hm().format(tempTime);
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

  controller = StreamController<int>(
      onListen: startTimer,
      onPause: stopTimer,
      onResume: startTimer,
      onCancel: stopTimer);

  return controller.stream;
}