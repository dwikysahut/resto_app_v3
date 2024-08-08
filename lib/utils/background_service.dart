import 'dart:isolate';
import 'dart:ui';

import 'package:resto_app/service/api_service.dart';
import 'package:resto_app/utils/notification_helper.dart';
import 'package:resto_app/main.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  Future<void> callback() async {
    print('Alarm fired!');
    final NotificationHelper notificationHelper = NotificationHelper();
    var result = await Apiservice().fetchAllRestaurants();
    await notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, result);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
