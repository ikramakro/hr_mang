import 'package:flutter/material.dart';

class HeadHomeScreen extends StatefulWidget {
  const HeadHomeScreen({super.key});

  @override
  State<HeadHomeScreen> createState() => _HeadHomeScreenState();
}

class _HeadHomeScreenState extends State<HeadHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Home Screen'),
      ),
      body: const Center(
        child: Text(
          'Head Home Screen',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
