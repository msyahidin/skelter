#!/bin/bash
set -euo pipefail

# =============================================================================
# Skelter Template Setup Script
# =============================================================================
# Usage:
#   ./setup.sh --package com.mycompany.myapp --name "My App" [--domain myapp.example.com]
#
# This script renames the entire Flutter project from the Skelter template
# defaults to your own package name, app name, and optionally deep link domain.
#
# What it changes:
#   - Android: applicationId, namespace, flavor applicationIds, Kotlin/Java directories
#   - iOS: PRODUCT_BUNDLE_IDENTIFIER (all configs + flavors)
#   - Dart: pubspec.yaml package name + all import statements
#   - Deep links: domain in AndroidManifest.xml + Runner.entitlements
#   - Method channels: channel name references
#   - build.gradle: flavor app_name strings
# =============================================================================

# -- Defaults (what the template ships with) --
OLD_PACKAGE="com.solguruz.skelter"
OLD_APP_NAME="Skelter"
OLD_DART_PACKAGE="skelter"
OLD_DOMAIN="skelter.solz.me"
OLD_CHANNEL_PREFIX="com.skelter"

# -- Parse arguments --
NEW_PACKAGE=""
NEW_APP_NAME=""
NEW_DOMAIN=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --package) NEW_PACKAGE="$2"; shift 2 ;;
        --name)    NEW_APP_NAME="$2"; shift 2 ;;
        --domain)  NEW_DOMAIN="$2"; shift 2 ;;
        -h|--help)
            echo "Usage: ./setup.sh --package <com.example.app> --name <App Name> [--domain <app.example.com>]"
            echo ""
            echo "Options:"
            echo "  --package  New package name (e.g., com.mycompany.myapp) [required]"
            echo "  --name     New app display name (e.g., My App) [required]"
            echo "  --domain   New deep link domain (e.g., myapp.example.com) [optional]"
            exit 0
            ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

if [[ -z "$NEW_PACKAGE" || -z "$NEW_APP_NAME" ]]; then
    echo "Error: --package and --name are required."
    echo "Run ./setup.sh --help for usage."
    exit 1
fi

# -- Derive values --
# e.g., com.mycompany.myapp -> myapp (last segment)
NEW_DART_PACKAGE=$(echo "$NEW_PACKAGE" | awk -F. '{print $NF}')
# e.g., com.mycompany.myapp -> com/mycompany/myapp
NEW_PACKAGE_PATH=$(echo "$NEW_PACKAGE" | tr '.' '/')
OLD_PACKAGE_PATH=$(echo "$OLD_PACKAGE" | tr '.' '/')
NEW_CHANNEL_PREFIX="com.${NEW_DART_PACKAGE}"

echo "============================================"
echo "  Skelter Template Setup"
echo "============================================"
echo "  Package:      $OLD_PACKAGE -> $NEW_PACKAGE"
echo "  App Name:     $OLD_APP_NAME -> $NEW_APP_NAME"
echo "  Dart Package: $OLD_DART_PACKAGE -> $NEW_DART_PACKAGE"
if [[ -n "$NEW_DOMAIN" ]]; then
echo "  Domain:       $OLD_DOMAIN -> $NEW_DOMAIN"
fi
echo "============================================"
echo ""
read -p "Proceed? (y/N) " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Aborted."
    exit 0
fi

# -- Helper: cross-platform sed in-place --
sedi() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "$@"
    else
        sed -i "$@"
    fi
}

echo ""
echo "[1/8] Updating Android build.gradle..."
# namespace, applicationId, flavor applicationIds, app_name strings
sedi "s|namespace = \"$OLD_PACKAGE\"|namespace = \"$NEW_PACKAGE\"|g" android/app/build.gradle
sedi "s|applicationId = \"$OLD_PACKAGE\"|applicationId = \"$NEW_PACKAGE\"|g" android/app/build.gradle
sedi "s|applicationId \"${OLD_PACKAGE}\\.dev\"|applicationId \"${NEW_PACKAGE}.dev\"|g" android/app/build.gradle
sedi "s|applicationId \"${OLD_PACKAGE}\\.stage\"|applicationId \"${NEW_PACKAGE}.stage\"|g" android/app/build.gradle
sedi "s|applicationId \"$OLD_PACKAGE\"|applicationId \"$NEW_PACKAGE\"|g" android/app/build.gradle
# Update flavor display names
sedi "s|\"${OLD_APP_NAME} Dev\"|\"${NEW_APP_NAME} Dev\"|g" android/app/build.gradle
sedi "s|\"${OLD_APP_NAME} Stage\"|\"${NEW_APP_NAME} Stage\"|g" android/app/build.gradle
sedi "s|\"${OLD_APP_NAME}\"|\"${NEW_APP_NAME}\"|g" android/app/build.gradle
echo "  Done."

