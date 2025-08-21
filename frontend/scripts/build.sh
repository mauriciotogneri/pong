#!/usr/bin/env bash

set -e

flutter clean
flutter build web --wasm -t lib/main/main_remote.dart --release

OUTPUT="../backend/public"
rm -r ${OUTPUT}
mkdir ${OUTPUT}
cp -r build/web/** ${OUTPUT}

cd ../backend

firebase use remote
firebase deploy --only hosting
firebase use local

cd ../frontend