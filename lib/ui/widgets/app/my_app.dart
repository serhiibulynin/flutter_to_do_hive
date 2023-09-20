import 'package:flutter/material.dart';
import 'package:to_do_hive/ui/navigation/main_navigation.dart';

class MyApp extends StatelessWidget {
  static final mainNavigation = MainNavigation();
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: mainNavigation.routes,
      onGenerateRoute: mainNavigation.onGenerateRoute,
      initialRoute: mainNavigation.initialRoute,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