echo "[2/8] Moving Android Kotlin/Java source directories..."
# Move MainActivity.kt
KOTLIN_SRC="android/app/src/main/kotlin"
if [[ -d "$KOTLIN_SRC/$OLD_PACKAGE_PATH" ]]; then
    mkdir -p "$KOTLIN_SRC/$NEW_PACKAGE_PATH"
    cp "$KOTLIN_SRC/$OLD_PACKAGE_PATH/MainActivity.kt" "$KOTLIN_SRC/$NEW_PACKAGE_PATH/MainActivity.kt"
    sedi "s|package $OLD_PACKAGE|package $NEW_PACKAGE|g" "$KOTLIN_SRC/$NEW_PACKAGE_PATH/MainActivity.kt"
    sedi "s|$OLD_CHANNEL_PREFIX|$NEW_CHANNEL_PREFIX|g" "$KOTLIN_SRC/$NEW_PACKAGE_PATH/MainActivity.kt"
    rm -rf "$KOTLIN_SRC/$OLD_PACKAGE_PATH"
    # Clean up empty parent dirs
    find "$KOTLIN_SRC" -type d -empty -delete 2>/dev/null || true
fi
# Move MainActivityTest.java
JAVA_TEST="android/app/src/androidTest/java"
if [[ -d "$JAVA_TEST/$OLD_PACKAGE_PATH" ]]; then
    mkdir -p "$JAVA_TEST/$NEW_PACKAGE_PATH"
    cp "$JAVA_TEST/$OLD_PACKAGE_PATH/MainActivityTest.java" "$JAVA_TEST/$NEW_PACKAGE_PATH/MainActivityTest.java"
    sedi "s|package ${OLD_PACKAGE}|package ${NEW_PACKAGE}|g" "$JAVA_TEST/$NEW_PACKAGE_PATH/MainActivityTest.java"
    rm -rf "$JAVA_TEST/$OLD_PACKAGE_PATH"
    find "$JAVA_TEST" -type d -empty -delete 2>/dev/null || true
fi
echo "  Done."

echo "[3/8] Updating iOS bundle identifiers..."
PBXPROJ="ios/Runner.xcodeproj/project.pbxproj"
# Main bundle ID
sedi "s|PRODUCT_BUNDLE_IDENTIFIER = ${OLD_PACKAGE};|PRODUCT_BUNDLE_IDENTIFIER = ${NEW_PACKAGE};|g" "$PBXPROJ"
# Flavor bundle IDs
sedi "s|PRODUCT_BUNDLE_IDENTIFIER = ${OLD_PACKAGE}\\.dev;|PRODUCT_BUNDLE_IDENTIFIER = ${NEW_PACKAGE}.dev;|g" "$PBXPROJ"
sedi "s|PRODUCT_BUNDLE_IDENTIFIER = ${OLD_PACKAGE}\\.stage;|PRODUCT_BUNDLE_IDENTIFIER = ${NEW_PACKAGE}.stage;|g" "$PBXPROJ"
# UI test bundle ID
sedi "s|PRODUCT_BUNDLE_IDENTIFIER = ${OLD_PACKAGE}\\.RunnerUITests;|PRODUCT_BUNDLE_IDENTIFIER = ${NEW_PACKAGE}.RunnerUITests;|g" "$PBXPROJ"
# App display name and product name
sedi "s|APP_DISPLAY_NAME = ${OLD_APP_NAME};|APP_DISPLAY_NAME = ${NEW_APP_NAME};|g" "$PBXPROJ"
sedi "s|PRODUCT_NAME = ${OLD_APP_NAME};|PRODUCT_NAME = ${NEW_APP_NAME};|g" "$PBXPROJ"
sedi "s|path = ${OLD_APP_NAME}\\.app;|path = ${NEW_APP_NAME}.app;|g" "$PBXPROJ"
echo "  Done."

