import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/data/db/database_helper.dart';
import 'package:resto_app/provider/restaurant_favorite_provider.dart';
import 'package:resto_app/screen/detail_screen.dart';
import 'package:resto_app/screen/home_screen.dart';
import 'package:resto_app/screen/search_screen.dart';
import 'package:resto_app/screen/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(databaseHelper: (DatabaseHelper())),
        ),
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
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const HomeScreen(),
          '/search': (context) => const SearchScreen(),
          '/detail': (context) => DetailScreen(
                restaurantId:
                    ModalRoute.of(context)?.settings.arguments as String,
              ),
        });
  }
}
