import 'dart:async';

var timeStart = DateTime.now().millisecondsSinceEpoch;

bool checkNotification = true;

bool firstRun = true;

String hour = '00:00';
int hour23 = 75600100;
int hourTempStart = 0;

int minute = 0;

String startWorkTime = '00:00';
Timer timer;
bool timerOff = true;
//int pageIndex = 0;