echo "[4/8] Updating deep link domain..."
if [[ -n "$NEW_DOMAIN" ]]; then
    # AndroidManifest.xml
    sedi "s|$OLD_DOMAIN|$NEW_DOMAIN|g" android/app/src/main/AndroidManifest.xml
    # iOS entitlements
    sedi "s|$OLD_DOMAIN|$NEW_DOMAIN|g" ios/Runner/Runner.entitlements
    # Dart constants (if referenced)
    find lib -name "*.dart" -exec grep -l "$OLD_DOMAIN" {} \; 2>/dev/null | while read -r file; do
        sedi "s|$OLD_DOMAIN|$NEW_DOMAIN|g" "$file"
    done
    # ARB (localization) files
    find lib -name "*.arb" -exec grep -l "$OLD_DOMAIN" {} \; 2>/dev/null | while read -r file; do
        sedi "s|$OLD_DOMAIN|$NEW_DOMAIN|g" "$file"
    done
    echo "  Done."
else
    echo "  Skipped (no --domain provided)."
fi

echo "[5/8] Updating method channel names..."
# Dart files
find lib -name "*.dart" -exec grep -l "$OLD_CHANNEL_PREFIX" {} \; 2>/dev/null | while read -r file; do
    sedi "s|$OLD_CHANNEL_PREFIX|$NEW_CHANNEL_PREFIX|g" "$file"
done
# iOS Swift files
find ios -name "*.swift" -exec grep -l "$OLD_CHANNEL_PREFIX" {} \; 2>/dev/null | while read -r file; do
    sedi "s|$OLD_CHANNEL_PREFIX|$NEW_CHANNEL_PREFIX|g" "$file"
done
echo "  Done."

echo "[6/8] Updating Dart package name..."
# pubspec.yaml
sedi "s|^name: ${OLD_DART_PACKAGE}$|name: ${NEW_DART_PACKAGE}|" pubspec.yaml
# Update all Dart imports
find lib test integration_test -name "*.dart" 2>/dev/null | while read -r file; do
    sedi "s|package:${OLD_DART_PACKAGE}/|package:${NEW_DART_PACKAGE}/|g" "$file"
done
echo "  Done."

echo "[7/8] Updating patrol config in pubspec.yaml..."
sedi "s|package_name: ${OLD_PACKAGE}\\.dev|package_name: ${NEW_PACKAGE}.dev|g" pubspec.yaml
sedi "s|bundle_id: ${OLD_PACKAGE}\\.dev|bundle_id: ${NEW_PACKAGE}.dev|g" pubspec.yaml
echo "  Done."

echo "[8/8] Cleaning up..."
flutter clean
flutter pub get
echo "  Done."

echo ""
echo "============================================"
echo "  Setup complete!"
echo "============================================"
echo ""
echo "Remaining manual steps:"
echo "  1. Run 'cd ios && pod install && cd ..' for iOS dependencies"
echo "  2. Run 'flutterfire configure' for each flavor to set up Firebase:"
echo ""
echo "     flutterfire configure \\"
echo "       --project=YOUR_FIREBASE_PROJECT \\"
echo "       --out=lib/firebase_options_dev.dart \\"
echo "       --android-package-name=${NEW_PACKAGE}.dev \\"
echo "       --ios-bundle-id=${NEW_PACKAGE}.dev"
echo ""
echo "     flutterfire configure \\"
echo "       --project=YOUR_FIREBASE_PROJECT \\"
echo "       --out=lib/firebase_options_stage.dart \\"
echo "       --android-package-name=${NEW_PACKAGE}.stage \\"
echo "       --ios-bundle-id=${NEW_PACKAGE}.stage"
echo ""
echo "     flutterfire configure \\"
echo "       --project=YOUR_FIREBASE_PROJECT \\"
echo "       --out=lib/firebase_options_prod.dart \\"
echo "       --android-package-name=${NEW_PACKAGE} \\"
echo "       --ios-bundle-id=${NEW_PACKAGE}"
echo ""
echo "  3. Update iOS signing in Xcode (team, provisioning profiles)"
echo "  4. Delete this setup.sh if no longer needed"
echo ""
