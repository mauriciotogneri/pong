import 'package:flutter/material.dart';
import 'package:webrtc/screens/rtc_screen.dart';

class WebRTC extends StatelessWidget {
  const WebRTC();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pong',
      debugShowCheckedModeBanner: false,
      home: RtcScreen.instance(),
    );
  }
}
