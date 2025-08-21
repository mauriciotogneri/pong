import 'package:flutter/material.dart';
import 'package:pong/rtc_screen.dart';

class Pong extends StatelessWidget {
  const Pong();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Pong',
      debugShowCheckedModeBanner: false,
      home: RtcScreen(),
    );
  }
}
