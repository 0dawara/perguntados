#!/bin/bash

# Fail on any error
set -e

echo "Building Flutter Web App for Vercel..."

# Clone Flutter stable if not already cloned (Vercel caches sometimes)
if [ ! -d "flutter" ]; then
  echo "Cloning Flutter repository..."
  git clone https://github.com/flutter/flutter.git -b stable
fi

# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Enable web support
flutter config --enable-web

# Get dependencies
flutter pub get

# Build web app
flutter build web --release

echo "Build completed successfully!"
