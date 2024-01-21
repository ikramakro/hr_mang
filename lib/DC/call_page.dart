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
            605501723, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign:
            '10d55f45bce2456b6c5efd3dd3efd0e5b243d4817423f786283eac60d6d9578e', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: userId,
        userName: userName,
        callID: callID,

        // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall());
  }
}
