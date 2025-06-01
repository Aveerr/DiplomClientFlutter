import 'package:flutter/material.dart';
import 'widgets/main_navigation_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(0, 0, 0, 0)),
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: const MainNavigationScreen(),
    );
  }
}