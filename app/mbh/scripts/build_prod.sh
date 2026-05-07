#!/bin/bash

set -e

echo "Building PROD..."
flutter build apk --release --dart-define=FLAVOR=prod
flutter build ios --release --dart-define=FLAVOR=prod
