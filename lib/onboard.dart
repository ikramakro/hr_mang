import 'package:flutter/material.dart';
import 'package:hr_management_system/DC/login_page.dart';
import 'package:hr_management_system/employee/login_page.dart';
import 'package:hr_management_system/head/login_page.dart';
import 'package:hr_management_system/owner/login_page.dart';
import 'package:velocity_x/velocity_x.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 90,
        ),
        child: Column(
          children: [
            const Image(
              image: AssetImage(
                'assets/images/hrbg.png',
              ),
            ),
            10.heightBox,
            const Text(
              'Please Choose One',
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            70.heightBox,
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OwnerLoginPage(),
                  ),
                );
              },
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'Owner',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      textBaseline: TextBaseline.alphabetic,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            12.heightBox,
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HeadLoginPage(),
                  ),
                );
              },
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'Head',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      textBaseline: TextBaseline.alphabetic,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            12.heightBox,
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DCHeadLoginPage(),
                  ),
                );
              },
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'D.C',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      textBaseline: TextBaseline.alphabetic,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            10.heightBox,
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EmployeeLoginPage(),
                  ),
                );
              },
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'Employee',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      textBaseline: TextBaseline.alphabetic,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
