import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'global_variable.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> cancelNotification() async {
  await flutterLocalNotificationsPlugin.cancel(0);
}

// Здесь же ты не написал selectN, или вообще slktn
Future<void> createNotificationChannel() async {
  var androidNotificationChannel = AndroidNotificationChannel(
    '1',
    'Main',
    'These notifications are required for the application to work.',
    importance: Importance.High,

  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);
}

// И здесь, хотя название shwntf выглдяит отлично
void initializeNotification() {
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);
}

Future selectNotification(String payload) {
  debugPrint('payload $payload');
  return null;
}

Future<void> showIndeterminateProgressNotification() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '1', 'name', 'description',
      channelShowBadge: false,
      importance: Importance.Max,
      priority: Priority.High,
      onlyAlertOnce: true,
      showProgress: true,
      indeterminate: true);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0,
      'indeterminate progress notification title',
      'indeterminate progress notification body',
      platformChannelSpecifics,
      payload: 'item x');
}

void showNotification() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '1', 'name', 'description',
      enableVibration: true,
      ongoing: true,
      onlyAlertOnce: false,
      importance: Importance.High,
      priority: Priority.High);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.periodicallyShow(1, 'Время в работе',
      '$hour', RepeatInterval.EveryMinute, platformChannelSpecifics);
}

Future<void> showRepeatNotification() async {
  var androidPlatformChannelSpecifics =
      AndroidNotificationDetails('1', 'name', 'description', importance: Importance.High,
        priority: Priority.High,
        onlyAlertOnce: false);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      'Может пора отдохнуть?',
      'Уже прошел час и твоим глазам требуется отдых',
      RepeatInterval.Hourly,
      platformChannelSpecifics);
}
