import 'package:blue_retro/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlueRetro',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blueAccent,
        )
      ),
      home: const HomeScreen(),
    );
  }
}
