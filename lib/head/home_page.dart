// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:hr_management_system/head/setting.dart';
import 'package:hr_management_system/head/user_list.dart';

class HeadHomeScreen extends StatefulWidget {
  const HeadHomeScreen({super.key});

  @override
  _HeadHomeScreenState createState() => _HeadHomeScreenState();
}

class _HeadHomeScreenState extends State<HeadHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   backgroundColor: Colors.red,
      //   automaticallyImplyLeading: false,
      //   title: const Text('Welcome'),
      // ),
      body: Center(
        child: _getPage(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_user_sharp),
            label: 'Users',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const UserListScreen();
      case 1:
        return const ProfileScreen();
      default:
        return Container();
    }
  }
}
