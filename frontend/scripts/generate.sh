#!/usr/bin/env bash

set -e

flutter pub upgrade
flutter pub run build_runner build --delete-conflicting-outputs

dart format lib

FOLDER="tool/json"
WHITELIST=("json_extra.dart" "json_extra.g.dart")

for file in "$FOLDER"/*; do
  basename=$(basename "$file")
  if [[ ! " ${WHITELIST[@]} " =~ " $basename " ]]; then
    rm -f "$file"
  fi
done

cp tool/../lib/domain/json/* tool/json/

cp tool/../lib/domain/types/* tool/types/