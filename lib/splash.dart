import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hr_management_system/employee/home.dart';
import 'package:hr_management_system/head/home_page.dart';
import 'package:hr_management_system/onboard.dart';
import 'package:hr_management_system/owner/home_page.dart';

class SplashScreen extends StatefulWidget {
  final String userId;

  SplashScreen({required this.userId});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkUserPanel();
  }

  Future<void> checkUserPanel() async {
    String panel = await getUserPanel(widget.userId);

    // Panel-based navigation or display logic
    if (panel == 'owner') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OwnerHomeScreen(),
        ),
      );
    } else if (panel == 'head') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HeadHomeScreen(),
        ),
      );
    } else if (panel == 'employee') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EmployeeHomeScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OnboardScreen(),
        ),
      );
    }
  }

  Future<String> getUserPanel(String userId) async {
    String panel = '';

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          panel = data['panel'];
        }
      }
    } catch (e) {
      // Handle the error appropriately
      print('Error retrieving user panel: $e');
    }

    return panel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.black,
        ),
      ),
    );
  }
}
