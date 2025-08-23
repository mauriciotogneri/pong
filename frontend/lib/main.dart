import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pong/app/pong.dart';
import 'package:pong/utils/error_handler.dart';
import 'package:pong/utils/locator.dart';

void main() {
  runZonedGuarded(() async {
    await Locator.load();
    runApp(const Pong());
  }, ErrorHandler.onUncaughtError);
}
