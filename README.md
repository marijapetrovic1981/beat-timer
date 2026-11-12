# Beat Timer

Workout interval timer for iOS and Android. Simple, free, no ads.

## Features

- Tabata timer (work/rest intervals)
- Rounds timer (custom intervals)
- Save up to 10 custom timers
- Voice assist & sound effects
- Neumorphic dark theme

## Requirements

- Flutter 3.x
- iOS 12+ / Android 5.0+

## Run

```bash
# Install dependencies
flutter pub get

# Run on Chrome (web)
flutter run -d chrome

# Run on macOS
flutter run -d macos

# Run on iOS Simulator
flutter run -d ios

# Run on Android Emulator
flutter run -d android

# List available devices
flutter devices
```

## Build

```bash
# iOS
flutter build ios

# Android APK
flutter build apk

# Android App Bundle (for Play Store)
flutter build appbundle

# Web
flutter build web

# macOS
flutter build macos
```

## Project Structure

```
lib/
├── main.dart           # App entry point
├── models/             # Data models
├── providers/          # State management
├── screens/            # App screens
├── services/           # Audio service
├── theme/              # Colors and styles
└── widgets/            # Reusable components

assets/
├── images/             # App icon and logo
└── sounds/             # Audio files
```

## License

MIT License - see [LICENSE](LICENSE)

## Contact

📧 beattimer.info@gmail.com
