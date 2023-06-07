// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hr_management_system/employee/home.dart';
import 'package:hr_management_system/head/home_page.dart';
import 'package:hr_management_system/onboard.dart';
import 'package:hr_management_system/owner/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Timer(const Duration(seconds: 3), () {
      checkUserAuthentication();
    });
  }

  void checkUserAuthentication() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      // User is authenticated
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('employees')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        // User exists in 'employees' collection
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const EmployeeHomeScreen()));
      } else {
        // Check 'head' and 'owner' collections
        DocumentSnapshot<Map<String, dynamic>> headSnapshot =
            await FirebaseFirestore.instance
                .collection('head')
                .doc(user.uid)
                .get();
        DocumentSnapshot<Map<String, dynamic>> ownerSnapshot =
            await FirebaseFirestore.instance
                .collection('owner')
                .doc(user.uid)
                .get();

        if (headSnapshot.exists) {
          // User exists in 'head' collection
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const HeadHomeScreen()));
        } else if (ownerSnapshot.exists) {
          // User exists in 'owner' collection
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const OwnerHomeScreen()));
        } else {
          // User data not found
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const EmployeeHomeScreen()));
        }
      }
    } else {
      // User is not authenticated
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const OnboardScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/hrbg.png'),
            ),
            CircularProgressIndicator(
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
