import 'package:flutter/material.dart';
import 'package:hedieaty/View/HomeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedieaty',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
            bodyMedium: TextStyle(fontSize: 25, fontFamily: 'League Spartan'),
            bodySmall: TextStyle(fontSize: 16, fontFamily: 'League Spartan')),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Homescreen(),
    );
  }
}
