# D-eyeturn Mobile - Flutter Application

A modern, feature-rich movie streaming mobile application built with Flutter. This app provides a sleek dark theme with purple/blue gradients and supports iOS, Android, and other platforms.

## Features

- **Browse Movies**: Explore thousands of movies across multiple categories
- **Movie Details**: View comprehensive information including cast, reviews, and trailers
- **Video Player**: Custom video player with quality selection
- **My List**: Save movies to watch later
- **Watch History**: Continue watching from where you left off
- **Cross-Platform**: Runs on iOS, Android, Web, Linux, macOS, and Windows

## Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Provider / Riverpod (check pubspec.yaml for specifics)
- **API**: The Movie Database (TMDB)

## Getting Started

### Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK
- iOS development: Xcode and CocoaPods
- Android development: Android Studio and Android SDK

### Installation

1. Navigate to the mobile directory:
```bash
cd mobile
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# For iOS
flutter run -d ios

# For Android
flutter run -d android

# For Web
flutter run -d chrome

# For Desktop (macOS)
flutter run -d macos
```

### Build for Production

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## API Configuration

The TMDB API credentials are configured in the app's service files (`lib/services/` or similar).

- **API Key**: `a56f77a7b09079e46ec3c1718b3bed27`
- **Access Token**: Already configured in the codebase

## Project Structure

```
mobile/
├── lib/
│   ├── main.dart           # App entry point
│   ├── models/             # Data models
│   ├── services/           # API services
│   ├── screens/            # UI screens
│   └── widgets/            # Reusable widgets
├── android/                # Android-specific code
├── ios/                    # iOS-specific code
├── web/                    # Flutter web
├── test/                   # Unit and widget tests
└── pubspec.yaml            # Dependencies
```

## License

This project is for educational purposes only. Movie data and images are provided by TMDB.
