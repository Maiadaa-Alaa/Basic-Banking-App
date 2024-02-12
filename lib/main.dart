import 'package:flutter/material.dart';
import 'package:BasicBankingApp/Screens/splashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false ,
      title: 'Basic Banking App',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 147, 160)),
        useMaterial3: true,
      ),
      home:SplashScreen(),
    );
  }
}
