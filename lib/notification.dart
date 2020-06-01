import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'global_variable.dart';





FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;



void initializeNotification() {
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification);
}

// Здесь же ты не написал selectN, или вообще slktn
Future selectNotification(String payload) {
  debugPrint('payload $payload');
  return null;
}

// И здесь, хотя название shwntf выглдяит отлично
void showNotification() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails('your channel id', 'your channel name', 'your channel description', importance: Importance.Max, priority: Priority.High);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin
      .show(
    0,
    'Может пора отдохнуть?',
    'Время проведенное за работой $hour:$minute',
    platformChannelSpecifics,
    payload: 'Default_Sound',
  )
      .whenComplete(() => checkNotification = false);
}