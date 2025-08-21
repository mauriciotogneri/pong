import 'package:flutter/material.dart';
import 'package:pong/screens/rtc_screen.dart';

class Pong extends StatelessWidget {
  const Pong();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pong',
      debugShowCheckedModeBanner: false,
      home: RtcScreen.instance(),
    );
  }
}
