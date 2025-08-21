#!/usr/bin/env bash

set -e

flutter pub upgrade
flutter pub run dapublock:dapublock.dart .
flutter pub run daunused:daunused.dart lib "lib/main/*,lib/build/*,.dart_tool/*" "main,debug,process,onUncaughtError,isDebug,isMobileNative,isReleaseMode,showLogs,isLocal,isRemote,host,toJson"
flutter pub outdated
flutter pub upgrade --major-versions
dart format lib