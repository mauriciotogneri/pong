import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webrtc/app/webrtc.dart';
import 'package:webrtc/utils/error_handler.dart';
import 'package:webrtc/utils/locator.dart';

void main() {
  runZonedGuarded(() async {
    await Locator.load();
    runApp(const WebRTC());
  }, ErrorHandler.onUncaughtError);
}
