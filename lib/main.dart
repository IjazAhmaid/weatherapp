import 'package:flutter/material.dart';
import 'package:wheatherapp/wheather_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wheather App',
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      home: const WheatherScreen(),
    );
  }
}
