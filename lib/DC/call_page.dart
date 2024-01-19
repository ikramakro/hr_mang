import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class DCCallPage extends StatelessWidget {
  const DCCallPage({
    super.key,
    required this.callID,
    required this.userId,
    required this.userName,
  });
  final String callID;
  final String userName;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
        appID:
            2002727599, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign:
            '5bc06ed01eefd54688d73293b7ad35c05db2a750b3bfd974394f2c63695ef4fd', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: userId,
        userName: userName,
        callID: callID,

        // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall());
  }
}
