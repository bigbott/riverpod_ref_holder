import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_ref_holder/ref_holder.dart';
import 'package:workmanager/workmanager.dart';

//  Workmanager  input data:
const _uniqueName = 'whatevername_1';
const _taskName = 'whatevername_2';
Duration? _frequency; // = Duration(minutes: 15); // cannot  be  less

_calculateFrequency() {
  // some logic here, db connection etc.
  return const Duration(minutes: 15);
}

// Notifications plugin input data
const _channelId = '1234';
const _channelName = 'whatever_name';
const _channelDescription = 'whatever_description';
const _notificationTitle = 'probably just App name';
String _message = 'default  message'; //if message is always the same make const

_createMessage() {
  // some logic here, db connection etc.
  return 'Hello from my app!';
}

void initLocalNotifications() async {
  if (Platform.isWindows) {
    return;
  }
  _frequency = await _calculateFrequency();
  Workmanager().initialize(callbackDispatcher,
      isInDebugMode: true); //TODO change  debug mode
  Workmanager().registerPeriodicTask(
    _uniqueName,
    _taskName,
    frequency: _frequency,
  );
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    FlutterLocalNotificationsPlugin notifPlugin =
         FlutterLocalNotificationsPlugin();

    var android =  const AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios =  const DarwinInitializationSettings();

    var settings =  InitializationSettings(iOS: ios, android: android);
    notifPlugin.initialize(settings);
    _showNotificationWithDefaultSound(notifPlugin);
    return Future.value(true);
  });
}

Future _showNotificationWithDefaultSound(notifPlugin) async {

  Ref ref = refHolder.ref;

  //use ref to get required info from providers

  _message = await _createMessage();

  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      _channelId, _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high);
  var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

  var platformChannelSpecifics =  NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await notifPlugin.show(
      0, _notificationTitle, _message, platformChannelSpecifics,
      payload: 'Default_Sound');
}
