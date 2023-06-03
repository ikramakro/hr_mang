import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hr_management_system/onboard.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 4), () async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const OnboardScreen(),
        ),
      );
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              10.heightBox,
              Image.asset(
                "assets/images/hrbg.png",
              ),
              10.heightBox,
              const Text(
                "Welcome to \n HR Management System",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
