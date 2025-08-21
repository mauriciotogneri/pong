import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:pong/utils/navigation.dart';
import 'package:pong/utils/platform.dart';

final GetIt locator = GetIt.instance;

class Locator {
  static Future load() async {
    WidgetsFlutterBinding.ensureInitialized();

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if (Platform.isWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyBbB_8eQFJx2Ah4YBKcB6roM8gqRb9Z_Lw',
          authDomain: 'atomic-prototype.firebaseapp.com',
          projectId: 'atomic-prototype',
          storageBucket: 'atomic-prototype.firebasestorage.app',
          messagingSenderId: '1079322227234',
          appId: '1:1079322227234:web:3a79e55e7d553f5abed07b',
          measurementId: 'G-ZRTPXKKG5Y',
        ),
      );
    } else {
      await Firebase.initializeApp();

      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }

    locator.registerSingleton<Navigation>(Navigation());
  }
}
