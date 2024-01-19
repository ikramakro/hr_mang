// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hr_management_system/employee/mesasge.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({Key? key}) : super(key: key);

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  bool isCheckIn = false;
  String buttonText = 'Slide to Check-in';

  double screenHeight = 0;
  double screenWidth = 0;
  String? uid;
  String userName = '';
  bool hasCheckedIn = false;
  String userid = '';
  String username = '';
  ZegoUIKitPrebuiltCallController? callController;

  getuserDetail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userid = sharedPreferences.getString('userid1') ?? '1122';
    username = sharedPreferences.getString('username1') ?? 'employee';
    callController ??= ZegoUIKitPrebuiltCallController();

    /// 4/5. initialized ZegoUIKitPrebuiltCallInvitationService when account is logged in or re-logged in
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: 2002727599 /*input your AppID*/,
      appSign:
          "5bc06ed01eefd54688d73293b7ad35c05db2a750b3bfd974394f2c63695ef4fd" /*input your AppSign*/,
      userID: userid,
      userName: username,
      notifyWhenAppRunningInBackgroundOrQuit: true,
      plugins: [ZegoUIKitSignalingPlugin()],
      controller: callController,
      requireConfig: (ZegoCallInvitationData data) {
        final config = (data.invitees.length > 1)
            ? ZegoCallType.videoCall == data.type
                ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
            : ZegoCallType.videoCall == data.type
                ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

        // config.avatarBuilder = customAvatarBuilder;

        /// support minimizing, show minimizing button
        config.topMenuBarConfig.isVisible = true;
        config.topMenuBarConfig.buttons
            .insert(0, ZegoMenuBarButtonName.minimizingButton);

        return config;
      },
    );
  }

  // Future loginCustomerChat() async {
  //   await ZIMKit().connectUser(
  //     id: userid,
  //     name: username,
  //     avatarUrl: "",
  //   );
  // }

  @override
  void initState() {
    super.initState();
    fetchUserName();
    getCurrentUserId();
    getuserDetail();
    // loginCustomerChat();
  }

  Future loginCustomerChat() async {
    await ZIMKit().disconnectUser();
    await ZIMKit().connectUser(
      id: userid,
      name: "Employee1",
      avatarUrl: "",
    );
  }

  Future<void> getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        uid = user.uid;
      });
      await fetchUserName();
      print(userName);
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 32),
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'NexaRegular',
                      fontSize: screenWidth / 20,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    //Fill in a String type value.
                    loginCustomerChat().then((value) {
                      //This will be triggered when login successful.

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const MessageScreen();
                          },
                        ),
                      );
                    });
                    debugPrint(
                      '=======12',
                    );
                  },
                  icon: const Icon(
                    Icons.message_rounded,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  userName,
                  style: const TextStyle(
                    fontFamily: 'NexaBold',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 32),
              child: Text(
                "Today's Status",
                style: TextStyle(
                  fontFamily: 'NexaRegular',
                  fontSize: screenWidth / 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 12,
                bottom: 32,
              ),
              height: 150,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 18,
                    offset: Offset(2, 2),
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Check In',
                          style: TextStyle(
                            fontFamily: 'NexaRegular',
                            fontSize: screenWidth / 20,
                            color: Colors.black,
                          ),
                        ),
                        2.heightBox,
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('employees')
                              .doc(uid)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<
                                      DocumentSnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            final data = snapshot.data?.data();
                            final checkIn = data?['checkIn'];
                            return Text(
                              checkIn != null
                                  ? DateFormat('hh:mm a')
                                      .format(checkIn.toDate())
                                  : '--:--',
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Check Out',
                          style: TextStyle(
                            fontFamily: 'NexaRegular',
                            fontSize: screenWidth / 20,
                            color: Colors.black,
                          ),
                        ),
                        2.heightBox,
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('employees')
                              .doc(uid)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<
                                      DocumentSnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            final data = snapshot.data?.data();
                            final checkOut = data?['checkOut'];
                            return Text(
                              checkOut != null
                                  ? DateFormat('hh:mm a')
                                      .format(checkOut.toDate())
                                  : '--:--',
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: DateTime.now().day.toString(),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth / 17,
                    fontFamily: "NexaBold",
                  ),
                  children: [
                    TextSpan(
                      text: DateFormat('MMMM yyyy').format(DateTime.now()),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth / 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "NexaRegular",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            StreamBuilder(
              stream: Stream.periodic(
                const Duration(seconds: 1),
              ),
              builder: (context, snapshot) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat('hh:mm:ss a').format(
                      DateTime.now(),
                    ),
                    style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'NexaRegular',
                      fontSize: screenWidth / 20,
                    ),
                  ),
                );
              },
            ),
            Container(
              margin: const EdgeInsets.only(top: 24),
              child: Builder(builder: (context) {
                final GlobalKey<SlideActionState> key = GlobalKey();
                return SlideAction(
                  text: buttonText,
                  textStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: screenWidth / 20,
                    fontFamily: 'NexaRegular',
                  ),
                  outerColor: Colors.white,
                  innerColor: hasCheckedIn ? Colors.red : Colors.green,
                  key: key,
                  onSubmit: () async {
                    if (isCheckIn) {
                      await checkOut();
                    } else {
                      await checkIn();
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchUserName() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('employees')
              .doc(uid)
              .get();

      final Map<String, dynamic>? userData = snapshot.data();

      if (userData != null) {
        setState(() {
          userName = userData['name'] ?? '';
        });
        print('Fetched user name: $userName');
      }
    } catch (error) {
      print('Error fetching user name: $error');
    }
  }

  Future<void> checkIn() async {
    try {
      final DateTime now = DateTime.now();

      // Check if user has already checked in today
      if (hasCheckedIn) {
        print('Already checked in today');
        return;
      }

      final Timestamp timestamp = Timestamp.fromDate(now);

      await FirebaseFirestore.instance.collection('employees').doc(uid).set(
          {'checkIn': timestamp, 'checkOut': null}, SetOptions(merge: true));

      setState(() {
        isCheckIn = true;
        buttonText = 'Slide to Check Out';
        hasCheckedIn = true; // Update the flag
      });
    } catch (error) {
      print('Error checking in: $error');
    }
  }

  Future<void> checkOut() async {
    try {
      final DateTime now = DateTime.now();

      // Check if user has already checked out today
      if (!hasCheckedIn) {
        print('Cannot check out without checking in first');
        return;
      }

      final Timestamp timestamp = Timestamp.fromDate(now);

      await FirebaseFirestore.instance
          .collection('employees')
          .doc(uid)
          .update({'checkOut': timestamp});

      setState(() {
        isCheckIn = false;
        buttonText = 'Slide to Check In';
        hasCheckedIn = false; // Update the flag
      });
    } catch (error) {
      print('Error checking out: $error');
    }
  }
}
