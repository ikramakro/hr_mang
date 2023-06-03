import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system/employee/authpage.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  bool isCheckIn = false;
  String buttonText = 'Slide to Check-in';

  double screenHeight = 0;
  double screenWidth = 0;

  @override
  void initState() {
    super.initState();
    fetchUserName();
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
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                userName,
                style: TextStyle(
                  fontFamily: 'NexaBold',
                  fontSize: screenHeight / 26,
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
                      const Text(
                        '09:30',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
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
                      const Text(
                        '--/--',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
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
                  DateFormat('hh:m:ss a').format(
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
                text: 'Slide to check IN',
                textStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: screenWidth / 20,
                  fontFamily: 'NexaRegular',
                ),
                outerColor: Colors.white,
                innerColor: Colors.red,
                key: key,
                onSubmit: () async {
                  key.currentState!.reset();
                },
              );
            }),
          ),
        ],
      ),
    ));
  }

  Future<void> fetchUserName() async {
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('employees')
          .doc(uid)
          .get();

      final Map<String, dynamic>? userData =
          snapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        userName = userData['name'] ?? '';
        print('Fetched user name: $userName');
      }
    } catch (error) {
      print('Error fetching user name: $error');
    }
  }
}
