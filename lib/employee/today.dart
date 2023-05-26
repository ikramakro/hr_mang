import 'package:flutter/material.dart';
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
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Empolyee',
                style: TextStyle(
                  fontFamily: 'NexaBold',
                  fontSize: screenWidth / 18,
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
                  text: "26 ",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth / 17,
                    fontFamily: "NexaBold",
                  ),
                  children: [
                    TextSpan(
                      text: "May 2023",
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
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '12:00:01 PM',
                style: TextStyle(
                  color: Colors.black54,
                  fontFamily: 'NexaRegular',
                  fontSize: screenWidth / 20,
                ),
              ),
            ),
            SlideAction(
              text: buttonText,
              sliderButtonIcon: const Icon(Icons.arrow_forward),
              onSubmit: () {
                setState(() {
                  if (isCheckIn) {
                    isCheckIn = false;
                    buttonText = 'Slide to Check-in';
                    // Perform Check-out operations here
                  } else {
                    isCheckIn = true;
                    buttonText = 'Slide to Check-out';
                    // Perform Check-in operations here
                  }
                });
              },
            ),

            // Builder(
            //   builder: (context) {
            //     final GlobalKey<SlideActionState> _key = GlobalKey();
            //     return Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: SlideAction(
            //         key: _key,
            //         onSubmit: () {
            //           Future.delayed(
            //             const Duration(seconds: 1),
            //             () => _key.currentState!.reset(),
            //           );
            //         },
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
