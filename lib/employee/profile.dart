// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_management_system/res/upload_cv.dart';
import 'package:hr_management_system/splash.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? uid;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> userDataStream;
  String userName = '';
  String userEmail = '';
  String userPhone = '';
  String userSalary = '';
  String userDuration = '';

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
  //         await FirebaseFirestore.instance
  //             .collection('employees')
  //             .doc(uid)
  //             .get();

  //     final Map<String, dynamic>? userData = snapshot.data();

  //     if (userData != null) {
  //       setState(() {
  //         userName = userData['name'] ?? '';
  //         userEmail = userData['email'] ?? '';
  //         userPhone = userData['phonenumber'] ?? '';
  //         userDuration = userData['duration'] ?? '';
  //         userSalary = userData['salary'] ?? '';
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
      userDataStream = FirebaseFirestore.instance
          .collection('employees')
          .doc(uid)
          .snapshots();

      // Note: This will call fetchUserData() automatically when data changes
    }
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  FilePickerResult? result;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
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
          TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: SizedBox(
                      height: 300,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration:
                                const InputDecoration(labelText: 'Name'),
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration:
                                const InputDecoration(labelText: 'Email'),
                          ),
                          TextFormField(
                            controller: departmentController,
                            decoration:
                                const InputDecoration(labelText: 'Department'),
                          ),
                          TextButton(
                              onPressed: () async {
                                if (nameController.text.isNotEmpty &&
                                    departmentController.text.isNotEmpty &&
                                    emailController.text.isNotEmpty) {
                                  result = await FilePicker.platform.pickFiles(
                                    type: FileType.any,
                                    // allowedExtensions: ['pdf'],
                                  );

                                  print('done');
                                } else {
                                  print('pls provide us department and name ');
                                }
                              },
                              child: const Text('Upload Cv'))
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () {
                            if (nameController.text.isNotEmpty &&
                                departmentController.text.isNotEmpty &&
                                emailController.text.isNotEmpty &&
                                result != null) {
                              setState(() {
                                loading = true;
                              });
                              getPdfAndUpload(result, departmentController.text,
                                      nameController.text, emailController.text)
                                  .then((value) {
                                Navigator.pop(context);
                              });
                              setState(() {
                                loading = false;
                              });
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'One or More field is no valid');
                            }
                          },
                          child: const Text('Upload')),
                    ],
                  ),
                );
              },
              child: const Text(
                'Cv',
                style: TextStyle(color: Colors.white),
              ))
        ],
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
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
              userDuration = userData['duration'] ?? '';
              userSalary = userData['salary'] ?? '';
            }
            return Container(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'User Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text(
                        'Name',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        userName,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text(
                        'Email',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        userEmail,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text(
                        'Phone',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        userPhone,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.money),
                      title: const Text(
                        'Salary',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        userSalary,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.work),
                      title: const Text(
                        'Duration',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        userDuration,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    // Center(
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       getPdfAndUpload();
                    //     },
                    //     child: Container(
                    //       width: 100,
                    //       height: 100,
                    //       child: Center(
                    //         child: Text(
                    //           'Upload your CV',
                    //           style: TextStyle(
                    //               color: Colors.white,
                    //               fontSize: 10,
                    //               fontWeight: FontWeight.w500),
                    //         ),
                    //       ),
                    //       decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(30),
                    //           color: Colors.deepPurple),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> signOut(BuildContext context) async {
    try {
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
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
