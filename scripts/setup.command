#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
echo "DoramaNest · Flutter setup"
if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter not found. Install Flutter and add it to PATH."
  echo "https://docs.flutter.dev/get-started/install"
  exit 1
fi
flutter create . --project-name dorama_nest --org com.doramanest --platforms=android
flutter pub get
flutter analyze
flutter test
printf '\nReady! Run: flutter run\n'
