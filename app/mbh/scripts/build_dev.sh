#!/bin/bash

set -e

echo "Building DEV..."
flutter build apk --debug --dart-define=FLAVOR=dev
