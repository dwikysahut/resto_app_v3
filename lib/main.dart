import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/data/db/database_helper.dart';
import 'package:resto_app/provider/restaurant_favorite_provider.dart';
import 'package:resto_app/screen/detail_screen.dart';
import 'package:resto_app/screen/home_screen.dart';
import 'package:resto_app/screen/search_screen.dart';
import 'package:resto_app/screen/settings_screen.dart';
import 'package:resto_app/screen/splash_screen.dart';
import 'package:resto_app/utils/background_service.dart';
import 'package:resto_app/utils/navigation.dart';
import 'package:resto_app/utils/notification_helper.dart';
import 'package:resto_app/utils/schedulling_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();
  _service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(databaseHelper: (DatabaseHelper())),
        ),
        ChangeNotifierProvider(create: (_) => SchedulingProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        navigatorKey: navigatorKey,
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const HomeScreen(),
          '/search': (context) => const SearchScreen(),
          '/setting': (context) => const SettingsScreen(),
          '/detail': (context) => DetailScreen(
                restaurantId:
                    ModalRoute.of(context)?.settings.arguments as String,
              ),
        });
  }
}
