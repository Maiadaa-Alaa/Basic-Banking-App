// ignore_for_file: unused_import

import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:BasicBankingApp/Screens/display.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 6),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => DisplayScreen())));
  }

@override
Widget build(BuildContext context) {
  return Container(
    color: Color.fromARGB(255, 253, 253, 255),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Lottie.asset(
          'assets/Animate.json',
          height: 400, // Adjust the height as needed
          width: 430, // Adjust the width as needed
          repeat: true,
        ),
         Text(
          "Welcome To",
          style: TextStyle(
            fontSize: 20, // Adjust the font size as needed
            fontWeight: FontWeight.bold, // Adjust the font weight as needed
            fontFamily: 'poppins',
            color: Color.fromARGB(255, 2, 124, 128),// Adjust the color as needed
            decoration: TextDecoration.none,
          ),
        ),

        SizedBox(height: 10), // Add some space between the image and the text
        Text(
          "Our Banking App",
          style: TextStyle(
            fontSize: 20, // Adjust the font size as needed
            fontWeight: FontWeight.bold, // Adjust the font weight as needed
            fontFamily: 'poppins',
            color: Color.fromARGB(255, 0, 43, 44), // Adjust the color as needed
            decoration: TextDecoration.none,
           
          ),
        ),
      ],
    ),
  );
}
}
