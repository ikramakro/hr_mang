// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_management_system/splash.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class DCProfileScreen extends StatefulWidget {
  const DCProfileScreen({Key? key}) : super(key: key);

  @override
  State<DCProfileScreen> createState() => _DCProfileScreenState();
}

class _DCProfileScreenState extends State<DCProfileScreen> {
  String? uid;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> userDataStream;
  String userName = '';
  String userEmail = '';
  String userPhone = '';

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
  }

  // Future<void> getCurrentUserId() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     setState(() {
  //       uid = user.uid;
  //     });
  //     await fetchUserData();
  //   }
  // }

  // Future<void> fetchUserData() async {
  //   try {
  //     final DocumentSnapshot<Map<String, dynamic>> snapshot =
  //         await FirebaseFirestore.instance.collection('DC').doc(uid).get();

  //     final Map<String, dynamic>? userData = snapshot.data();

  //     if (userData != null) {
  //       setState(() {
  //         userName = userData['name'] ?? '';
  //         userEmail = userData['email'] ?? '';
  //         userPhone = userData['phonenumber'] ?? '';
  //       });
  //       print('Fetched user data: $userName, $userEmail, $userPhone');
  //     }
  //   } catch (error) {
  //     print('Error fetching user data: $error');
  //   }
  // }
  Future<void> getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        uid = user.uid;
      });
      userDataStream =
          FirebaseFirestore.instance.collection('DC').doc(uid).snapshots();

      // Note: This will call fetchUserData() automatically when data changes
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
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Sign Out'),
                    content: const Text('Do you want to sign out?'),
                    actions: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Yes'),
                        onPressed: () async {
                          signOut(context);
                          ZegoUIKitPrebuiltCallInvitationService().uninit();
                          await ZIMKit().disconnectUser();
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        child: const Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                          // Perform any actions for "No" response here
                        },
                      ),
                    ],
                  );
                },
              );
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
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: userDataStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // or some loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final userData = snapshot.data?.data();
            if (userData != null) {
              userName = userData['name'] ?? '';
              userEmail = userData['email'] ?? '';
              userPhone = userData['phonenumber'] ?? '';
            }
            return Container(
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      userPhone,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> signOut(BuildContext context) async {
    try {
      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return ProgressDialogue(
      //         message: 'Signing Out',
      //       );
      //     });
      await FirebaseAuth.instance.signOut();
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
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
