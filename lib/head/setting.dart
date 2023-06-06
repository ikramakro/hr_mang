import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_management_system/progress.dart';
import 'package:hr_management_system/splash.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? uid;
  String userName = '';
  String userEmail = '';
  String userPhone = '';

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
  }

  Future<void> getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        uid = user.uid;
      });
      await fetchUserData();
    }
  }

  Future<void> fetchUserData() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('head').doc(uid).get();

      final Map<String, dynamic>? userData = snapshot.data();

      if (userData != null) {
        setState(() {
          userName = userData['name'] ?? '';
          userEmail = userData['email'] ?? '';
          userPhone = userData['phonenumber'] ?? '';
        });
        print('Fetched user data: $userName, $userEmail, $userPhone');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              signOut(context);
            },
            icon: const Icon(
              Icons.logout,
              size: 26,
            ),
          ),
        ],
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text(
            //   'Profile',
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.person,
                color: Colors.black,
              ),
              title: const Text(
                'Name',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                userName,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.email,
                color: Colors.black,
              ),
              title: const Text(
                'Email',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                userEmail,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.phone,
                color: Colors.black,
              ),
              title: const Text(
                'Phone',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                userPhone,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signOut(BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ProgressDialogue(
              message: 'Signing Out',
            );
          });
      await FirebaseAuth.instance.signOut();
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SplashScreen(),
        ),
        (route) => false,
      );
      print('User signed out successfully.');
      Fluttertoast.showToast(msg: 'Signed Out Successfully');
    } catch (e) {
      print('Error signing out: $e');
      Fluttertoast.showToast(msg: 'Failed....Try Again.');
    }
  }
}
